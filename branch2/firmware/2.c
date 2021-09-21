/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 09.06.2021
Author  : 
Company : 
Comments: 


Chip type               : ATmega168
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#define CUR2 PORTD.7
#define CUR1 PORTB.0
#define DISCH PORTB.1
#define LCD_LINE1 lcd_com(0x80)
#define LCD_LINE2 lcd_com(0xC0)
#define LCD_CLR lcd_com(0x01)
#define U1 1250
#define U2 1300

#include <mega168.h>


// Standard Input/Output functions
//#include <stdio.h>
#include <stdlib.h>
//#include <string.h>
#include <iobits.h>
#include <delay.h>
#include <spi.h>

// Declare your global variables here
unsigned int t=0, T1=0, T2=0;
eeprom float I1=10.5, I2= 113.3;

void LCDcom(unsigned char com) //выполняет пол команды отправляет старший полубайт
{
    com |= 0x08;                // Р3 в единицу, дабы горела подсветка
    spi(com);    // Вывод данных
    SETBIT(PORTB,2);
    //delay_us(1);
    CLRBIT(PORTB,2);
    //delay_us(200);
    com |= 0x04;                // Е в единицу
    spi(com);    // Вывод данных
    SETBIT(PORTB,2);
    //delay_us(1);
    CLRBIT(PORTB,2);
    //delay_us(200);
    com &= 0xFB;                // Е в ноль
    spi(com);    // Вывод данных
    SETBIT(PORTB,2);
    //delay_us(1);
    CLRBIT(PORTB,2);
    delay_ms(2);
}

void lcd_com(unsigned char com)
    {
      LCDcom(com & 0xF0);
      LCDcom((com <<4)&0xF0);  
    }

void LCDinit()
{    
    delay_ms(40);        // Пауза после подачи питания
    LCDcom(0x30);        // Переход в 4-х битный режим
    delay_us(40);        // Задержка для выполнения команды
    LCDcom(0x30);        // Переход в 4-х битный режим
    delay_us(40);        // Задержка для выполнения команды
    LCDcom(0x30);        // Переход в 4-х битный режим
    delay_us(40);        // Задержка для выполнения команды
    LCDcom(0x20);        // Переход в 4-х битный режим
    delay_us(40);        // Задержка для выполнения команды
    LCDcom(0x20);        // Установка параметров
    LCDcom(0x80);        // Установка параметров
    LCDcom(0x00);        // Выключаем дисплей
    LCDcom(0x80);        // Выключаем дисплей
    LCDcom(0x00);        // Очищаем дисплей
    LCDcom(0x10);        // Очищаем дисплей
    LCDcom(0x00);        // Устанавливаем режим ввода данных
    LCDcom(0x60);        // Устанавливаем режим ввода данных
    LCDcom(0x00);        // Включаем дисплей с выбранным курсором
    LCDcom(0xC0);        // Включаем дисплей с выбранным курсором
}

void char_out(unsigned char data)
{      
    unsigned char data_h = ((data & 0xF0) + 0x09);
    unsigned char data_l = ((data << 4) + 0x09);
                               
    spi(data_h); // Передача старших 4 бит
    SETBIT(PORTB,2);
    //delay_us(1);
    CLRBIT(PORTB,2);
    //delay_us(200);
    data_h |= 0x04;
    spi(data_h); // Передача старших 4 бит
    SETBIT(PORTB,2);
    //delay_us(1);
    CLRBIT(PORTB,2);
    //delay_us(200);
    data_h &= 0xF9;
    spi(data_h); // Передача старших 4 бит
    SETBIT(PORTB,2);
    //delay_us(1);
    CLRBIT(PORTB,2);
    //delay_us(500);
    spi(data_l); // Передача младших 4 бит
    SETBIT(PORTB,2);
    //delay_us(1);
    CLRBIT(PORTB,2);
    //delay_us(200);
    data_l |= 0x04;
    spi(data_l); // Передача младших 4 бит
    SETBIT(PORTB,2);
    //delay_us(1);
    CLRBIT(PORTB,2);
    //delay_us(200);
    data_l &= 0xF9;
    spi(data_l); // Передача младших 4 бит
    SETBIT(PORTB,2);
    //delay_us(1);
    CLRBIT(PORTB,2);
    delay_ms(2);
}

void str_out(char *str)
    {
        while (*str!='\0')
            {
              char_out(*str++);  
            }
    }
      
void strf_out(flash char *str)
    {
        while (*str!='\0')
            {
              char_out(*str++);  
            }
    }    

void lcd_printf(float f, unsigned char n){
    char *str = "";
    ftoa(f, n, str);
    str_out(str);
}

void check( float C){    
 LCD_CLR;
 LCD_LINE1;
 strf_out("CHECK");
    

 
 DISCH=1;
 delay_ms(1000);
 CUR2=1;
 DISCH=0;
 TCNT0=0;
 CLRBIT(ADMUX,MUX0);
 SETBIT(ACSR,ACI);        
 T1=T2=0;
 t=0;
 while(!T2);
 CUR2=0;
 I2 = (U2/(float)T2)*C;
 
 DISCH=1;
 delay_ms(1000);
 CUR1=1;
 DISCH=0;
 TCNT0=0;
 CLRBIT(ADMUX,MUX0); 
 SETBIT(ACSR,ACI);    
 T1=T2=0; 
 t=0;
 while(!T2);
 CUR1=0;
 I1 = (U2/(float)T2)*C;
 
 DISCH=1;
 LCD_CLR;
 LCD_LINE1; 
 lcd_printf(I1,1 );
 strf_out("mA");
 LCD_LINE2;
 lcd_printf(I2,1); 
 strf_out("mA"); 
        

}

float testC2(){
    float C=0;
    DISCH=1;
    delay_ms(1000);
    CUR2=1;
    DISCH=0;
    CLRBIT(ADMUX,MUX0);
     SETBIT(ACSR,ACI);      
     TCNT0=0;
     T1=T2=0; 
     t=0;
     while(!T2);
     CUR2=0;
     if (T1/T2 >5){
        C = testC2();     
     }
     else{
        C=I1*T2/U2;
     }
     LCD_CLR;
     lcd_printf(C,0);
     strf_out("uF"); 
     return C;
}


float testC1(){
    float C=0;
    DISCH=1;
    delay_ms(1000);
    CUR1=1;
    
    DISCH=0;
    CLRBIT(ADMUX,MUX0);
    SETBIT(ACSR,ACI);      
     TCNT0=0;
     T1=T2=0; 
     t=0;
     while(!T2){
        if (t>100){ //200uF
            CUR1=0;
            return testC2();
              
        }
     }
     CUR1=0;
     if (T1/T2 >5){
        C = testC1();     
     }
     else{
        C=I1*T2/U2;
     }
     
     LCD_CLR;
     lcd_printf(C,2);
     strf_out("uF"); 
     return C;


}


void testR(float C){
    float R=0;
    LCD_LINE2;
    DISCH=1;
    delay_ms(1000);
    CUR2=1;
    DISCH=0; 
    CLRBIT(ADMUX,MUX0);
    SETBIT(ACSR,ACI);    
    TCNT0=0;
    T1=T2=0; 
    t=0;
    while(!T2){}
    CUR2=0;
    LCD_LINE2;
    R=U1/I2 - (float)T1/C;
    lcd_printf(R,3);
    strf_out("Om");
     
}

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    delay_ms(100);
    SETBIT(ACSR,ACI);
   #asm("sei")
   check(6.89);
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
        t++;

}

// Analog Comparator interrupt service routine
interrupt [ANA_COMP] void ana_comp_isr(void)
{
        if (TSTBIT(ADMUX,MUX0)==0){   
            SETBIT(ADMUX,MUX0);
            T1 = t*256 + TCNT0;
            T2=0;
            
            
        } 
        else{  
            if(TSTBIT(ADMUX,MUX0)==1){
                //if (T1/(t*256+TCNT0)>2){
                  //  SETBIT(ADMUX,MUX0);
                    //}
                //else{
                    T2 = t*256 + TCNT0;
                //}
            }
        }       
         TCNT0=0;
         t=0;
         SETBIT(ACSR,ACI);
}



void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
// Timer Period: 0,256 ms
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Any change
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (1<<ISC00);
EIMSK=(0<<INT1) | (1<<INT0);
EIFR=(0<<INTF1) | (1<<INTF0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

// USART initialization
// USART disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// Analog Comparator initialization
// Analog Comparator: On
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the ADC multiplexer
// Interrupt on Rising Output Edge
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (1<<ACI) | (1<<ACIE) | (0<<ACIC) | (1<<ACIS1) | (1<<ACIS0);
ADCSRB=(1<<ACME);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 500,000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (1<<SPR0);
SPSR=(0<<SPI2X);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

DISCH=1;
SETBIT(ACSR,ACI);
#asm("sei")
LCDinit();
delay_ms(100);
lcd_printf(I1, 1);
strf_out("mA");
LCD_LINE2;
lcd_printf(I2,1);
strf_out("mA");
delay_ms(100);
testR(testC1());

while (1)
      {
      // Place your code here

      }
}
