
_main:

;Pampe_eau.c,32 :: 		void main()
;Pampe_eau.c,33 :: 		{    TRISA = 0xFF; //Configuration du PORTA en entrée.
	MOVLW      255
	MOVWF      TRISA+0
;Pampe_eau.c,34 :: 		ANSEL = 0x01; //Configuration de PORTA.B0 en mode analogique les autres non utilisée on leurs attribuent zéro.
	MOVLW      1
	MOVWF      ANSEL+0
;Pampe_eau.c,35 :: 		ANSELH = 0x00; //non utilisée = zéro.
	CLRF       ANSELH+0
;Pampe_eau.c,36 :: 		TRISB=0; //Configuration du PORTB en sortie.
	CLRF       TRISB+0
;Pampe_eau.c,37 :: 		PORTB=0; //Initialisation du PORTB à zéro.
	CLRF       PORTB+0
;Pampe_eau.c,38 :: 		TRISC=0; //Configuration du PORTC comme sortie.
	CLRF       TRISC+0
;Pampe_eau.c,39 :: 		PORTC=0; //Initialisation du PORTC à sortie.
	CLRF       PORTC+0
;Pampe_eau.c,40 :: 		Lcd_Init(); // Initialization du  LCD.
	CALL       _Lcd_Init+0
;Pampe_eau.c,41 :: 		Lcd_Cmd(_LCD_CLEAR); // Clear display.
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Pampe_eau.c,42 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // Cursor off.
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Pampe_eau.c,43 :: 		Lcd_Out(1,1,"----------------"); //Batterie critique tout les 16 carreaux étteints.
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Pampe_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pampe_eau.c,45 :: 		while(1)
L_main0:
;Pampe_eau.c,47 :: 		ADCResult= ADC_read(0); // Convertion A/N,avec entrée PORTA.B0(première brôche du PORTA).
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _ADCResult+0
	MOVF       R0+1, 0
	MOVWF      _ADCResult+1
;Pampe_eau.c,48 :: 		voltage = 5 *((float)ADCResult/ 1023);//Calcul de la tension.
	CALL       _word2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _voltage+0
	MOVF       R0+1, 0
	MOVWF      _voltage+1
	MOVF       R0+2, 0
	MOVWF      _voltage+2
	MOVF       R0+3, 0
	MOVWF      _voltage+3
;Pampe_eau.c,52 :: 		if(voltage  < voltage_min || volt_prec <voltage)
	MOVF       _voltage_min+0, 0
	MOVWF      R4+0
	MOVF       _voltage_min+1, 0
	MOVWF      R4+1
	MOVF       _voltage_min+2, 0
	MOVWF      R4+2
	MOVF       _voltage_min+3, 0
	MOVWF      R4+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main23
	MOVF       _voltage+0, 0
	MOVWF      R4+0
	MOVF       _voltage+1, 0
	MOVWF      R4+1
	MOVF       _voltage+2, 0
	MOVWF      R4+2
	MOVF       _voltage+3, 0
	MOVWF      R4+3
	MOVF       _volt_prec+0, 0
	MOVWF      R0+0
	MOVF       _volt_prec+1, 0
	MOVWF      R0+1
	MOVF       _volt_prec+2, 0
	MOVWF      R0+2
	MOVF       _volt_prec+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main23
	GOTO       L_main4
L__main23:
;Pampe_eau.c,53 :: 		{PORTB.B0=1;} //Moteur ON.
	BSF        PORTB+0, 0
L_main4:
;Pampe_eau.c,55 :: 		if(voltage >= voltage_max || (volt_prec > voltage && voltage  >= voltage_min) )
	MOVF       _voltage_max+0, 0
	MOVWF      R4+0
	MOVF       _voltage_max+1, 0
	MOVWF      R4+1
	MOVF       _voltage_max+2, 0
	MOVWF      R4+2
	MOVF       _voltage_max+3, 0
	MOVWF      R4+3
	MOVF       _voltage+0, 0
	MOVWF      R0+0
	MOVF       _voltage+1, 0
	MOVWF      R0+1
	MOVF       _voltage+2, 0
	MOVWF      R0+2
	MOVF       _voltage+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main21
	MOVF       _volt_prec+0, 0
	MOVWF      R4+0
	MOVF       _volt_prec+1, 0
	MOVWF      R4+1
	MOVF       _volt_prec+2, 0
	MOVWF      R4+2
	MOVF       _volt_prec+3, 0
	MOVWF      R4+3
	MOVF       _voltage+0, 0
	MOVWF      R0+0
	MOVF       _voltage+1, 0
	MOVWF      R0+1
	MOVF       _voltage+2, 0
	MOVWF      R0+2
	MOVF       _voltage+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main22
	MOVF       _voltage_min+0, 0
	MOVWF      R4+0
	MOVF       _voltage_min+1, 0
	MOVWF      R4+1
	MOVF       _voltage_min+2, 0
	MOVWF      R4+2
	MOVF       _voltage_min+3, 0
	MOVWF      R4+3
	MOVF       _voltage+0, 0
	MOVWF      R0+0
	MOVF       _voltage+1, 0
	MOVWF      R0+1
	MOVF       _voltage+2, 0
	MOVWF      R0+2
	MOVF       _voltage+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main22
	GOTO       L__main21
L__main22:
	GOTO       L_main9
L__main21:
;Pampe_eau.c,56 :: 		{PORTB.B0=0;} //Moteur OFF.
	BCF        PORTB+0, 0
L_main9:
;Pampe_eau.c,57 :: 		perc=(int)((voltage/5)*100); // Calcul du pourcentage de la batterie.
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	MOVF       _voltage+0, 0
	MOVWF      R0+0
	MOVF       _voltage+1, 0
	MOVWF      R0+1
	MOVF       _voltage+2, 0
	MOVWF      R0+2
	MOVF       _voltage+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      _perc+0
	MOVF       R0+1, 0
	MOVWF      _perc+1
;Pampe_eau.c,58 :: 		IntToStr(perc,BattTxT);  // Convertion Entier/String ,pour affichage des valeurs numériques sur LCD.
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _BattTxT+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Pampe_eau.c,59 :: 		nbr_Batt=(int)(voltage/nbre_carreau_par_volt); // Calcul du nombre de carreau à allumer selon la tension appliquer.
	MOVF       _nbre_carreau_par_volt+0, 0
	MOVWF      R4+0
	MOVF       _nbre_carreau_par_volt+1, 0
	MOVWF      R4+1
	MOVF       _nbre_carreau_par_volt+2, 0
	MOVWF      R4+2
	MOVF       _nbre_carreau_par_volt+3, 0
	MOVWF      R4+3
	MOVF       _voltage+0, 0
	MOVWF      R0+0
	MOVF       _voltage+1, 0
	MOVWF      R0+1
	MOVF       _voltage+2, 0
	MOVWF      R0+2
	MOVF       _voltage+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      _nbr_Batt+0
	MOVF       R0+1, 0
	MOVWF      _nbr_Batt+1
;Pampe_eau.c,63 :: 		if( volt_prec <voltage)
	MOVF       _voltage+0, 0
	MOVWF      R4+0
	MOVF       _voltage+1, 0
	MOVWF      R4+1
	MOVF       _voltage+2, 0
	MOVWF      R4+2
	MOVF       _voltage+3, 0
	MOVWF      R4+3
	MOVF       _volt_prec+0, 0
	MOVWF      R0+0
	MOVF       _volt_prec+1, 0
	MOVWF      R0+1
	MOVF       _volt_prec+2, 0
	MOVWF      R0+2
	MOVF       _volt_prec+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main10
;Pampe_eau.c,64 :: 		{ for(i=1;i<=nbr_Batt;i++)
	MOVLW      1
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
L_main11:
	MOVF       _i+1, 0
	SUBWF      _nbr_Batt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main25
	MOVF       _i+0, 0
	SUBWF      _nbr_Batt+0, 0
L__main25:
	BTFSS      STATUS+0, 0
	GOTO       L_main12
;Pampe_eau.c,65 :: 		{lcd_out(1,i,"0");}
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVF       _i+0, 0
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Pampe_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pampe_eau.c,64 :: 		{ for(i=1;i<=nbr_Batt;i++)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;Pampe_eau.c,65 :: 		{lcd_out(1,i,"0");}
	GOTO       L_main11
L_main12:
;Pampe_eau.c,66 :: 		}
L_main10:
;Pampe_eau.c,68 :: 		if( volt_prec > voltage)
	MOVF       _volt_prec+0, 0
	MOVWF      R4+0
	MOVF       _volt_prec+1, 0
	MOVWF      R4+1
	MOVF       _volt_prec+2, 0
	MOVWF      R4+2
	MOVF       _volt_prec+3, 0
	MOVWF      R4+3
	MOVF       _voltage+0, 0
	MOVWF      R0+0
	MOVF       _voltage+1, 0
	MOVWF      R0+1
	MOVF       _voltage+2, 0
	MOVWF      R0+2
	MOVF       _voltage+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main14
;Pampe_eau.c,69 :: 		{ for(i=nbr_Batt+1;i<=16;i++)
	MOVF       _nbr_Batt+0, 0
	ADDLW      1
	MOVWF      _i+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _nbr_Batt+1, 0
	MOVWF      _i+1
L_main15:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _i+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main26
	MOVF       _i+0, 0
	SUBLW      16
L__main26:
	BTFSS      STATUS+0, 0
	GOTO       L_main16
;Pampe_eau.c,70 :: 		{lcd_out(1,i,"-");}
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVF       _i+0, 0
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Pampe_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pampe_eau.c,69 :: 		{ for(i=nbr_Batt+1;i<=16;i++)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;Pampe_eau.c,70 :: 		{lcd_out(1,i,"-");}
	GOTO       L_main15
L_main16:
;Pampe_eau.c,71 :: 		}
L_main14:
;Pampe_eau.c,74 :: 		if (nbr_Batt>0)
	MOVF       _nbr_Batt+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main27
	MOVF       _nbr_Batt+0, 0
	SUBLW      0
L__main27:
	BTFSC      STATUS+0, 0
	GOTO       L_main18
;Pampe_eau.c,75 :: 		PORTC=nbr_Batt;
	MOVF       _nbr_Batt+0, 0
	MOVWF      PORTC+0
L_main18:
;Pampe_eau.c,76 :: 		if (nbr_Batt==0)
	MOVLW      0
	XORWF      _nbr_Batt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main28
	MOVLW      0
	XORWF      _nbr_Batt+0, 0
L__main28:
	BTFSS      STATUS+0, 2
	GOTO       L_main19
;Pampe_eau.c,77 :: 		PORTC=0;
	CLRF       PORTC+0
L_main19:
;Pampe_eau.c,78 :: 		if (nbr_Batt==16)
	MOVLW      0
	XORWF      _nbr_Batt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main29
	MOVLW      16
	XORWF      _nbr_Batt+0, 0
L__main29:
	BTFSS      STATUS+0, 2
	GOTO       L_main20
;Pampe_eau.c,79 :: 		PORTC=0x0F;
	MOVLW      15
	MOVWF      PORTC+0
L_main20:
;Pampe_eau.c,81 :: 		Lcd_Out(2,4,BattTxT);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _BattTxT+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pampe_eau.c,82 :: 		Lcd_Out(2,10,"%");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Pampe_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pampe_eau.c,84 :: 		volt_prec=voltage; // On garde la valeur précèdente .
	MOVF       _voltage+0, 0
	MOVWF      _volt_prec+0
	MOVF       _voltage+1, 0
	MOVWF      _volt_prec+1
	MOVF       _voltage+2, 0
	MOVWF      _volt_prec+2
	MOVF       _voltage+3, 0
	MOVWF      _volt_prec+3
;Pampe_eau.c,85 :: 		}
	GOTO       L_main0
;Pampe_eau.c,86 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
