#include <stdio.h>
#include <pico/stdlib.h>

#include <hardware/pwm.h>

#define ENABLE_PIN 15
#define ENABLE 0
#define DISABLE 1

#define OUTPUT_PIN 17

int main()
{
	stdio_init_all();

	gpio_init(ENABLE_PIN);
	gpio_init(PICO_DEFAULT_LED_PIN);

	gpio_set_dir(ENABLE_PIN, GPIO_OUT);
	gpio_set_dir(PICO_DEFAULT_LED_PIN, GPIO_OUT);

	gpio_set_function(OUTPUT_PIN, GPIO_FUNC_PWM);

	gpio_put(PICO_DEFAULT_LED_PIN, 1);

	uint slicenum = pwm_gpio_to_slice_num(OUTPUT_PIN);
	uint channel = pwm_gpio_to_channel(OUTPUT_PIN);

	pwm_set_wrap(slicenum, 7);
	pwm_set_chan_level(slicenum, channel, 0);
	pwm_set_enabled(slicenum, true);

	int user_input = 0;

	int enable_pin_state = ENABLE;
	int chan_level = 1;
	gpio_put(ENABLE_PIN, enable_pin_state);
	pwm_set_chan_level(slicenum, channel, chan_level);

	// spinloop and wait for the user to press
	// the keys 1 or 0. though it responds
	// to just about any key. try it!
	while (true)
	{
		user_input = getchar();
		if (user_input == 'a')
		{
			if(enable_pin_state == DISABLE)
			{
				printf("enable\n");
				enable_pin_state = ENABLE;
			}
			else
			{
				printf("disable\n");
				enable_pin_state = DISABLE;
			}
			gpio_put(ENABLE_PIN, enable_pin_state);
		}
		if (user_input >= '0' && user_input < '9')
		{
			chan_level = user_input - '0';
			printf("chanlevel==%d\n", chan_level);
			pwm_set_chan_level(slicenum, channel, chan_level);
		}
		sleep_ms(100);
	}
	return 0;
}
