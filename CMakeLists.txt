cmake_minimum_required(VERSION 3.18)

include($ENV{PICO_SDK_PATH}/pico_sdk_init.cmake)
project(picoci C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()

include(cmake/sourcelist.cmake)
add_executable(main ${sources})

target_link_libraries(main pico_stdlib hardware_pwm)

pico_enable_stdio_usb(main 1)
pico_enable_stdio_uart(main 0)

pico_add_extra_outputs(main)
