#include "stm32f103xb.h"

void sleep_iter(uint32_t t);
void pwm_up();
void pwm_down();
void morze_dot();
void morze_dash();
void morze_pause();
void morze_longpause();

void sleep_iter(uint32_t t)
{
	for (int i = 0; i < t; i++);
}

void pwm_up()
{
	uint32_t fill_on = 0, fill_off=4000;
	int32_t fill_dir = 50;
	while ( fill_on != 4000)
	{
		GPIOC->ODR |= GPIO_ODR_ODR13;
		sleep_iter(fill_on);
	
		GPIOC->ODR &= ~GPIO_ODR_ODR13;
		sleep_iter(fill_off);

		fill_on = fill_on + fill_dir;
		fill_off = fill_off - fill_dir;
	}
	GPIOC->ODR |= GPIO_ODR_ODR13;
}


void pwm_down()
{
	uint32_t fill_on = 4000, fill_off=0;
	int32_t fill_dir = -50;
	while ( fill_off != 4000)
	{
		GPIOC->ODR |= GPIO_ODR_ODR13;
		sleep_iter(fill_on);
	
		GPIOC->ODR &= ~GPIO_ODR_ODR13;
		sleep_iter(fill_off);

		fill_on = fill_on + fill_dir;
		fill_off = fill_off - fill_dir;
	}
	GPIOC->ODR &= ~GPIO_ODR_ODR13;
}

void morze_dot()
{
	pwm_down();
	pwm_up();
}


void morze_dash()
{
	pwm_down();
	morze_pause();
	pwm_up();
}

void morze_pause()
{
	for (int i = 0; i < 160; i ++)
	sleep_iter(4000);
}

void morze_longpause()
{
	morze_pause();
	morze_pause();
}

int main( void )
{
	RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;

	GPIOC->CRH &= ~GPIO_CRH_CNF13_Msk;    // Clear both CNF13[1:0] bits
	GPIOC->CRH |= ( GPIO_CRH_MODE13_0 );  // Set MODE13[0]-bit.

	while( 1 )                            // Endless loop
	{

		morze_dot();
		morze_dot();
		morze_dot();
		morze_pause();

		morze_dash();
		morze_dash();
		morze_dash();
		morze_pause();
		
		morze_dot();
		morze_dot();
		morze_dot();
		morze_pause();

		morze_longpause();
	}
}
