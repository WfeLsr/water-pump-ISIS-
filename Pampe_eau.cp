#line 1 "C:/Users/moimoi/Desktop/Projet_Lasri_Wafae/Pampe_eau.c"
#line 9 "C:/Users/moimoi/Desktop/Projet_Lasri_Wafae/Pampe_eau.c"
sbit LCD_RS at RD0_bit;
sbit LCD_EN at RD1_bit;
sbit LCD_D4 at RD2_bit;
sbit LCD_D5 at RD3_bit;
sbit LCD_D6 at RD4_bit;
sbit LCD_D7 at RD5_bit;
sbit LCD_RS_Direction at TRISD0_bit;
sbit LCD_EN_Direction at TRISD1_bit;
sbit LCD_D4_Direction at TRISD2_bit;
sbit LCD_D5_Direction at TRISD3_bit;
sbit LCD_D6_Direction at TRISD4_bit;
sbit LCD_D7_Direction at TRISD5_bit;

unsigned int ADCResult;
float voltage,volt_prec=0;
float voltage_max=3.75;
float voltage_min=1.25;
float nbre_carreau_par_volt=0.3125;
int perc;
char BattTxT[16];
unsigned int nbr_Batt;
int i;

void main()
{ TRISA = 0xFF;
 ANSEL = 0x01;
 ANSELH = 0x00;
 TRISB=0;
 PORTB=0;
 TRISC=0;
 PORTC=0;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"----------------");

 while(1)
 {
 ADCResult= ADC_read(0);
 voltage = 5 *((float)ADCResult/ 1023);



 if(voltage < voltage_min || volt_prec <voltage)
 {PORTB.B0=1;}

 if(voltage >= voltage_max || (volt_prec > voltage && voltage >= voltage_min) )
 {PORTB.B0=0;}
 perc=(int)((voltage/5)*100);
 IntToStr(perc,BattTxT);
 nbr_Batt=(int)(voltage/nbre_carreau_par_volt);



 if( volt_prec <voltage)
 { for(i=1;i<=nbr_Batt;i++)
 {lcd_out(1,i,"0");}
 }

 if( volt_prec > voltage)
 { for(i=nbr_Batt+1;i<=16;i++)
 {lcd_out(1,i,"-");}
 }


 if (nbr_Batt>0)
 PORTC=nbr_Batt;
 if (nbr_Batt==0)
 PORTC=0;
 if (nbr_Batt==16)
 PORTC=0x0F;

 Lcd_Out(2,4,BattTxT);
 Lcd_Out(2,10,"%");

 volt_prec=voltage;
 }
}
