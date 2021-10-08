#define LCD_LINE1 lcd_com(0x80)
#define LCD_LINE2 lcd_com(0xC0) //Макрокоманды для
#define LCD_CLR lcd_com(0x01)   //работы дисплея

#define CLK 25  //Макроопределение тактовой частоты
#define CLK_PSL 8  //Макроопределение делителя тактовой частоты таймера

//Макроопределения для работы с ножками контроллера
#define CUR2 PORTD.7    //Ножка связанная с источником тока 2
#define CUR1 PORTB.0    //Ножка связанная с источником тока 2
#define DISCH PORTB.1   //Связанная с разрядным ключом
#define TESTC PORTD.0   //Связанная с подключением тестового конденсатора

#define REF 1235        //Макроопределение опорного напряжения АЦП


#include <mega8.h>
#include <stdlib.h>
#include <iobits.h>
#include <delay.h>
#include <spi.h>        
//#include <lcd_spi.h>    //Функции для работы с дисплеем

// Declare your global variables here
unsigned long t=0, T1=0, T2=0;              //Переменные времени
eeprom float I1=10, I2= 100, prb_R = 0;     //Переменные калибровочных значений

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
    delay_us(200);
	data_h &= 0xF9;
	spi(data_h); // Передача старших 4 бит
    SETBIT(PORTB,2);
    //delay_us(1);
    CLRBIT(PORTB,2);
	delay_us(500);
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


//Измерение сопротивления щупов
float probe_R (void)        
{
      char i=0; 
      float prb_r = 0;
      int adc = 0;
      DISCH = 0;
      CUR2 = 1;
      LCD_CLR;
      LCD_LINE1;
      strf_out("Connect");
      LCD_LINE2;
      strf_out("probes");
      delay_ms(100);
      #asm("cli")
      ACSR.ACD = 1;
      ADCSRA.ADEN = 0;
      ADMUX.MUX0 = 1;
      ADMUX.MUX1 = 1;
      DDRC.3 = 0;
      PORTC.3 = 1;
      
      
      while(TSTBIT(PINC, 3));
      PORTC.3 = 0;
      delay_ms(1000);
      ADCSRA.ADEN = 1;
      for ( i = 0; i < 10;)
      {
          ADCSRA.ADSC = 1;
          while(!TSTBIT(ADCSRA, ADIF));
          SETBIT(ADCSRA, ADIF);
          
          if (ADCW > adc/2){
            adc = ADCW;
            prb_r += adc;
            i++;
          }
          
          
      }
      prb_r = (prb_r*REF/1024)/(I2*i);
      LCD_CLR;
      strf_out("Dis");
      LCD_LINE2;
      strf_out(" connect");
      ADCSRA.ADEN = 0;
      while(!TSTBIT(PINC, 3));
      ACSR.ACD = 0;
      CUR2 = 0;
      ADMUX &= ~((1<<MUX3) | (1<<MUX2) | (1<<MUX1) | (1<<MUX0));     
      
      return prb_r;
}


//Калибровка источников тока
void check( float C){          
 CUR1 = 0;
 CUR2 = 0; 
 LCD_CLR;
 LCD_LINE1; 
 strf_out("CHECK");      
 SETBIT(SFIOR, ACME);
 CLRBIT(TCCR1B,CS11);
 #asm("sei")
 TESTC = 1;
 DISCH = 1;
 delay_ms(1000);
 SETBIT(TCCR1B,CS11);  
 CUR2=1;
 DISCH=0;
 TCNT1=0;
 CLRBIT(TIMSK, TICIE1);
 ADMUX &= ~((1 << MUX3) | (1 << MUX2) | (1 << MUX1) | (1 << MUX0));
 SETBIT(TIFR,ICF1);
 SETBIT(TIMSK, TICIE1);        
 T1=0;
 T2=0;
 t=0;
 while(!T2);
 CUR2=0;
 I2 = (1265)/((float)T2/(CLK/CLK_PSL))*C;
 
 DISCH=1;
 delay_ms(1000);
 CUR1=1;
 DISCH=0;
 TCNT1=0;
 CLRBIT(TIMSK, TICIE1);
 ADMUX &= ~((1 << MUX3) | (1 << MUX2) | (1 << MUX1) | (1 << MUX0));
 SETBIT(TIFR,ICF1);
 SETBIT(TCCR1B,CS11);
 SETBIT(TIMSK, TICIE1);    
 T1=0;
 T2=0; 
 t=0;
 while(!T2);
 CUR1=0;
 I1 = (1265)/((float)T2/(CLK/CLK_PSL))*C;
 CLRBIT(TCCR1B,CS11);
 DISCH=0;
 LCD_CLR;
 LCD_LINE1; 
 lcd_printf(I1,1 );
 strf_out("mA");
 LCD_LINE2;
 lcd_printf(I2,1); 
 strf_out("mA");
 TESTC = 0;
 
 delay_ms(500);
 prb_R = probe_R();
 LCD_CLR;
 strf_out("Probe R=");
 LCD_LINE2; 
 lcd_printf(prb_R,3);
 delay_ms(500); 
                
 CLRBIT(TCCR1B,CS11); 
}


//Измерение ёмкости конденсатора
float testC(){              
float C = 0;
#asm("cli")
CUR1 = 0;
CUR2 = 0;
DISCH=1;
delay_ms(1000);
SETBIT(TCCR1B,CS11);
ADMUX &= ~((1<<MUX3) | (1<<MUX2) | (1<<MUX1) | (1<<MUX0));
SETBIT(TIFR,ICF1);
#asm("sei")
CUR1=1;

TCNT1 = 0;
T1 = 0;
t = 0;
T2 = 0;
DISCH = 0;
while (!T1);
if (T1/0xffff > (CLK/CLK_PSL)*1) {  // Переключение источников тока, если С > 1000uF
    #asm("cli")
    CUR1 = 0;
    DISCH = 1;
    delay_ms(1000);
    ADMUX &= ~((1<<MUX3) | (1<<MUX2) | (1<<MUX1) | (1<<MUX0));
    SETBIT(TIFR,ICF1);
    #asm("sei")
    CUR2 = 1;
    
    TCNT1 = 0;
    t = 0;
    T1 = 0;
    T2 = 0;
    DISCH = 0;
    while (!T1);
    while ((T2<T1/2) || (!T2)); 
    CUR2 = 0;
    C =  (I2*((float)T2/(CLK/CLK_PSL)))/(1265);
}
else {
    while ((T2<T1/2) || (!T2));
    CUR1 = 0;
    C =  (I1*((float)T2/(CLK/CLK_PSL)))/(1265);
}
return C;
}

//Измерение ESR
float esr(float C){             
    float R = 0;
    int adc = 0, i = 0;
    int total_Chrg = 0;
    
    #asm("cli")
    CUR1 = 0;
    CUR2 = 1;
    DISCH = 1;
    delay_ms(1000);  


    ACSR.ACD = 1;
    ADCSRA.ADEN = 1;
    ADMUX.MUX0 = 1;
    ADMUX.MUX1 = 1;
    ADCSRA.ADSC = 1;
      for ( i = 0; i < 10;)
      {
          ADCSRA.ADSC = 1;
          while(!TSTBIT(ADCSRA, ADIF));
          SETBIT(ADCSRA, ADIF);
          
          if (ADCW > adc/2){
            adc = ADCW;
            total_Chrg += adc;
            i++;
          }
          
          
      }
    ADCSRA.ADEN = 0;
    ACSR.ACD = 0;
    
    
    
    SETBIT(TCCR1B,CS11);
    t=0;
    T1 = 0; 
    ADMUX &= ~((1<<MUX3) | (1<<MUX2) | (1<<MUX1) | (1<<MUX0));
    ADMUX |= (0 << MUX1) | (0 << MUX0);
    SETBIT(TIFR,ICF1);
    TCNT1 = 0;
    SETBIT(ACSR,ACI);
    #asm("sei")
    
    DISCH = 0;
    TCNT1 = 0;    
    while(!T1 );
    R = (1235)/I2 - (T1/C)/(CLK/CLK_PSL) - prb_R - ((float)total_Chrg*REF/1024)/(I2*i);         
    CUR1 = 0;
    CUR2 = 0;
    DISCH = 1;
    return R;
}




//Обработка кнопки запуска калибровки
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    delay_ms(100);
    SETBIT(TIFR,ICF1);
    #asm("sei")
    check(6.89); 
}



//Прерывание по переполнению таймера
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
        t++;
        if((t > (CLK/CLK_PSL)*30)){
            LCD_CLR;
            strf_out("ERROR");
            CLRBIT(TCCR1B,CS11);  
        }

}

//Прерывание через блок захвата по сработке компаратора
interrupt [TIM1_CAPT] void timer1_capt_isr(void)
{
        
        if (TSTBIT(ADMUX, MUX1)) {
            TCNT1 = 0;
            ADMUX &= ~((1<<MUX3) | (1<<MUX2) | (1<<MUX1) | (1<<MUX0));
            }
        else if (!TSTBIT(ADMUX, MUX0)){
            TCNT1 = 0;
            ADMUX |= (1<<MUX0);
            T1 = t*0xFFFF + ICR1;  
            //T2=0;
            t=0;
            
            
        } 
        else{
            T2 = t*0xFFFF + ICR1;
            CLRBIT(TCCR1B,CS11);
        }       
         SETBIT(TIFR,ICF1);
         SETBIT(ACSR,ACI);
}



void main(void)
{
// Declare your local variables here
float C = 0, R=0;


//Инициализация необходимых блоков при запуске
// Настройка портов ввода-вывода
// Port B
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D
DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (1<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);


// Ииициализация таймера-счтечика 1
// Источник тактов: тактирование МК
// Тактовая частота: CLK/CLK_PSL = 2 kHz
// Фильтр помех: On
// Источник сигнала захвата: выход компаратора
// Захват таймера: по нарастающему фронту
// Прерывание по переполнению: On
// Прерывание по захвату: On
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(1<<ICNC1) | (1<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;


// Настройка прерывания таймера 1
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (1<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);

// Внешние прерывания
// По ножке INT0: On
// Режим по INT0: любое изменение
// INT1: Off
GICR|=(0<<INT1) | (1<<INT0);
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (1<<ISC00);
GIFR=(0<<INTF1) | (1<<INTF0);

/*// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;*/

// Аналоговый копаратор
// Неинвертирующий вход: AIN0
// Инвертирующий вход: мультиплексор АЦП
ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (1<<ACI) | (0<<ACIE) | (1<<ACIC) | (1<<ACIS1) | (1<<ACIS0);
SFIOR=(1<<ACME);

// AЦП
// Источник опорного напряжения: внешнее
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
ADMUX = (0<< REFS1) | (0<<REFS0)| (0<<ADLAR);

// SPI
// Режим: Master
if (CLK <= 16) SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (1<<SPR0);
else   SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (1<<SPR1) | (1<<SPR0);
SPSR=(0<<SPI2X);


//Начало работы алгоритма измерений
DISCH=1;
SETBIT(TIFR,ICF1);
#asm("cli")
LCDinit();
delay_ms(100);
lcd_printf(I1, 1);
strf_out("mA");
LCD_LINE2;
lcd_printf(I2,1);
strf_out("mA");
delay_ms(500);

LCD_CLR;
strf_out("TESTING");

C = testC();
R = esr(C);
CLRBIT(TCCR1B,CS11);

      
// Вывод результатов
while (1)
      { 
        LCD_CLR;
        if ( C > 1000){
            lcd_printf( C, 0);
        }
        else{
            lcd_printf(C, 2);
        }
        LCD_LINE2;
        strf_out("    uf");
        delay_ms(1000);
        LCD_CLR;
        lcd_printf(R, 2);
        LCD_LINE2;
        strf_out("    ohm");
        delay_ms(1000);
      }
}