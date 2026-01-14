 ;ISR1 SEGMENT---------------------------------------------------------------------------------------------------------------------------------------------
PROCED1 SEGMENT
 ISR1 PROC FAR
 ASSUME CS:PROCED1, DS:DATA
 ORG 01000H
    PUSHF
    PUSH AX
    PUSH DX
    
     ;INSTRUCTIONS===============
      MOV [REFILL_CLICKED], 1
    ;=============================
   
    POP DX
    POP AX
    POPF
    IRET
 ISR1 ENDP
 PROCED1 ENDS
 
  ;ISR2 SEGMENT---------------------------------------------------------------------------------------------------------------------------------------------
 PROCED2 SEGMENT
 ISR2 PROC FAR
 ASSUME CS:PROCED2, DS:DATA
 ORG 02000H
    PUSHF
    PUSH AX
    PUSH DX
   
     ; INSTRUCTIONS===============
	 MOV [USER1_CLICKED] , 1
     ;=============================
     
    POP DX
    POP AX
    POPF
    IRET
 ISR2 ENDP
 PROCED2 ENDS
 
  ;ISR3 SEGMENT---------------------------------------------------------------------------------------------------------------------------------------------
 PROCED3 SEGMENT
 ISR3 PROC FAR
 ASSUME CS:PROCED3, DS:DATA
 ORG 03000H
    PUSHF
    PUSH AX
    PUSH DX
   
    ; INSTRUCTIONS===============
         MOV [USER2_CLICKED] , 1
    ;=============================

    POP DX
    POP AX
    POPF
    IRET
 ISR3 ENDP
 PROCED3 ENDS
 
;ISR4 SEGMENT---------------------------------------------------------------------------------------------------------------------------------------------
 PROCED4 SEGMENT
 ISR4 PROC FAR
 ASSUME CS:PROCED4, DS:DATA
 ORG 04000H
    PUSHF
    PUSH AX
    PUSH DX
   
    ; INSTRUCTIONS===============
           MOV [USER3_CLICKED] , 1
      ;============================

    POP DX
    POP AX
    POPF
    IRET
 ISR4 ENDP
 PROCED4 ENDS
 
   ;ISR5 SEGMENT---------------------------------------------------------------------------------------------------------------------------------------------
 PROCED5 SEGMENT
 ISR5 PROC FAR
 ASSUME CS:PROCED5, DS:DATA
 ORG 05000H
    PUSHF
    PUSH AX
    PUSH DX
   
    ; INSTRUCTIONS===============
	UPDATE_USER1:    
	     CMP WORD PTR [USER1_TEMPTIME_TABLET], 0
	     JE CHECK_SECOND_1
	     DEC WORD PTR [USER1_TEMPTIME_TABLET]
	     CMP WORD PTR [USER1_TEMPTIME_TABLET], 1
	     JNE CHECK_SECOND_1
	     MOV [SETALARM_USER1 + 0], 1
	     MOV [ALARMID], 01H
	     CALL ENQUEUE_ALARM
	     
	 CHECK_SECOND_1:
	    CMP WORD PTR [USER1_TEMPTIME_CAPSULE], 0
	     JE CHECK_THIRD_1
	     DEC WORD PTR [USER1_TEMPTIME_CAPSULE]
	     CMP WORD PTR [USER1_TEMPTIME_CAPSULE], 1
	     JNE CHECK_THIRD_1
	     MOV [SETALARM_USER1 + 1], 1
	     MOV [ALARMID], 02H
	     CALL ENQUEUE_ALARM

	 CHECK_THIRD_1:
	    CMP WORD PTR [USER1_TEMPTIME_SYRUP], 0
	     JE UPDATE_USER2
	     DEC WORD PTR [USER1_TEMPTIME_SYRUP]
	     CMP WORD PTR [USER1_TEMPTIME_SYRUP], 1
	     JNE UPDATE_USER2
	     MOV [SETALARM_USER1 + 2], 1
	     MOV [ALARMID], 03H
	     CALL ENQUEUE_ALARM
	     
	UPDATE_USER2:    
	    CMP WORD PTR [USER2_TEMPTIME_TABLET], 0
	     JE CHECK_SECOND_2
	     DEC WORD PTR [USER2_TEMPTIME_TABLET]
	     CMP WORD PTR [USER2_TEMPTIME_TABLET], 1
	     JNE CHECK_SECOND_2
	     MOV [SETALARM_USER2 + 0], 1
	     MOV [ALARMID], 11H
	     CALL ENQUEUE_ALARM
	     
	 CHECK_SECOND_2:
	    CMP WORD PTR [USER2_TEMPTIME_CAPSULE], 0
	     JE CHECK_THIRD_2
	     DEC WORD PTR [USER2_TEMPTIME_CAPSULE]
	     CMP WORD PTR [USER2_TEMPTIME_CAPSULE], 1
	     JNE CHECK_THIRD_2
	     MOV [SETALARM_USER2 + 1], 1
	     MOV [ALARMID], 12H
	     CALL ENQUEUE_ALARM

	 CHECK_THIRD_2:
	     CMP WORD PTR [USER2_TEMPTIME_SYRUP], 0
	     JE UPDATE_USER3
	     DEC WORD PTR [USER2_TEMPTIME_SYRUP]
	     CMP WORD PTR [USER2_TEMPTIME_SYRUP], 1
	     JNE UPDATE_USER3
	     MOV [SETALARM_USER2 + 2], 1
	     MOV [ALARMID], 13H
	     CALL ENQUEUE_ALARM
	     
	UPDATE_USER3:    
	    CMP WORD PTR [USER3_TEMPTIME_TABLET], 0
	     JE CHECK_SECOND_3
	     DEC WORD PTR [USER3_TEMPTIME_TABLET]
	     CMP WORD PTR [USER3_TEMPTIME_TABLET], 1
	     JNE CHECK_SECOND_3
	     MOV [SETALARM_USER3 + 0], 1
	     MOV [ALARMID], 21H
	     CALL ENQUEUE_ALARM
	     
	 CHECK_SECOND_3:
	    CMP WORD PTR [USER3_TEMPTIME_CAPSULE], 0
	     JE CHECK_THIRD_3
	     DEC WORD PTR [USER3_TEMPTIME_CAPSULE]
	     CMP WORD PTR [USER3_TEMPTIME_CAPSULE], 1
	     JNE CHECK_THIRD_3
	     MOV [SETALARM_USER3 + 1], 1
	     MOV [ALARMID], 22H
	     CALL ENQUEUE_ALARM

	 CHECK_THIRD_3:
	    CMP WORD PTR [USER3_TEMPTIME_SYRUP], 0
	     JE DONE
	     DEC WORD PTR [USER3_TEMPTIME_SYRUP]
	     CMP WORD PTR [USER3_TEMPTIME_SYRUP], 1
	     JNE DONE
	     MOV [SETALARM_USER3 + 2], 1
	     MOV [ALARMID], 23H
	     CALL ENQUEUE_ALARM
	     
	 DONE:	   	 
      ;===============================
    POP DX
    POP AX
    POPF
    IRET
 ISR5 ENDP
   
      ENQUEUE_ALARM PROC
	 PUSH AX
	 PUSH BX
	 PUSH SI
	 PUSH CX
	 
	 MOV SI, OFFSET ALARM_QUEUE ; Start of the queue
	 ADD SI, [QUEUE_TAIL]       		; Point to the tail of the queue

	 ; Check if the queue is full
	 MOV CX, [QUEUE_HEAD]    
	 INC [QUEUE_TAIL]        
	 CMP [QUEUE_TAIL], 10
	 JNE CHECK_WRAPAROUND
	 MOV [QUEUE_TAIL], 0       	 	; Wrap around if tail exceeds queue size
	 
	 CHECK_WRAPAROUND:
	    CMP [QUEUE_TAIL], CX
	    JE QUEUE_FULL              		; Queue is full if head equals tail

	    ; Add the alarm ID to the queue
	    MOV AL, [ALARMID]
	    MOV [SI], AL              
	    JMP ENQUEUE_DONE

	 QUEUE_FULL:
	    MOV SI, OFFSET ALARM_QUEUE
	    ADD SI, [QUEUE_HEAD]
	    MOV [SI], AL               		; Overwrite oldest alarm
	    INC [QUEUE_HEAD]           		; Advance head pointer
	    CMP [QUEUE_HEAD], 10
	    JNE ENQUEUE_DONE
	    MOV [QUEUE_HEAD], 0        	; Wrap around if head exceeds queue size

	 ENQUEUE_DONE:
	    POP CX
	    POP SI
	    POP BX
	    POP AX
	 RET
      ENQUEUE_ALARM ENDP

 PROCED5 ENDS
 
 ;DATA SEGMENT---------------------------------------------------------------------------------------------------------------------------------------------
 DATA SEGMENT
    ORG 06000H
 
      ;First 8255
      LCD_PORT1 EQU 0C0H
      LCD_PORT2 EQU 0C2H
      KEYPAD_PORT EQU 0C4H
      COM_REG1 EQU 0C6H

      ;Second 8255
      SDM_PORT EQU 0C8H
      BUZZER_PORT EQU 0CAH
      DISPENSER_PORT EQU 0CCH
      COM_REG2 EQU 0CEH

      ;Third 8255
      CAPSULE_PORT EQU 0D0H
      TABLET_PORT EQU 0D2H
      SYRUP_PORT EQU 0D4H
      COM_REG3 EQU 0D6H

      ;PIC8259
      PIC1 EQU 0F8H ; A0 = 0
      PIC2 EQU 0FAH ;A1 = 1
      ICW1 EQU 13H ; ICW4 needed, Single Mode, Call Address Interval of 8, Edge Triggered
      ICW2 EQU 80H ; Interrupt Vector Address: 80H - 87H
      ICW4 EQU 03H ; 8086 Mode, Auto EOI
      OCW1 EQU 70H ; IR0, IR1, IR2, IR3, IR7 are unmasked

      ;DOT MATRIX
      ROW_LEVELS DB 00111111B, 00011111B,00001111B,00000111B,00000011B,00000001B,00000000B

      CAPSULE DB	20		; 20 capsule
      TABLET DB 	20		; 20 tablets
      SYRUP DB	100		; 100 ml syrup

      ;LCD DISPLAY
      DEFAULT_MSG DB "Automatic Medicine", 0
      DEFAULT_MSG1 DB "Dispenser", 0

      SETPIN DB "Set Your Pin: ", 0
      SETPIN1 DB "Pin Set!", 0

      USER1_TEXT DB "User 1", 0
      USER2_TEXT DB "User 2", 0
      USER3_TEXT DB "User 3", 0

      WRONGPIN_MSG DB "Pin is incorrect!", 0
      DISPENSING_MSG DB "Dispensing...", 0
      
      SETTINGMEDS_MSG DB "Please Select One:" , 0
      SETTINGMEDS1_MSG DB "[1] Tablet ", 0
      SETTINGMEDS2_MSG DB "[2] Capsule", 0
      SETTINGMEDS3_MSG DB "[3] Syrup", 0

      INPUTTIME_MSG DB "Set Time Interval:" , 0
      INPUTDOSAGE_MSG DB "Set Dosage:" , 0

      MEDICINEISSET_MSG DB "Medicine is Set!" , 0

      ALARM_MSG DB "Time to take your", 0
      ALARM_MSG1 DB "medicine!", 0
      ALARM1_MSG DB "Input your pin: ", 0

      EMPTY_MSG DB "Please Refill......", 0
      EMPTY_MSG1 DB "The Medicine", 0
      
      REFILL_MSG DB "Refill Mode: " , 0
      REFILL_TABLET_MSG DB "[1] Tablet ", 0
      REFILL_CAPSULE_MSG DB "[2] Capsule", 0
      REFILL_SYRUP_MSG DB "[3] Syrup", 0

      REFILL_INPUT DB "Input Refill Amount:" , 0
      REFILLED_MSG DB "Refilled", 0

      ;USER INFO
      USER1PIN DB ?,?,?, ?
      USER2PIN DB ?,?,?, ?
      USER3PIN DB ?,?,?, ?

      USER1_TIME_CAPSULE DW 0
      USER1_TIME_TABLET DW 0
      USER1_TIME_SYRUP DW 0

      USER2_TIME_CAPSULE DW 0
      USER2_TIME_TABLET DW 0
      USER2_TIME_SYRUP DW 0
      
      USER3_TIME_CAPSULE DW 0
      USER3_TIME_TABLET DW 0
      USER3_TIME_SYRUP DW 0
      
      USER1_DOSAGE DB 0,0,0
      USER2_DOSAGE DB 0,0,0
      USER3_DOSAGE DB 0,0,0

      ;FLAGS
      ;0 = not set 1 = set
      PINSET_USER1 DB 0
      PINSET_USER2 DB 0
      PINSET_USER3 DB 0

      USERMODE DB 0 ;1 = user1 2 = user2 3 = user3
      MEDMODE DB 0 ;1 = tablet 2 = capsule 3 = syrup
      PINMODE DB 0 ; 0 = setting meds 1 = getting meds

      MISMATCH_COUNTER DB 0 ; pin validation
      LOWLEVEL_FLAG DB 0 ;for refill running low 
      
      ;1 if time for alarm, 0 if not
      SETALARM_USER1 DB 0,0,0
      SETALARM_USER2 DB 0,0,0
      SETALARM_USER3 DB 0,0,0

      ;1 = clicked 0 = not clicked
      USER1_CLICKED DB 0
      USER2_CLICKED DB 0
      USER3_CLICKED DB 0
      REFILL_CLICKED DB 0

      ;TEMP VARIABLES
      TEMPTIME DW 0
      TEMPDOSAGE DB 0    
      
      TEMP_HOURS DW 0
      TEMP_MINUTES DW 0
      TEMP_SECONDS DW 0

      USER1_TEMPTIME_CAPSULE DW 0
      USER1_TEMPTIME_TABLET DW 0
      USER1_TEMPTIME_SYRUP DW 0

      USER2_TEMPTIME_CAPSULE DW 0
      USER2_TEMPTIME_TABLET DW 0
      USER2_TEMPTIME_SYRUP DW 0
      
      USER3_TEMPTIME_CAPSULE DW 0
      USER3_TEMPTIME_TABLET DW 0
      USER3_TEMPTIME_SYRUP DW 0

      TEMP_FIRSTDIGIT DB 0
      TEMP_SECONDDIGIT DB 0
      TEMP_DECIMALVALUE DW 0
      CURSOR_POS DB 9CH 
      
      ;QUEUE 
      ALARM_QUEUE DB 10 DUP(?)    ; Circular queue with 10 slots
      QUEUE_HEAD DW 0             ; Points to the head of the queue
      QUEUE_TAIL DW 0             ; Points to the tail of the queue
      ALARMID DB 0
     
DATA ENDS
 
  ;STACK SEGMENT---------------------------------------------------------------------------------------------------------------------------------------------
 STEK SEGMENT STACK
    BOS DW 64d DUP(?)
    TOS LABEL WORD
 STEK ENDS
 
 ;CODE SEGMENT---------------------------------------------------------------------------------------------------------------------------------------------
 CODE SEGMENT PUBLIC 'CODE' 
   ASSUME CS:CODE,  DS: DATA,  SS:STEK
 ORG 08000H 
 
  START:
    MOV AX, DATA
    MOV DS, AX
    MOV AX, STEK
    MOV SS, AX
    LEA SP, TOS
    CLI
    
    ;PROGRAM 8255 ============================
    MOV DX, COM_REG1
    MOV AL, 89H ; MATRIX_PORT1 and MATRIX_PORT2 output, portc input
    OUT DX, AL 
    MOV DX, COM_REG2
    MOV AL, 80H ; MATRIX_PORT1, MATRIX_PORT2, portc, output
    OUT DX, AL   
    MOV DX, COM_REG3
    MOV AL, 80H  ; MATRIX_PORT1, MATRIX_PORT2, portc, output
    OUT DX, AL   

    ;PROGRAM 8259 ============================
    MOV DX, PIC1
    MOV AL, ICW1
    OUT DX, AL
    MOV DX, PIC2
    MOV AL, ICW2
    OUT DX, AL
    MOV AL, ICW4
    OUT DX, AL
    MOV AL, OCW1
    OUT DX, AL
    STI
    
    ;INTERRUPT VECTOR TABLE========================
   MOV AX, OFFSET ISR1
   MOV [ES:200H], AX ;80H
   MOV AX, SEG ISR1
   MOV [ES:202H], AX
   MOV AX, OFFSET ISR2
   MOV [ES:204H], AX ;81H
   MOV AX, SEG ISR2
   MOV [ES:206H], AX
   MOV AX, OFFSET ISR3
   MOV [ES:208H], AX ;82H
   MOV AX, SEG ISR3
   MOV [ES:20AH], AX
   MOV AX, OFFSET ISR4
   MOV [ES:20CH], AX ;83H
   MOV AX, SEG ISR4
   MOV [ES:20EH], AX
   MOV AX, OFFSET ISR5
   MOV [ES:21CH], AX ;87H
   MOV AX, SEG ISR5
   MOV [ES:21EH], AX
   
   CALL INIT_LCD
   
;==================================================

;FOREGROUND

;==================================================
 FOREGROUND:
 XOR AX, AX
 XOR BX, BX
 XOR CX, CX
 XOR DX, DX
   DISPLAY_DEFAULT:      
      CALL DEFAULT_DISPLAY   
      CALL MATRIX
;==================================================
;CHECK_LEVELS
;==================================================	
   CHECK_LEVELS:
      MOV AL, [LOWLEVEL_FLAG]
      CMP AL, 1
      JE RUNNING_LOW
      CALL PROCESS_ALARM
      JMP CHECK_ALL_STATUS
      
      RUNNING_LOW:
	 CALL RUNNINGLOW_DISPLAY
	 CMP BYTE PTR [REFILL_CLICKED], 1
	 JE GO_TO_REFILL_MODE
	 
	 CHECK_AGAIN:
	    JMP CHECK_LEVELS
	 
	 GO_TO_REFILL_MODE:
	    JMP REFILL_SEQUENCE
;==================================================
;CHECK_ALL_STATUS
;==================================================  
   CHECK_ALL_STATUS:
      CMP BYTE PTR [REFILL_CLICKED], 1
      JE GO_TO_REFILL_MODE
   
      CMP BYTE PTR [USER1_CLICKED], 1
      JE CHECKSTATUS_USER1

      CMP BYTE PTR [USER2_CLICKED], 1
      JE CHECKSTATUS_USER2

      CMP BYTE PTR [USER3_CLICKED], 1
      JE CHECKSTATUS_USER3
      JMP CHECK_LEVELS

	 CHECKSTATUS_USER1:
	    MOV [USERMODE], 1
	    MOV [USER1_CLICKED], 0
	    MOV AL, [PINSET_USER1]
	    CMP AL , 0   
	    JE SETPINUSER1 ;Pin is not yet set

	    ;Pin is already set
	    MOV [PINMODE], 1  
	    CALL ASKUSERPIN
	    JMP DISPLAY_DEFAULT
	    
	 CHECKSTATUS_USER2:
	    MOV [USERMODE], 2
	    MOV [USER2_CLICKED], 0
	    MOV AL, [PINSET_USER2]
	    CMP AL , 0
	    JE SETPINUSER2  ;Pin is not yet set
	    
	    ;Pin is already set
	    MOV [PINMODE], 1
	    CALL ASKUSERPIN
	    JMP DISPLAY_DEFAULT    
	    
	 CHECKSTATUS_USER3:
	    MOV [USERMODE], 3
	    MOV [USER3_CLICKED], 0
	    MOV AL, [PINSET_USER3]
	    CMP AL , 0
	    JE SETPINUSER3  ;Pin is not yet set
	    
	    ;Pin is already set
	    MOV [PINMODE], 1
	    CALL ASKUSERPIN
	    JMP DISPLAY_DEFAULT
	    
	 SETPINUSER1:
	    CALL SETTING_PIN
	    CALL DELAY_2S
	    JMP DISPLAY_DEFAULT

	 SETPINUSER2:
	    CALL SETTING_PIN
	    CALL DELAY_2S
	    JMP DISPLAY_DEFAULT

	 SETPINUSER3:
	 CALL SETTING_PIN
	 CALL DELAY_2S
	 JMP DISPLAY_DEFAULT

 HERE:         
JMP SKIP
;====================================
;DISPLAYS (DEFAULT, RUNNINGLOW,  ALARM MESSAGE, REFILL_PROCESS)
;==================================================
   DEFAULT_DISPLAY:
      CALL INIT_LCD
      MOV AL, 0C1H              
      CALL INST_CTRL
      MOV SI, OFFSET DEFAULT_MSG
      CALL DISPLAY_STRING
      MOV AL, 09AH              
      CALL INST_CTRL
      MOV SI, OFFSET DEFAULT_MSG1
      CALL DISPLAY_STRING
   RET
   
   REFILL_PROCESS_DISPLAY:	
      CALL DELAY_1S
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      MOV AL, 80H
      CALL INST_CTRL
      MOV SI, OFFSET REFILL_INPUT
      CALL DISPLAY_STRING
      CALL DELAY_2S
      MOV [CURSOR_POS], 09DH
      MOV AL, 09DH
      CALL INST_CTRL
      MOV AL, 0FH           
      CALL INST_CTRL
   RET

   RUNNINGLOW_DISPLAY:
      MOV AL, 0C1H              
      CALL INST_CTRL
      MOV SI, OFFSET EMPTY_MSG
      CALL DISPLAY_STRING
      MOV AL, 09AH              
      CALL INST_CTRL
      MOV SI, OFFSET EMPTY_MSG1
      CALL DISPLAY_STRING
      CALL DELAY_2S
   RET

   DISPLAY_ALARM_MESSAGE:
      XOR AX,AX
      MOV AL, [USERMODE]
      CMP AL, 1
      JE ALARM_FOR_USER1
      CMP AL, 2
      JE ALARM_FOR_USER2
      CMP AL, 3
      JE ALARM_FOR_USER3
      JMP NEXT_LINE  

   ALARM_FOR_USER1:
      CALL DELAY_2S
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      MOV AL, 88H              
      CALL INST_CTRL
      MOV SI, OFFSET USER1_TEXT
      CALL DISPLAY_STRING
      JMP NEXT_LINE

   ALARM_FOR_USER2:
      CALL DELAY_2S
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      MOV AL, 88H              
      CALL INST_CTRL
      MOV SI, OFFSET USER2_TEXT
      CALL DISPLAY_STRING
      JMP NEXT_LINE

   ALARM_FOR_USER3:
      CALL DELAY_2S
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      MOV AL, 88H             
      CALL INST_CTRL
      MOV SI, OFFSET USER3_TEXT
      CALL DISPLAY_STRING

   NEXT_LINE:
      MOV AL, 0C1H              
      CALL INST_CTRL
      MOV SI, OFFSET ALARM_MSG
      CALL DISPLAY_STRING
      MOV AL, 09AH              
      CALL INST_CTRL
      MOV SI, OFFSET ALARM_MSG1
      CALL DISPLAY_STRING
      CALL DELAY_2S
      CALL BUZZER_BEEP
   RET
;==================================================
;MENU (MEDICINE TYPES, REFILL TYPES)
;================================================== 
   MENU_TYPES:
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      MOV AL, 80H
      CALL INST_CTRL
      MOV SI, OFFSET SETTINGMEDS_MSG
      CALL DISPLAY_STRING

      MOV AL, 0C0H
      CALL INST_CTRL
      MOV SI, OFFSET SETTINGMEDS1_MSG
      CALL DISPLAY_STRING

      MOV AL, 94H
      CALL INST_CTRL
      MOV SI, OFFSET SETTINGMEDS2_MSG
      CALL DISPLAY_STRING

      MOV AL, 0D4H
      CALL INST_CTRL
      MOV SI, OFFSET SETTINGMEDS3_MSG
      CALL DISPLAY_STRING
   RET

   MENU_REFILL:
      CALL DELAY_1S
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      CALL DELAY_1S
      MOV AL, 80H
      CALL INST_CTRL
      MOV SI, OFFSET REFILL_MSG
      CALL DISPLAY_STRING

      MOV AL, 0C0H
      CALL INST_CTRL
      MOV SI, OFFSET REFILL_TABLET_MSG
      CALL DISPLAY_STRING

      MOV AL, 94H
      CALL INST_CTRL
      MOV SI, OFFSET REFILL_CAPSULE_MSG
      CALL DISPLAY_STRING

      MOV AL, 0D4H
      CALL INST_CTRL
      MOV SI, OFFSET REFILL_SYRUP_MSG
      CALL DISPLAY_STRING
   RET
;==================================================
;ASKUSERPIN, PIN_VALIDATION, 
;==================================================
   ASKUSERPIN:
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      MOV AL, 0C2H              
      CALL INST_CTRL
      MOV SI, OFFSET ALARM1_MSG
      CALL DISPLAY_STRING

      XOR AX,AX
      MOV AL, [USERMODE]
      CMP AL, 1
      JE HANDLE_USER1
      CMP AL, 2
      JE HANDLE_USER2
      CMP AL, 3
      JE HANDLE_USER3

      HANDLE_USER1:
	    MOV SI, OFFSET USER1PIN
	    JMP PIN_VALIDATION

      HANDLE_USER2:
	    MOV SI, OFFSET USER2PIN
	    JMP PIN_VALIDATION

      HANDLE_USER3:
	    MOV SI, OFFSET USER3PIN
	    JMP PIN_VALIDATION

   PIN_VALIDATION:
      MOV CX, 4                 			 ; Set counter for 4 digits
      MOV [MISMATCH_COUNTER], 0   	; Initialize counter for correct matches
      MOV [CURSOR_POS], 9CH              
      MOV AL, 9CH
      CALL INST_CTRL
      MOV AL, 0FH          
      CALL INST_CTRL 

      GET_KEYPAD_INPUT:
	 CALL READ_KEYPAD       
	 CMP BL, '#'             
	 JE VALIDATE_PIN         

	 LODSB              
	 CMP BL, AL             
	 JE NEXT_DIGIT        
	 INC [MISMATCH_COUNTER]     
	 NEXT_DIGIT:
	    CALL DISPLAY_DIGIT        
	    CALL CHECK_KEY_RELEASE
	    LOOP GET_KEYPAD_INPUT        

	 VALIDATE_PIN:
	    MOV AL, [MISMATCH_COUNTER]
	    CMP AL, 0              
	    JNE FAIL_PIN                

	 SUCCESS_PIN:  
	    CMP BYTE PTR [PINMODE], 1
	    JE SHOW_MENU ; If PINMODE = 1, proceed with menu

	    ; If PINMODE = 0, proceed with dispensing
	    CALL DISPENSE_MEDICINE
	     CALL RESETTING_ALARMS
	    JMP FOREGROUND
	  
	 FAIL_PIN:
	    MOV AL, 0CH          
	    CALL INST_CTRL 
	    CALL CLEARSCREEN         
	    MOV AL, 0C2H              
	    CALL INST_CTRL
	    MOV AL, 40H
	    MOV SI, OFFSET WRONGPIN_MSG
	    CALL DISPLAY_STRING
	    
	    CMP BYTE PTR [PINMODE], 1
	    JE RETURN_WAY
	    CALL DELAY_2S
	    JMP ASKUSERPIN
	    
	    RETURN_WAY:
	    RET

	 SHOW_MENU:
	    CALL MENU_TYPES
	    MOV [PINMODE], 0
	    CALL CHOICE_TYPE
	    RET
;==================================================
;SETTING_PIN AND SAVING_PIN
;==================================================
   SETTING_PIN:   
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      MOV AL, 0C4H              
      CALL INST_CTRL
      MOV SI, OFFSET SETPIN
      CALL DISPLAY_STRING
      MOV AL, 0FH
      CALL INST_CTRL
      MOV AL, 9CH
      CALL INST_CTRL

      KEYPADINPUT:
	 MOV AL, [USERMODE]
	 CMP AL, 1
	 JE SET_PIN_USER1
	 CMP AL, 2
	 JE SET_PIN_USER2
	 CMP AL, 3
	 JE SET_PIN_USER3

	 SET_PIN_USER1:
	    MOV DI, OFFSET USER1PIN
	    JMP GET_INPUT
	 SET_PIN_USER2:
	    MOV DI, OFFSET USER2PIN
	    JMP GET_INPUT
	 SET_PIN_USER3:
	    MOV DI, OFFSET USER3PIN
	    JMP GET_INPUT

	 GET_INPUT:
	    CALL READ_KEYPAD
	    CMP BL, '*'      
	    JE CLEAR_ALL   
	    CMP BL, '#'    
	    JE SAVING_PIN      

	    CMP  CURSOR_POS, 0A0H
	    JE GET_INPUT
	    MOV [DI], BL
	    INC DI
	    CALL DISPLAY_DIGIT
	    
	    BACK:
	       CALL CHECK_KEY_RELEASE
	       JMP GET_INPUT

	 CLEAR_ALL:
	    MOV AL, CURSOR_POS  
	    CALL INST_CTRL       
	    MOV AL, 20H       
	    CALL DATA_CTRL     
	    DEC CURSOR_POS

	    CMP  CURSOR_POS, 9BH
	    JNE CLEAR_ALL
	    MOV CURSOR_POS, 9CH
	    CALL CHECK_KEY_RELEASE
	    JMP KEYPADINPUT
	    
   SAVING_PIN:
      MOV CURSOR_POS, 09CH
      MOV AL, [USERMODE]
      CMP AL, 1
      JE USERSETPIN1
      CMP AL, 2
      JE USERSETPIN2
      CMP AL, 3
      JE USERSETPIN3

      USERSETPIN1:
	 MOV AL, 1
	 MOV [PINSET_USER1], AL
	 JMP SET_NOTIF
      USERSETPIN2:
	 MOV AL, 1
	 MOV [PINSET_USER2], AL
	 JMP SET_NOTIF
      USERSETPIN3:
	 MOV AL, 1
	 MOV [PINSET_USER3], AL
	 JMP SET_NOTIF

      SET_NOTIF:
	 MOV AL, 0CH          
	 CALL INST_CTRL 
	 CALL CLEARSCREEN
	 MOV AL, 0C6H              
	 CALL INST_CTRL
	 MOV SI, OFFSET SETPIN1
	 CALL DISPLAY_STRING
RET
;==================================================
;SCHEDULE MEDICINE
;==================================================
   CHOICE_TYPE:
      CALL READ_KEYPAD

      CMP BL, '1'                
      JE GOTO_TABLET          
      CMP BL, '2'              
      JE GOTO_CAPSULE          
      CMP BL, '3'              
      JE GOTO_SYRUP       
      
      CALL CHECK_KEY_RELEASE
      LOOP CHOICE_TYPE        

      GOTO_TABLET:
	 MOV [MEDMODE], 1
	 JMP GO_NEXT		
      GOTO_CAPSULE:
	 MOV [MEDMODE], 2
	 JMP GO_NEXT
      GOTO_SYRUP:
	 MOV [MEDMODE], 3
	 JMP GO_NEXT

      GO_NEXT:	
	 CALL SET_CLOCK
	 CALL SET_DOSAGE
	 CALL SAVEDATA
	 RET
;==================================================
;SET CLOCK
;==================================================
   SET_CLOCK :
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      MOV AL, 80H
      CALL INST_CTRL
      MOV SI, OFFSET INPUTTIME_MSG 
      CALL DISPLAY_STRING

      SET_DOTS:
	 MOV AL, 9CH
	 CALL INST_CTRL
	 MOV AL, ':'
	 CALL DATA_CTRL    
	 MOV AL, 9FH
	 CALL INST_CTRL
	 MOV AL, ':'
	 CALL DATA_CTRL
	 MOV AL, 0FH          
	 CALL INST_CTRL 
	 CALL DELAY_2S

   ;HOURS=====================================================================
      HOURS:
	 MOV AL, 9AH
	 CALL INST_CTRL
	 MOV [CURSOR_POS], 9AH

	 GOTO_HOURS:
	 XOR BX,BX
	 CALL READ_KEYPAD
	 
	 CMP BL, '*'
	 JE CLEAR_CLOCK	 
	 
	 CMP CURSOR_POS, 9AH
	 JE SET_FIRST_DIGIT
	 CMP CURSOR_POS, 9BH
	 JE SET_SECOND_DIGIT
	 
	 GOTO_HOURS_GO:
	  CMP BL, '#'              
	  JE MINUTES         
	 JMP GOTO_HOURS

	 SET_FIRST_DIGIT:
	    CMP BL, '#'              
	    JE GOTO_HOURS      
	    CMP BL, '*'
	    JE CLEAR_CLOCK
	    MOV [TEMP_FIRSTDIGIT], BL
	    CALL DISPLAY_DIGIT
	    JMP GO_TO_LOOP
	 SET_SECOND_DIGIT: 	   
	    CMP BL, '#'                
	    JE GOTO_HOURS        
	    CMP BL, '*'
	    JE CLEAR_CLOCK
	    MOV [TEMP_SECONDDIGIT], BL
	    CALL DISPLAY_DIGIT
	    CALL CONVERT_TO_DECIMAL

	 HOURS_TO_SECONDS:
	    MOV CX,  3600
	    MOV AX, [TEMP_DECIMALVALUE]
	    MUL CX
	    MOV [TEMP_HOURS], AX

	 GO_TO_LOOP:
	    CALL CHECK_KEY_RELEASE
	    LOOP GOTO_HOURS   
   ;MINUTES=====================================================================
      MINUTES:
	 CALL DELAY_2S
	 MOV AL, 9DH
	 CALL INST_CTRL
	 MOV AL, 0FH           
	 CALL INST_CTRL 
	 MOV [CURSOR_POS], 9DH

	 GOTO_MINUTES :    
	    XOR BX,BX
	    CALL READ_KEYPAD
	 
	    CMP BL, '*'
	    JE CLEAR_CLOCK
	 
	    CMP CURSOR_POS, 9DH
	    JE MSET_FIRST_DIGIT
	    CMP CURSOR_POS, 9EH
	    JE MSET_SECOND_DIGIT
	    
	GOTO_MINUTES_GO:
	  CMP BL, '#'           
	  JE SECONDS         
	 JMP GOTO_MINUTES
	

	 MSET_FIRST_DIGIT:
	    CMP BL, '#'              
	    JE GOTO_MINUTES        
	    CMP BL, '*'
	    JE CLEAR_CLOCK
	    CMP BL, '6'
	    JG GOTO_MINUTES
	    MOV [TEMP_FIRSTDIGIT], BL
	    CALL DISPLAY_DIGIT
	    JMP GO_HERE
	 MSET_SECOND_DIGIT:
	    CMP BL, '#'              
	    JE GOTO_MINUTES
	    CMP BL, '*'
	    JE CLEAR_CLOCK
	    MOV [TEMP_SECONDDIGIT], BL
	    CALL DISPLAY_DIGIT
	    CALL CONVERT_TO_DECIMAL

	 MINUTES_TO_SECONDS:
	    MOV CX,  60
	    MOV AX, [TEMP_DECIMALVALUE]
	    MUL CX
	    MOV [TEMP_MINUTES], AX    

	 GO_HERE:
	    CALL CHECK_KEY_RELEASE
	    LOOP GOTO_MINUTES   
   ;SECONDS================================================	
      SECONDS:
	 CALL DELAY_2S
	 MOV AL, 0A0H
	 CALL INST_CTRL
	 MOV [CURSOR_POS], 0A0H

	 GOTO_SECONDS :
	 XOR BX, BX
	 CALL READ_KEYPAD
	 
	 CMP BL, '*'
	 JE CLEAR_CLOCK
	 
	 CMP CURSOR_POS, 0A0H
	 JE SSET_FIRST_DIGIT
	 CMP CURSOR_POS, 0A1H
	 JE SSET_SECOND_DIGIT
	 
	 GOTO_SECONDS_GO:
	  CMP BL, '#'              
	  JE NEXT_STEP        
	 JMP GOTO_SECONDS

	 SSET_FIRST_DIGIT:
	    CMP BL, '#'            
	    JE GOTO_SECONDS       
	    CMP BL, '*'
	    JE CLEAR_CLOCK
	    CMP BL, '6'
	    JG GOTO_SECONDS
	    MOV [TEMP_FIRSTDIGIT], BL
	    CALL DISPLAY_DIGIT
	    JMP NEXT_HERE
	 SSET_SECOND_DIGIT:
	    CMP BL, '#'              
	    JE GOTO_SECONDS         
	    CMP BL, '*'
	    JE CLEAR_CLOCK
	    MOV [TEMP_SECONDDIGIT], BL
	    CALL DISPLAY_DIGIT
	    CALL CONVERT_TO_DECIMAL
	    
	    MOV AX, [TEMP_DECIMALVALUE]
	    MOV [TEMP_SECONDS], AX

	 NEXT_HERE:
	    CALL CHECK_KEY_RELEASE
	    LOOP GOTO_SECONDS   

	 NEXT_STEP:
	    CALL SET_TIME
	 RET

	 CLEAR_CLOCK:
	    MOV AL, CURSOR_POS
	    CALL INST_CTRL
	    MOV AL, 20H       
	    CALL DATA_CTRL     
	    DEC CURSOR_POS

	    CMP  CURSOR_POS, 99H
	    JNE CLEAR_CLOCK
	    MOV CURSOR_POS, 9AH
	    JMP SET_DOTS
;==================================================
;SET TIME
;==================================================
   SET_TIME:
      XOR AX, AX
      MOV AX, [TEMP_HOURS]
      ADD AX, [TEMP_MINUTES]
      ADD AX, [TEMP_SECONDS]
      ADD AX, 1
      
      MOV [TEMPTIME], AX
      CALL CLEARSCREEN
      CALL DELAY_2S
   RET
;==================================================
;SET DOSAGE
;==================================================
   SET_DOSAGE:	
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      MOV AL, 80H
      CALL INST_CTRL
      MOV SI, OFFSET INPUTDOSAGE_MSG
      CALL DISPLAY_STRING
      CALL DELAY_2S

   AFTER_CLEAR_DOSAGE:
      MOV [CURSOR_POS], 09DH
      MOV AL, 09DH
      CALL INST_CTRL
      MOV AL, 0FH           
      CALL INST_CTRL

   GET_DOSAGE:  
      XOR BX,BX
      CALL READ_KEYPAD

      CMP BL, '*'      
      JE CLEAR_DOSAGE   
      CMP BL, '#'    
      JE VALIDATE_DOSAGE      

      CMP CURSOR_POS, 09DH
      JE SET_FIRST
      CMP CURSOR_POS, 09EH
      JE SET_SECOND
      JMP GET_DOSAGE

      SET_FIRST:
	 MOV [TEMP_FIRSTDIGIT], BL
	 CALL DISPLAY_DIGIT
	 CALL CHECK_KEY_RELEASE   
	 JMP GET_DOSAGE
      SET_SECOND:
	 MOV [TEMP_SECONDDIGIT], BL
	 CALL DISPLAY_DIGIT
	 CALL CHECK_KEY_RELEASE   
	 JMP GET_DOSAGE

      VALIDATE_DOSAGE: 
	 CALL CONVERT_TO_DECIMAL
	 MOV AX, [TEMP_DECIMALVALUE]
	 MOV [TEMPDOSAGE], AL

	 XOR AX, AX
	 MOV AL, [MEDMODE]
	 CMP AL, 3
	 JE CHECK_SYRUP_LIMIT 
	 JMP CHECK_PILL_LIMIT 

      CHECK_PILL_LIMIT :
	 MOV AL, [TEMPDOSAGE]
	 CMP AL, 19
	 JG NOT_ALLOWED
	 JMP VALID_INPUT
      CHECK_SYRUP_LIMIT :
	 MOV AL, [TEMPDOSAGE]
	 CMP AL, 99
	 JG NOT_ALLOWED
	 JMP VALID_INPUT

      NOT_ALLOWED:
	 CALL INVALID_BEEP
	 JMP CLEAR_DOSAGE

      VALID_INPUT:
      RET

   CLEAR_DOSAGE:
      MOV AL, CURSOR_POS  
      CALL INST_CTRL       
      MOV AL, 20H       
      CALL DATA_CTRL     
      DEC CURSOR_POS

      CMP  CURSOR_POS, 9DH
      JGE CLEAR_DOSAGE
      JMP AFTER_CLEAR_DOSAGE
;==================================================
;SAVE SCHEDULE FOR MEDICINE
;==================================================
   SAVEDATA:
   XOR AX, AX
   MOV AL, [USERMODE]  

   CMP AL, 1
   JE SAVEUSER1           
   CMP AL, 2
   JE SAVEUSER2           
   CMP AL, 3
   JE SAVEUSER3           
      
   ;USER1==============================================
   SAVEUSER1:
      ; Load MEDMODE as an index (zero-based)
      XOR AX,AX
      MOV AL, [MEDMODE]     
      MOV BX, [TEMPTIME]
      MOV CL, [TEMPDOSAGE]

      CMP AL, 1
      JE SAVE_TO_TABLET_1
      CMP AL, 2
      JE SAVE_TO_CAPSULE_1
      CMP AL, 3
      JE SAVE_TO_SYRUP_1

      SAVE_TO_TABLET_1:
	 MOV [USER1_TIME_TABLET], BX
	 MOV [USER1_TEMPTIME_TABLET], BX
	 MOV [USER1_DOSAGE + 0], CL
	 JMP DONE_SAVING

      SAVE_TO_CAPSULE_1:
	 MOV [USER1_TIME_CAPSULE], BX
	 MOV [USER1_TEMPTIME_CAPSULE], BX
	 MOV [USER1_DOSAGE + 1], CL
	 JMP DONE_SAVING

      SAVE_TO_SYRUP_1:
	 MOV [USER1_TIME_SYRUP], BX
	 MOV [USER1_TEMPTIME_SYRUP], BX
	 MOV [USER1_DOSAGE + 2], CL
	 JMP DONE_SAVING

   ;USER2===============================================
   SAVEUSER2:
      ; Load MEDMODE as an index (zero-based)
      XOR AX,AX
      MOV AL, [MEDMODE]        
      MOV BX, [TEMPTIME]
      MOV CL, [TEMPDOSAGE]

      CMP AL, 1
      JE SAVE_TO_TABLET_2
      CMP AL, 2
      JE SAVE_TO_CAPSULE_2
      CMP AL, 3
      JE SAVE_TO_SYRUP_2

      SAVE_TO_TABLET_2:
	 MOV [USER2_TIME_TABLET], BX
	 MOV [USER2_TEMPTIME_TABLET], BX
	 MOV [USER2_DOSAGE + 0], CL
	 JMP DONE_SAVING

      SAVE_TO_CAPSULE_2:
	 MOV [USER2_TIME_CAPSULE], BX
	 MOV [USER2_TEMPTIME_CAPSULE], BX
	 MOV [USER2_DOSAGE + 1], CL
	 JMP DONE_SAVING

      SAVE_TO_SYRUP_2:
	 MOV [USER2_TIME_SYRUP], BX
	 MOV [USER2_TEMPTIME_SYRUP], BX
	 MOV [USER2_DOSAGE + 2], CL
	 JMP DONE_SAVING

   ;USER3===============================================     
   SAVEUSER3:
      ; Load MEDMODE as an index (zero-based)
      XOR AX,AX
      MOV AL, [MEDMODE]      
      MOV BX, [TEMPTIME]
      MOV CL, [TEMPDOSAGE]

      CMP AL, 1
      JE SAVE_TO_TABLET_3
      CMP AL, 2
      JE SAVE_TO_CAPSULE_3
      CMP AL, 3
      JE SAVE_TO_SYRUP_3
      
      SAVE_TO_TABLET_3:
	 MOV [USER3_TIME_TABLET], BX
	 MOV [USER3_TEMPTIME_TABLET], BX
	 MOV [USER3_DOSAGE + 0], CL
	 JMP DONE_SAVING

      SAVE_TO_CAPSULE_3:
	 MOV [USER3_TIME_CAPSULE], BX
	 MOV [USER3_TEMPTIME_CAPSULE], BX
	 MOV [USER3_DOSAGE + 1], CL
	 JMP DONE_SAVING

      SAVE_TO_SYRUP_3:
	 MOV [USER3_TIME_SYRUP], BX
	 MOV [USER3_TEMPTIME_SYRUP], BX
	 MOV [USER3_DOSAGE + 2], CL
	 JMP DONE_SAVING

      DONE_SAVING:
	 MOV AL, 0CH          
	 CALL INST_CTRL 
	 CALL CLEARSCREEN
	 MOV AL, 0C2H              
	 CALL INST_CTRL
	 MOV SI, OFFSET MEDICINEISSET_MSG
	 CALL DISPLAY_STRING
	 CALL DELAY_2S
	 RET
;==================================================
;DISPENSE_MEDICINE
;================================================== 
   DISPENSE_MEDICINE:
      XOR AX, AX
      MOV AL, [USERMODE]

      CMP AL, 1
      JE USER_1DISPENSE
      CMP AL, 2
      JE USER_2DISPENSE
      CMP AL, 3
      JE USER_3DISPENSE
   
   ;USER1================================================
      USER_1DISPENSE:
	 XOR AX, AX
	 MOV AL, [MEDMODE]       

	 CMP AL, 1
	 JE USER1_TABLET_DOSAGE
	 CMP AL, 2
	 JE USER1_CAPSULE_DOSAGE
	 CMP AL, 3
	 JE USER1_SYRUP_DOSAGE

	 USER1_TABLET_DOSAGE:
	    MOV AL, [USER1_DOSAGE + 0]
	    MOV [TEMPDOSAGE], AL
	    JMP DISPENSE_PILL
	 USER1_CAPSULE_DOSAGE:
	    MOV AL, [USER1_DOSAGE + 1]
	    MOV [TEMPDOSAGE], AL
	    JMP DISPENSE_PILL
	 USER1_SYRUP_DOSAGE:
	    MOV AL, [USER1_DOSAGE + 2]
	    MOV [TEMPDOSAGE], AL
	    JMP DISPENSE_SYRUP

   ;USER2================================================
      USER_2DISPENSE:
	 XOR AX, AX
	 MOV AL, [MEDMODE]   

	 CMP AL, 1
	 JE USER2_TABLET_DOSAGE
	 CMP AL, 2
	 JE USER2_CAPSULE_DOSAGE
	 CMP AL, 3
	 JE USER2_SYRUP_DOSAGE

	 USER2_TABLET_DOSAGE:
	    MOV AL, [USER2_DOSAGE + 0]
	    MOV [TEMPDOSAGE], AL
	    JMP DISPENSE_PILL
	 USER2_CAPSULE_DOSAGE:
	    MOV AL, [USER2_DOSAGE + 1]
	    MOV [TEMPDOSAGE], AL
	    JMP DISPENSE_PILL
	 USER2_SYRUP_DOSAGE:
	    MOV AL, [USER2_DOSAGE + 2]
	    MOV [TEMPDOSAGE], AL
	    JMP DISPENSE_SYRUP
	    
   ;USER3================================================
      USER_3DISPENSE:
	 XOR AX, AX
	 MOV AL, [MEDMODE]       

	 CMP AL, 1
	 JE USER3_TABLET_DOSAGE
	 CMP AL, 2
	 JE USER3_CAPSULE_DOSAGE
	 CMP AL, 3
	 JE USER3_SYRUP_DOSAGE

	 USER3_TABLET_DOSAGE:
	    MOV AL, [USER3_DOSAGE + 0]
	    MOV [TEMPDOSAGE], AL
	    JMP DISPENSE_PILL
	 USER3_CAPSULE_DOSAGE:
	    MOV AL, [USER3_DOSAGE + 1]
	    MOV [TEMPDOSAGE], AL
	    JMP DISPENSE_PILL
	 USER3_SYRUP_DOSAGE:
	    MOV AL, [USER3_DOSAGE + 2]
	    MOV [TEMPDOSAGE], AL
	    JMP DISPENSE_SYRUP

      DISPENSE_PILL:
	 CALL DISPENSE_SEQUENCE
	 CALL DISPENSE_TABLET_CAPSULE
	 JMP DISPENSE_DONE

      DISPENSE_SYRUP:
	 CALL DISPENSE_SEQUENCE
	 CALL DISPENSE_SYRUP_FUNC
	 JMP DISPENSE_DONE

	 DISPENSE_TABLET_CAPSULE:
	    MOV AL, [MEDMODE]
	    CMP AL, 1
	    JE TABLET_LOOP
	    CMP AL, 2
	    JE CAPSULE_LOOP

	       TABLET_LOOP:
		  MOV BL, [TEMPDOSAGE]  		 
		  DISPENSE_TABLET:
		     CMP BL, 0
		     JE DISPENSE_DONE
		     DEC BYTE PTR [TABLET]          ; Decrement tablet count
		     DEC BL 
		     CALL DISPENSER1_ON
		     CALL DISPENSER_OFF
		     JMP DISPENSE_TABLET

	       CAPSULE_LOOP:
		  MOV BL, [TEMPDOSAGE]  	
		  DISPENSE_CAPSULE:
		     CMP BL, 0
		     JE DISPENSE_DONE
		     DEC BYTE PTR [CAPSULE]          ; Decrement capsule count
		     DEC BL
		     CALL DISPENSER2_ON
		     CALL DISPENSER_OFF
		     JMP DISPENSE_CAPSULE

	 DISPENSE_SYRUP_FUNC:
	    MOV BL, [TEMPDOSAGE]  
	    CALL DISPENSER3_ON
	    DISPENSE_SYRUP_LOOP:  
	       CMP BL, 0
	       JE MINUS
	       CMP BL, 1
	       JNE PROCEED
	       DEC BL 
	       JMP MINUS
		  PROCEED:
		     SUB BL, 2
		     JMP DISPENSE_SYRUP_LOOP
	       MINUS:
		  MOV AL, [TEMPDOSAGE]
		  SUB BYTE PTR [SYRUP] , AL        ; Decrement syrup count

      DISPENSE_DONE:
	 RET
;==================================================
;RESET ALARMS
;================================================== 
RESETTING_ALARMS:
	 MOV AL, [USERMODE]
	 CMP AL, 1
	 JE USER1_RESET
	 CMP AL, 2
	 JE USER2_RESET
	 CMP AL, 3
	 JE USER3_RESET
	 
   USER1_RESET:
      MOV AL, [MEDMODE]
      CMP AL, 1
      JE RESET_TABLET_ALARM_1
      CMP AL, 2
      JE RESET_CAPSULE_ALARM_1
      CMP AL, 3
      JE RESET_SYRUP_ALARM_1

   USER2_RESET:
      MOV AL, [MEDMODE]
      CMP AL, 1
      JE RESET_TABLET_ALARM_2
      CMP AL, 2
      JE RESET_CAPSULE_ALARM_2
      CMP AL, 3
      JE RESET_SYRUP_ALARM_2

   USER3_RESET:
      MOV AL, [MEDMODE]
      CMP AL, 1
      JE RESET_TABLET_ALARM_3
      CMP AL, 2
      JE RESET_CAPSULE_ALARM_3
      CMP AL, 3
      JE RESET_SYRUP_ALARM_3
      
      
   ;USER1================================================
   RESET_TABLET_ALARM_1:
      CALL DELAY_2S
      CALL DELAY_2S
      MOV [SETALARM_USER1 + 0], 0
      MOV AX, [USER1_TIME_TABLET]
      MOV [USER1_TEMPTIME_TABLET], AX
      JMP FINISH_RESET

   RESET_CAPSULE_ALARM_1:
       CALL DELAY_2S
      CALL DELAY_2S
      MOV [SETALARM_USER1 + 1], 0
      MOV AX, [USER1_TIME_CAPSULE]
      MOV [USER1_TEMPTIME_CAPSULE], AX
      JMP FINISH_RESET
      
   RESET_SYRUP_ALARM_1:
      CALL DELAY_2S
      CALL DELAY_2S
      MOV [SETALARM_USER1 + 2], 0
      MOV AX, [USER1_TIME_SYRUP]
      MOV [USER1_TEMPTIME_SYRUP], AX
      CALL DELAY_2S
      CALL DISPENSER_OFF
      JMP FINISH_RESET
      
   ;USER2================================================
   RESET_TABLET_ALARM_2:
      CALL DELAY_2S
      CALL DELAY_2S
      MOV [SETALARM_USER2 + 0], 0
      MOV AX, [USER2_TIME_TABLET]
      MOV [USER2_TEMPTIME_TABLET], AX
      JMP FINISH_RESET

   RESET_CAPSULE_ALARM_2:
      CALL DELAY_2S
      CALL DELAY_2S
      MOV [SETALARM_USER2 + 1], 0
      MOV AX, [USER2_TIME_CAPSULE]
      MOV [USER2_TEMPTIME_CAPSULE], AX
      JMP FINISH_RESET

   RESET_SYRUP_ALARM_2:
      CALL DELAY_2S
      CALL DELAY_2S
      MOV [SETALARM_USER2 + 2], 0
      MOV AX, [USER2_TIME_SYRUP]
      MOV [USER2_TEMPTIME_SYRUP], AX
      CALL DELAY_2S
      CALL DISPENSER_OFF
      JMP FINISH_RESET
      
   ;USER3================================================
   RESET_TABLET_ALARM_3:
      CALL DELAY_2S
      CALL DELAY_2S
      MOV [SETALARM_USER3 + 0], 0
      MOV AX, [USER3_TIME_TABLET]
      MOV [USER3_TEMPTIME_TABLET], AX
      JMP FINISH_RESET

   RESET_CAPSULE_ALARM_3:
      CALL DELAY_2S
      CALL DELAY_2S
      MOV [SETALARM_USER3 + 1], 0
      MOV AX, [USER3_TIME_CAPSULE]
      MOV [USER3_TEMPTIME_CAPSULE], AX
      JMP FINISH_RESET

   RESET_SYRUP_ALARM_3:
      CALL DELAY_2S
      CALL DELAY_2S
      MOV [SETALARM_USER3 + 2], 0
      MOV AX, [USER3_TIME_SYRUP]
      MOV [USER3_TEMPTIME_SYRUP], AX
      CALL DELAY_2S
      CALL DISPENSER_OFF
      JMP FINISH_RESET

      FINISH_RESET:
      RET
      
   DISPENSE_SEQUENCE:
      CALL DELAY_2S
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      CALL DELAY_2S
      MOV AL, 0C4H            
      CALL INST_CTRL
      MOV SI, OFFSET DISPENSING_MSG
      CALL DISPLAY_STRING
      CALL DELAY_2S
   RET
;==================================================
;REFILL_SEQUENCE
;==================================================
   REFILL_SEQUENCE:
      MOV [REFILL_CLICKED], 0
      CALL MENU_REFILL
      JMP CHOICE_REFILL
		
   CHOICE_REFILL:
      CALL READ_KEYPAD

      CMP BL, '1'            
      JE REFILL_TABLET
      CMP BL, '2'              
      JE REFILL_CAPSULE         
      CMP BL, '3'              
      JE REFILL_SYRUP        
      
      CALL CHECK_KEY_RELEASE
      LOOP CHOICE_REFILL        

      REFILL_TABLET:
	 MOV [MEDMODE], 1
	 JMP REFILL_PROCESS		
      REFILL_CAPSULE:
	 MOV [MEDMODE], 2
	 JMP REFILL_PROCESS
      REFILL_SYRUP:
	 MOV [MEDMODE], 3
	 JMP REFILL_PROCESS

      REFILL_PROCESS:
	 CALL REFILL_PROCESS_DISPLAY

	 UPDATE_INVENTORY:
	    MOV AL, [MEDMODE]
	    CMP AL, 1
	    JE UPDATE_TABLET
	    CMP AL, 2
	    JE UPDATE_CAPSULE
	    CMP AL, 3 
	    JE UPDATE_SYRUP

	    UPDATE_TABLET:
	       CALL GET_DOSAGE
	       MOV AL, [TEMPDOSAGE]
	       MOV BL, [TABLET]
	       ADD BL, AL 
	       CMP BL, 20
	       JG INVALID_INPUT
	       JMP ADD_TABLET

	    UPDATE_CAPSULE:
	       CALL GET_DOSAGE
	       MOV AL, [TEMPDOSAGE]
	       MOV BL, [CAPSULE]
	       ADD BL, AL 
	       CMP BL, 20
	       JG INVALID_INPUT
	       JMP ADD_CAPSULE

	    UPDATE_SYRUP:
	       CALL GET_DOSAGE
	       MOV AL, [TEMPDOSAGE]
	       MOV BL, [SYRUP]
	       ADD BL, AL 
	       CMP BL, 100
	       JG INVALID_INPUT
	       JMP ADD_SYRUP

	    ADD_TABLET:	
	       ADD [TABLET], AL 
	       JMP FINISH_UPDATE
	       
	    ADD_CAPSULE:
	       ADD [CAPSULE], AL 
	       JMP FINISH_UPDATE 
	       
	    ADD_SYRUP:
	       ADD [SYRUP], AL 
	       JMP FINISH_UPDATE

   INVALID_INPUT:
      CALL INVALID_BEEP
      JMP REFILL_PROCESS
      
   FINISH_UPDATE:
      CALL DELAY_2S
      MOV AL, 0CH          
      CALL INST_CTRL 
      CALL CLEARSCREEN
      MOV AL, 80H
      CALL INST_CTRL
      MOV SI, OFFSET REFILLED_MSG
      CALL DISPLAY_STRING
      CALL DELAY_2S
      MOV [LOWLEVEL_FLAG], 0
      JMP FOREGROUND
;==================================================
;DISPENSER CODES
;================================================== 
DISPENSER1_ON:
   MOV DX, DISPENSER_PORT
   MOV AL, 09H
   OUT DX, AL 
   CALL DELAY_1S
   RET

DISPENSER2_ON:
   MOV DX, DISPENSER_PORT
   MOV AL, 12H
   OUT DX, AL 
   CALL DELAY_1S
   RET

DISPENSER3_ON:
   MOV DX, DISPENSER_PORT
   MOV AL, 24H
   OUT DX, AL 
   CALL DELAY_1S
   RET
   
DISPENSER_OFF:
   MOV DX, DISPENSER_PORT
   MOV AL, 00H
   OUT DX, AL 
   CALL DELAY_1S
   RET
;==================================================
;BUZZER CODES
;================================================== 
BUZZER_BEEP:
       MOV DX, BUZZER_PORT     
       MOV AL, 01H          
       OUT DX, AL
       CALL DELAY_1S         
       
       MOV DX, BUZZER_PORT    
       MOV AL, 00H        
       OUT DX, AL
       CALL DELAY_1S       

       MOV DX, BUZZER_PORT     
       MOV AL, 01H       
       OUT DX, AL
       CALL DELAY_1S       
       
       MOV DX, BUZZER_PORT  
       MOV AL, 00H          
       OUT DX, AL
       CALL DELAY_1S   
       
       MOV DX, BUZZER_PORT   
       MOV AL, 01H        
       OUT DX, AL
       CALL DELAY_1S    
       
       MOV DX, BUZZER_PORT   
       MOV AL, 00H       
       OUT DX, AL
       CALL DELAY_1S     
   RET
   
   INVALID_BEEP:
      MOV DX, BUZZER_PORT
      MOV AL, 01H
      OUT DX, AL 
      CALL DELAY_1MS
      MOV DX, BUZZER_PORT
      MOV AL, 00H
      OUT DX, AL 
      CALL DELAY_1MS
   RET
;==================================================
;DOT MATRIX 
;================================================== 
   MATRIX:
      MOV DX, SDM_PORT
      MOV AL, 00H
      OUT DX, AL 
      CALL DELAY_1MS
      
   ;CAPSULE===================================
   MATRIX_CAPSULE:
      XOR AX,AX
      MOV AL, [CAPSULE]

      CMP AL, 3           ; Check pills for level 1
      JBE CAPSULELEVEL1          ; If <= 3, set level 1
      CMP AL, 6           ; Check pills for level 2
      JBE CAPSULELEVEL2          ; If <= 6, set level 2
      CMP AL, 9           ; Check pills for level 3
      JBE CAPSULELEVEL3          ; If <= 9, set level 3
      CMP AL, 12          ; Check pills for level 4
      JBE CAPSULELEVEL4          ; If <= 12, set level 4
      CMP AL, 15          ; Check pills for level 5
      JBE CAPSULELEVEL5          ; If <= 15, set level 5
      CMP AL, 18          ; Check pills for level 6
      JBE CAPSULELEVEL6          ; If <= 18, set level 6

      ; Else, set full level
      MOV AL, [ROW_LEVELS + 6]
      JMP DISPLAY_TO_CAPSULE

      CAPSULELEVEL1:
	 MOV AL, [ROW_LEVELS + 0]
	 MOV [LOWLEVEL_FLAG], 1
	 JMP DISPLAY_TO_CAPSULE

      CAPSULELEVEL2:
	 MOV AL, [ROW_LEVELS + 1]
	 MOV [LOWLEVEL_FLAG], 1
	 JMP DISPLAY_TO_CAPSULE

      CAPSULELEVEL3:
	 MOV AL, [ROW_LEVELS + 2]
	 JMP DISPLAY_TO_CAPSULE

      CAPSULELEVEL4:
	 MOV AL, [ROW_LEVELS + 3]
	 JMP DISPLAY_TO_CAPSULE

      CAPSULELEVEL5:
	 MOV AL, [ROW_LEVELS + 4]
	 JMP DISPLAY_TO_CAPSULE

      CAPSULELEVEL6:
	 MOV AL, [ROW_LEVELS + 5]
	 JMP DISPLAY_TO_CAPSULE

      DISPLAY_TO_CAPSULE:
	 MOV DX, CAPSULE_PORT
	 OUT DX, AL
	 CALL DELAY_1MS
	 CMP BYTE PTR [LOWLEVEL_FLAG], 1
	 JE TO_REFILL
	 JMP MATRIX_TABLET
	 TO_REFILL:
	    CALL CLEARSCREEN
	 
   ;TABLET===================================
   MATRIX_TABLET:
      XOR AX,AX
      MOV AL, [TABLET]

      CMP AL, 3           ; Check pills for level 1
      JBE TABLETLEVEL1          ; If <= 3, set level 1
      CMP AL, 6           ; Check pills for level 2
      JBE TABLETLEVEL2          ; If <= 6, set level 2
      CMP AL, 9           ; Check pills for level 3
      JBE TABLETLEVEL3          ; If <= 9, set level 3
      CMP AL, 12          ; Check pills for level 4
      JBE TABLETLEVEL4          ; If <= 12, set level 4
      CMP AL, 15          ; Check pills for level 5
      JBE TABLETLEVEL5          ; If <= 15, set level 5
      CMP AL, 18          ; Check pills for level 6
      JBE TABLETLEVEL6          ; If <= 18, set level 6

      ; Else, set full level
      MOV AL, [ROW_LEVELS + 6]
      JMP DISPLAY_TO_TABLET

      TABLETLEVEL1:
	 MOV AL, [ROW_LEVELS + 0]
	 MOV [LOWLEVEL_FLAG], 1
	 JMP DISPLAY_TO_TABLET

      TABLETLEVEL2:
	 MOV AL, [ROW_LEVELS + 1]
	 MOV [LOWLEVEL_FLAG], 1
	 JMP DISPLAY_TO_TABLET

      TABLETLEVEL3:
	 MOV AL, [ROW_LEVELS + 2]
	 JMP DISPLAY_TO_TABLET

      TABLETLEVEL4:
	 MOV AL, [ROW_LEVELS + 3]
	 JMP DISPLAY_TO_TABLET

      TABLETLEVEL5:
	 MOV AL, [ROW_LEVELS + 4]
	 JMP DISPLAY_TO_TABLET

      TABLETLEVEL6:
	 MOV AL, [ROW_LEVELS + 5]
	 JMP DISPLAY_TO_TABLET

      DISPLAY_TO_TABLET:
	 MOV DX, TABLET_PORT
	 OUT DX, AL
	 CALL DELAY_1MS
	 CMP BYTE PTR [LOWLEVEL_FLAG], 1
	 JE TO_REFILL1
	 JMP MATRIX_SYRUP
	 TO_REFILL1:
	    CALL CLEARSCREEN

   ;SYRUP===================================
   MATRIX_SYRUP:
      XOR AX,AX
      MOV AL, [SYRUP]

      CMP AL, 14           ; Check pills for level 1
      JBE SYRUPLEVEL1          ; If <= 14, set level 1
      CMP AL, 28          ; Check pills for level 2
      JBE SYRUPLEVEL2          ; If <= 28 set level 2
      CMP AL, 42           ; Check pills for level 3
      JBE SYRUPLEVEL3          ; If <= 42 set level 3
      CMP AL, 56          ; Check pills for level 4
      JBE SYRUPLEVEL4          ; If <= 56, set level 4
      CMP AL, 70          ; Check pills for level 5
      JBE SYRUPLEVEL5          ; If <= 70, set level 5
      CMP AL, 88          ; Check pills for level 6
      JBE SYRUPLEVEL6          ; If <= 88, set level 6

      ; Else, set full level
      MOV AL, [ROW_LEVELS + 6]
      JMP DISPLAY_TO_SYRUP

      SYRUPLEVEL1:
	 MOV AL, [ROW_LEVELS + 0]
	 MOV [LOWLEVEL_FLAG], 1
	 JMP DISPLAY_TO_SYRUP

      SYRUPLEVEL2:
	 MOV AL, [ROW_LEVELS + 1]
	 MOV [LOWLEVEL_FLAG], 1
	 JMP DISPLAY_TO_SYRUP

      SYRUPLEVEL3:
	 MOV AL, [ROW_LEVELS + 2]
	 JMP DISPLAY_TO_SYRUP

      SYRUPLEVEL4:
	 MOV AL, [ROW_LEVELS + 3]
	 JMP DISPLAY_TO_SYRUP

      SYRUPLEVEL5:
	 MOV AL, [ROW_LEVELS + 4]
	 JMP DISPLAY_TO_SYRUP

      SYRUPLEVEL6:
	 MOV AL, [ROW_LEVELS + 5]
	 JMP DISPLAY_TO_SYRUP

      DISPLAY_TO_SYRUP:
	 MOV DX, SYRUP_PORT
	 OUT DX, AL
	 CALL DELAY_1MS
	 CMP BYTE PTR [LOWLEVEL_FLAG], 1
	 JE TO_REFILL2
	 JMP FINISH_MATRIX
	 TO_REFILL2:
	    CALL CLEARSCREEN

FINISH_MATRIX:
      CALL DELAY_2S
      MOV DX, SDM_PORT
      MOV AL, 0EH
      OUT DX, AL 
      CALL DELAY_2S

   RET
;==================================================
;KEYPAD CODES
;================================================== 
   SET_CURSOR_TO_9DH:
      MOV AL, 9DH
      CALL INST_CTRL
      MOV AL, 0FH
      CALL INST_CTRL
   RET

   READ_KEYPAD:
      MOV DX, KEYPAD_PORT
      IN AL, DX
      TEST AL, 10H          
      JZ READ_KEYPAD

      MOV DX, KEYPAD_PORT
      IN AL, DX
      AND AL, 0FH          
      CALL CONVERTTONUM
   RET
   
   CONVERTTONUM:
      CMP AL,1101b
      JE NUM0
      CMP AL, 0000b
      JE NUM1
      CMP AL, 0001b
      JE NUM2
      CMP AL, 0010b
      JE NUM3
      CMP AL, 0100b
      JE NUM4
      CMP AL, 0101b
      JE NUM5
      CMP AL, 0110b
      JE NUM6
      CMP AL, 1000b
      JE NUM7
      CMP AL, 1001b
      JE NUM8
      CMP AL, 1010b
      JE NUM9
      CMP AL, 1110b
      JE HASH
      CMP AL, 1100b
      JE STAR
   RET

   NUM0: 
      MOV BL, '0' 
   RET
   NUM1: 
      MOV BL, '1' 
   RET
   NUM2: 
      MOV BL, '2' 
   RET
   NUM3: 
      MOV BL, '3' 
   RET
   NUM4: 
      MOV BL, '4' 
   RET
   NUM5: 
      MOV BL, '5'
   RET
   NUM6: 
      MOV BL, '6' 
   RET
   NUM7: 
      MOV BL, '7' 
   RET
   NUM8: 
      MOV BL, '8'
   RET
   NUM9: 
      MOV BL, '9' 
   RET
   HASH: 
      MOV BL, '#' 
   RET
   STAR: 
      MOV BL, '*'
   RET
   
   CHECK_KEY_RELEASE:
      MOV DX, KEYPAD_PORT
      IN AL, DX
      TEST AL, 10H         
      JNZ CHECK_KEY_RELEASE    
   RET
;==================================================
;CONVERT TO DECIMAL
;================================================== 
   CONVERT_TO_DECIMAL:
      XOR AX, AX
      XOR BX, BX

      MOV BL, [TEMP_FIRSTDIGIT]
      SUB BL, '0'
      MOV AL, BL
      MOV CL, 10
      MUL CL

      MOV BL, [TEMP_SECONDDIGIT]
      SUB BL, '0'
      ADD AL, BL

      MOV [TEMP_DECIMALVALUE], AX
   RET	    
;==================================================
;LCD CODES
;================================================== 
   DISPLAY_DIGIT:
      MOV AL, CURSOR_POS  
      CALL INST_CTRL 
      MOV AL, BL           
      CALL DATA_CTRL
      INC CURSOR_POS       
   RET   

   DISPLAY_STRING:
      NEXT_CHAR:
      LODSB            
      CMP AL, 0        
      JE END_STRING
      CALL DATA_CTRL         
      JMP NEXT_CHAR
      END_STRING:
   RET

   INST_CTRL:
      PUSH AX             
      MOV DX, LCD_PORT1        
      OUT DX, AL            
      MOV DX, LCD_PORT2           
      MOV AL, 02H         
      OUT DX, AL         
      CALL DELAY_1MS       
      MOV DX, LCD_PORT2 
      MOV AL, 00H     
      OUT DX, AL         
      POP AX              
   RET

   DATA_CTRL:
      PUSH AX             
      MOV DX, LCD_PORT1           
      OUT DX, AL         
      MOV DX, LCD_PORT2         
      MOV AL, 03H          
      OUT DX, AL          
      CALL DELAY_1MS       
      MOV DX, LCD_PORT2 
      MOV AL, 01H         
      OUT DX, AL            
      POP AX                
   RET

   INIT_LCD:
      MOV AL, 38H          
      CALL INST_CTRL      
      MOV AL, 0CH           
      CALL INST_CTRL     
      MOV AL, 06H        
      CALL INST_CTRL       
      MOV AL, 01H          
      CALL INST_CTRL         
   RET

   CLEARSCREEN:
      MOV AL, 01H           
      CALL INST_CTRL        
   RET	
;==================================================
;DELAY CODES
;================================================== 
   DELAY_1MS:
      MOV CX, 1000          
      DELAY_LOOP_1MS:
	 LOOP DELAY_LOOP_1MS
   RET  

   DELAY_2S:
      MOV CX, 20000          
      DELAY_LOOP_2S:
	 LOOP DELAY_LOOP_2S
   RET  

   DELAY_1S:
      MOV CX, 15000          
      DELAY_LOOP_1S:
	 LOOP DELAY_LOOP_1S
   RET  
 
 SKIP:
 JMP FOREGROUND
;==================================================
;CHECKING_ALARM_ROUTINE
;==================================================     
PROCESS_ALARM PROC
    PUSH AX
    PUSH BX
    PUSH SI

    ; Check if queue is empty
    MOV SI, OFFSET ALARM_QUEUE
    ADD SI, [QUEUE_HEAD]
    MOV AX, [QUEUE_HEAD]    	; Load the value of QUEUE_HEAD into AL
    MOV BX, [QUEUE_TAIL]    		; Load the value of QUEUE_TAIL into BL
    CMP AX, BX            			 ; Compare the two values
    JE NO_ALARM           			; No alarms to process

    ; Get the alarm ID
    MOV AL, [SI]
    INC [QUEUE_HEAD]
    CMP [QUEUE_HEAD], 10
    JNE PROCESS_ALARM_ID
    MOV [QUEUE_HEAD], 0   		; Wrap around if head exceeds queue size

PROCESS_ALARM_ID:
	 CHECK_ALARM:
	    CMP AL, 01H
	    JE ALARM_TABLET_01

	    CMP AL, 02H
	    JE ALARM_CAPSULE_02

	    CMP AL, 03H
	    JE ALARM_SYRUP_03
	    
	    CMP AL, 11H
	    JE ALARM_TABLET_11

	    CMP AL, 12H
	    JE ALARM_CAPSULE_12

	    CMP AL, 13H
	    JE ALARM_SYRUP_13
	    
	    CMP AL, 21H
	    JE ALARM_TABLET_21

	    CMP AL, 22H
	    JE ALARM_CAPSULE_22

	    CMP AL, 23H
	    JE ALARM_SYRUP_23
	    
	    JMP NO_ALARM

	    ;USER 1=======================================
	    ALARM_TABLET_01:
	       CALL DELAY_2S
	       MOV [USERMODE], 1
	       MOV [MEDMODE], 1
	       CALL DISPLAY_ALARM_MESSAGE
	       CALL ASKUSERPIN
	       	      
	       JMP DONE_PROCESSING

	    ALARM_CAPSULE_02:
	       CALL DELAY_2S
	       MOV [USERMODE], 1
	       MOV [MEDMODE], 2
	       CALL DISPLAY_ALARM_MESSAGE
	       CALL ASKUSERPIN
	       	       
	       JMP DONE_PROCESSING

	    ALARM_SYRUP_03:
	       CALL DELAY_2S
	       MOV [USERMODE], 1
	       MOV [MEDMODE], 3
	       CALL DISPLAY_ALARM_MESSAGE
	       CALL ASKUSERPIN
	       	      
	       JMP DONE_PROCESSING
	    ;USER 2=========================================
	    ALARM_TABLET_11:
	       CALL DELAY_2S
	       MOV [USERMODE], 2
	       MOV [MEDMODE], 1
	       CALL DISPLAY_ALARM_MESSAGE
	       CALL ASKUSERPIN
	       	       
	       JMP DONE_PROCESSING

	    ALARM_CAPSULE_12:
	       CALL DELAY_2S
	       MOV [USERMODE], 2
	       MOV [MEDMODE], 2
	       CALL DISPLAY_ALARM_MESSAGE
	       CALL ASKUSERPIN
	       	       
	       JMP DONE_PROCESSING

	    ALARM_SYRUP_13:
	       CALL DELAY_2S
	       MOV [USERMODE], 2
	       MOV [MEDMODE], 3
	       CALL DISPLAY_ALARM_MESSAGE
	       CALL ASKUSERPIN
	  
	       JMP DONE_PROCESSING
	    ;USER 3===========================================
	    ALARM_TABLET_21:
	       CALL DELAY_2S
	       MOV [USERMODE], 3
	       MOV [MEDMODE], 1
	       CALL DISPLAY_ALARM_MESSAGE
	       CALL ASKUSERPIN

	       JMP DONE_PROCESSING

	    ALARM_CAPSULE_22:
	       CALL DELAY_2S
	       MOV [USERMODE], 3
	       MOV [MEDMODE], 2
	       CALL DISPLAY_ALARM_MESSAGE
	       CALL ASKUSERPIN

	       JMP DONE_PROCESSING

	    ALARM_SYRUP_23:
	       CALL DELAY_2S
	       CALL DELAY_2S
	       MOV [USERMODE], 3
	       MOV [MEDMODE], 3
	       CALL DISPLAY_ALARM_MESSAGE
	       CALL ASKUSERPIN

	       JMP DONE_PROCESSING
	    
   NO_ALARM:
       ; No alarms to process
       JMP DONE_PROCESSING

   DONE_PROCESSING:
       POP SI
       POP BX
       POP AX
       RET
PROCESS_ALARM ENDP

 CODE ENDS
 END START 
 
 