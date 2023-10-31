
//LASRI WAFAE -PIC16F887
//Ce programme permet de controler le niveau d'un bassin à l'aide d'une pompe (moteur) :
/*si le niveau <25% remplir le bassin avec un moteur qui tourne.
  si le niveau >=75%  arrêtter le moteur.*/
// Les connections sont :  *LCD sur PORTD *Potentiometre=PORTA.B0 *Afficheur 7seg=PORTC *Moteur=PORTB .
// connections du LCD
//on travail que sur 4 bus de données.
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

unsigned int ADCResult; //Résultat de la conversion A/N qui est sur 10 bit est mis dans un non signé de 16 bits.
float voltage,volt_prec=0;
float voltage_max=3.75; //Correspond à 75% de la batterie.
float voltage_min=1.25; //Correspond à 25% de la batterie.
float nbre_carreau_par_volt=0.3125; //Correspond au voltage d'un carreau de la batterie.
int perc; // Pourcentage de la batterie.
char BattTxT[16]; //pour l'affichage de la batterie,16 caractères par ligne [ allumer="0" étteinte="-" ].
unsigned int nbr_Batt; //Nombre de carreau de la batterie ////////////.
int i; //Varriable de boucle pour l'affichage de la batterie.

void main()
{    TRISA = 0xFF; //Configuration du PORTA en entrée.
     ANSEL = 0x01; //Configuration de PORTA.B0 en mode analogique les autres non utilisée on leurs attribuent zéro.
     ANSELH = 0x00; //non utilisée = zéro.
     TRISB=0; //Configuration du PORTB en sortie.
     PORTB=0; //Initialisation du PORTB à zéro.
     TRISC=0; //Configuration du PORTC comme sortie.
     PORTC=0; //Initialisation du PORTC à sortie.
     Lcd_Init(); // Initialization du  LCD.
     Lcd_Cmd(_LCD_CLEAR); // Clear display.
     Lcd_Cmd(_LCD_CURSOR_OFF); // Cursor off.
     Lcd_Out(1,1,"----------------"); //Batterie critique tout les 16 carreaux étteints.

     while(1)
     {
       ADCResult= ADC_read(0); // Convertion A/N,avec entrée PORTA.B0(première brôche du PORTA).
       voltage = 5 *((float)ADCResult/ 1023);//Calcul de la tension.

     // Fonctionnement du moteur :
     // Le moteur tourne si le niveau de l'eau est plus bas que le minimum 25% ou je suis entrain de remplire le bassain.
       if(voltage  < voltage_min || volt_prec <voltage)
         {PORTB.B0=1;} //Moteur ON.
     // Le moteur s'arrête si le niveau de l'eau est supérieure ou égale à 75% ou si le bassin se vide et n'a pas atteint 25%.
       if(voltage >= voltage_max || (volt_prec > voltage && voltage  >= voltage_min) )
         {PORTB.B0=0;} //Moteur OFF.
       perc=(int)((voltage/5)*100); // Calcul du pourcentage de la batterie.
       IntToStr(perc,BattTxT);  // Convertion Entier/String ,pour affichage des valeurs numériques sur LCD.
       nbr_Batt=(int)(voltage/nbre_carreau_par_volt); // Calcul du nombre de carreau à allumer selon la tension appliquer.

     // Fonctionnement de la batterie.
     // Batterie=niveau d'eau augmente à fure et à mesure que j'augmente la tension=remplis le bassain.
       if( volt_prec <voltage)
       { for(i=1;i<=nbr_Batt;i++)
            {lcd_out(1,i,"0");}
       }
     // Batterie=niveau d'eau dimimue à fure et à mesure que je diminue la tension=le bassain se vide.
       if( volt_prec > voltage)
       { for(i=nbr_Batt+1;i<=16;i++)
            {lcd_out(1,i,"-");}
       }
     // Affichage de la batterie et 7 segment :
     // Pour l'affichage des nombres de carreau allumer de la batterie dans l'afficheur 7segment (0 à F=16) connecté au PORTC.
       if (nbr_Batt>0)
       PORTC=nbr_Batt;
       if (nbr_Batt==0)
       PORTC=0;
       if (nbr_Batt==16)
       PORTC=0x0F;
     // Affichage du pourcentage de la batterie sur la 2ème ligne du LCD.
       Lcd_Out(2,4,BattTxT);
       Lcd_Out(2,10,"%");

       volt_prec=voltage; // On garde la valeur précèdente .
     }
}