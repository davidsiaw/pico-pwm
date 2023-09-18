C_FILES = $(shell find src/ -type f -name '*.c')
H_FILES = $(shell find src/ -type f -name '*.h')

C_TEST_FILES = $(shell find tests/ -type f -name '*.c')
C_TEST_BINS = $(patsubst tests/%.c, $(TEST_OBJ_DIR)/%_c.test, $(C_TEST_FILES))
TEST_RESULTS = $(patsubst $(TEST_OBJ_DIR)/%.test, $(TEST_OBJ_DIR)/%.test.result, $(C_TEST_BINS))

TEST_OBJ_DIR = test_obj
TEST_C_DEPS = $(C_FILES)
TEST_C_DEP_OBJS = $(patsubst src/%.c, $(TEST_OBJ_DIR)/%_cdep.o, $(C_FILES))

TEST_DEP_EXTRACTOR=cat $^ | grep -Po "(/\*\+test\+)\K(.+?)(?=\*/)"

# colors
RED_TEXT ?= \e[31m
GREEN_TEXT ?= \e[32m
NORMAL_TEXT ?= \e[0m

# colored text
RFAIL = $(RED_TEXT)FAIL$(NORMAL_TEXT)
RPASS = $(GREEN_TEXT)PASS$(NORMAL_TEXT)

# docker commands
DCMDBASE = docker run --rm -v ${PWD}:/src
DIMAGE := davidsiaw/picoci
DPRIV = -v /dev:/dev --privileged --user=root

CC = gcc
CFLAGS = -Isrc -Wall

all: build

build/main.uf2: build

build: cmake/sourcelist.cmake $(H_FILES)
	@mkdir -p build
	@chmod -R 777 build
	@$(DCMDBASE) $(DIMAGE) sh scripts/build.sh

cmake/sourcelist.cmake: $(C_FILES)
	@mkdir -p cmake
	@chmod -R 777 cmake
	@echo 'set(sources ${sources}' > $@
	@for file in $^ ; do \
		echo "  $$file" >> $@; \
	done
	@echo ')' >> $@

clean:
	rm -rf build cmake test_obj

deploy: build/main.uf2
	@$(DCMDBASE) -ti $(DPRIV) $(DIMAGE) sh scripts/deploy.sh ../build/main.uf2

connect:
	@$(DCMDBASE) -ti $(DPRIV) $(DIMAGE) sh scripts/connect.sh

test: $(TEST_RESULTS)
	@for file in $^; do \
		retval=`tail -1 $$file`; \
		if [ $$retval -eq 1 ]; then \
			echo ["$(RFAIL)"] $$file; \
		else \
			echo ["$(RPASS)"] $$file; \
		fi; \
	done

$(TEST_OBJ_DIR)/%.test.result: $(TEST_OBJ_DIR)/%.test
	@#echo "TESTING $<"
	@sh -c '$< 2>&1 > $@; echo $$? >> $@'


$(TEST_OBJ_DIR)/%_c.test: $(TEST_OBJ_DIR)/%_c
	@# "make $@"
	@sh $<

$(TEST_OBJ_DIR)/%_c.d: tests/%.c
	@mkdir -p $(TEST_OBJ_DIR)
	@$(TEST_DEP_EXTRACTOR) > $@
	@echo $^ >> $@

$(TEST_OBJ_DIR)/%_cdep.o: src/%.c
	echo build $^

.PRECIOUS: $(TEST_OBJ_DIR)/*.test

.SECONDEXPANSION:
$(TEST_OBJ_DIR)/%_c: $(TEST_OBJ_DIR)/%_c.d $$(shell cat $$(TEST_OBJ_DIR)/%_c.d 2>/dev/null)
	@echo $(CC) $(CFLAGS) $(shell cat $<) -o $@.test > $@


.PHONY: all clean deploy connect
