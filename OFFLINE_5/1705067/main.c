/*
 * 1705067_code.c
 *
 * Created: 4/10/2021 3:13:05 AM
 * Author : Purbasha
 */ 
#define F_CPU 1000000 
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

char array_row[]={ 0b00000001,0b00000010,0b00000100,0b00001000,0b00010000,0b00100000,0b01000000,0b10000000 };

char array_column[]={ 0b00111100,0b01100010,0b01100000,0b01100000,0b01100000,0b01100000,0b01100010,0b00111100 };

volatile unsigned int staticV = 1;
volatile unsigned int count;

ISR(INT2_vect)
{
	staticV = -staticV;
}


int main(void)
{
	DDRA = 0b11111111; //ROW
	DDRD = 0b11111111; //COLUMN
	DDRB = 0b00000000;
	int i = 0;
	int j = 0;
	GICR = (1<<INT2); 
	MCUCSR = MCUCSR & 0b10111111;
	sei();
	
    while (1) 
    {
		if(staticV== 1){
			PORTA = ~array_row[i];
			PORTD = array_column[i];
			_delay_ms(2);
			i++;
			if(i>7) i=0;
		}
		else if(staticV == -1){
			for (j = 0; j < 8; j++)
			{
				array_column[j] = array_column[j]<<1 | array_column[j]>>7;
			}
			for (count = 0; count < 150; count++)
			{
				PORTA = ~array_row[i];
				PORTD = array_column[i];
				_delay_ms(2);
				i++;
				if(i==8) i=0;	
			}
			i=0;	
		}
    }
}

