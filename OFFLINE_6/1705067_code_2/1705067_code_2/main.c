/*
 * 1705067_code_2.c
 *
 * Created: 6/3/2021 3:13:26 PM
 * Author : Purbasha
 */ 

#define F_CPU 1000000 
#define D4 eS_PORTD4
#define D5 eS_PORTD5
#define D6 eS_PORTD6
#define D7 eS_PORTD7
#define RS eS_PORTC6
#define EN eS_PORTC7

#include <avr/io.h>
#include <stdlib.h>
#include <util/delay.h>
#include "lcd.h" 

int main(void)
{
	DDRD = 0xFF;
	DDRC = 0xFF;
	DDRA = 0x00;
	float value;
	float val_temp;
	float volt;
	char voltage[4];
	ADMUX = 0b00000010;
	ADCSRA = 0b10000101;
	Lcd4_Init();
	Lcd4_Set_Cursor(1,1);
	Lcd4_Write_String("Voltage: ");
	while(1)
	{
		ADCSRA |= (1 << ADSC);
		while( ADCSRA & (1 << ADSC)){;}
		//val_temp = ADCL;
		value = ADCL  | ( 0b00000011 & ADCH) << 8;
		//value += val_temp;
		volt = value*4.5/1024;
		dtostrf(volt,4,2,voltage);
		Lcd4_Set_Cursor(1,10);
		Lcd4_Write_String(voltage);
	}
}

