.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER 1ST NUMBER: $'
    MSG2 DB CR,LF,'ENTER 2ND NUMBER: $'
    MSG3 DB CR,LF,'ENTER THE OPERATOR: $' 
    MSG4 DB CR,LF,'WRONG OPERATOR $'
    MSG5 DB CR,LF,'OUTPUT: $'
    MSG6 DB CR,LF,'REMINDER: $'
    VAL  DW ? 
    SUM  DW 0 
    INT1 DW ?
    INT2 DW ?
    REMINDER DW ?
    TEMP_SIGN DB ?
    SIGN_1  DB 0
    SIGN_2  DB 0  
    SIGN DB 0 
    ANS_SIGN DB 0
    REMINDER_SIGN DB 0
    COUNT DB ?

.CODE

MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX
    
    ;1ST INPUT
    
1ST_INPUT:
    
    MOV AH,9
    LEA DX,MSG1
    INT 21H 
    
    CALL NUMBER_INPUT
    MOV CX,SUM 
    MOV INT1,CX
    MOV CL,TEMP_SIGN
    MOV SIGN_1,CL     
    
               
    CMP SIGN_1,2DH
    JE NEGATION_1
    JMP OPERATOR
    
NEGATION_1:
    
    NEG INT1
    JMP OPERATOR           
    
    
    
    ;OPERATOR 
      
OPERATOR:
    
    MOV AH,9
    LEA DX,MSG3
    INT 21H   
    
    MOV AH,1
    INT 21H
    
    MOV SIGN,AL 
    
    CMP AL,2BH
    JE  SECOND_PART
    
    CMP AL,2AH
    JE  SECOND_PART
    
    CMP AL,2DH
    JE  SECOND_PART
    
    CMP AL,2FH
    JE  SECOND_PART
    
    CMP AL,71H
    JNE WRONG_OPERATOR  
    
    
    JMP EXIT
    
    
SECOND_PART:
    
    ;2ND INPUT 
      
    MOV AH,9
    LEA DX,MSG2
    INT 21H         
    
    CALL NUMBER_INPUT 
    MOV CX,SUM 
    MOV INT2,CX
    MOV CL,TEMP_SIGN
    MOV SIGN_2,CL 
    
    CMP SIGN_2,2DH
    JE NEGATION_2
    JMP FIND
    
NEGATION_2:
    
    NEG INT2
    JMP FIND
     
    
FIND:     
    
    CALL CALCULATION
    
    
    MOV AH,9
    LEA DX,MSG5
    INT 21H 
    
    CMP ANS_SIGN,0
    JE PRINT_SIGN 
    
    JMP PRINT_NUMBER
   
PRINT_SIGN: 
    MOV AH,2
    MOV DL,ANS_SIGN
    INT 21H 
    JMP PRINT_NUMBER
    
    
PRINT_NUMBER:
    MOV AX,INT1
    CALL NUMBER_PRINT 
    
    CMP SIGN,2FH
    JE PRINT_REMINDER
     
    
    JMP EXIT

PRINT_REMINDER:

    MOV AH,9
    LEA DX,MSG6
    INT 21H 
    
    MOV AX,REMINDER
    CALL NUMBER_PRINT 
    
    JMP EXIT


WRONG_OPERATOR:
    MOV AH,9
    LEA DX,MSG4
    INT 21H 
    
    JMP EXIT
    
 
EXIT:        
    MOV AH,4CH
    INT 21H
    
MAIN ENDP 
    
    


NUMBER_INPUT PROC
       
    MOV SUM,0 
    MOV TEMP_SIGN,0 
    
    MOV AH,1
    INT 21H
    
    CMP AL,2DH
    JE SIGN_SET
    JMP MAIN_LOOP
    
SIGN_SET:
    
    MOV TEMP_SIGN,AL
    JMP REPEAT
    
    
REPEAT:
    MOV AH,1
    INT 21H 
    
    JMP MAIN_LOOP


MAIN_LOOP:    
    CMP AL,0DH
    JE END 
    
    CMP AL,30H
    JL REPEAT
    
    CMP AL,39H
    JG REPEAT
    
    MOV B.VAL,AL
    SUB VAL,30H
    
    MOV AX,SUM
    MOV BX,0AH
    MUL BX
    
    ADD AX,VAL
    
    MOV SUM,AX 
    
    
    JMP REPEAT  
END:
    RET

NUMBER_INPUT ENDP 
    
  
  
  
CALCULATION PROC 
    
    CMP SIGN,2BH
    JE ADD_FUNC 
    
    CMP SIGN,2DH
    JE SUB_FUNC 
    
    CMP SIGN,2AH
    JE MUL_FUNC
    
    CMP SIGN,2FH
    JE DIV_FUNC
    
ADD_FUNC:
    MOV CX,INT1
    ADD CX,INT2
    MOV INT1,CX 
    
    CMP INT1,0
    JL  NEGATION
    
    JMP END2
    

SUB_FUNC:
    MOV CX,INT1
    SUB CX,INT2
    MOV INT1,CX 
    
    CMP INT1,0
    JL  NEGATION
    
    JMP END2 
    
MUL_FUNC:
    MOV AX,INT1
    MOV BX,INT2
    IMUL BX
    
    MOV INT1,AX
    
    CMP INT1,0
    JL  NEGATION
    
    JMP END2 
    
DIV_FUNC:
    MOV AX,INT1 
    CWD
    MOV BX,INT2
    IDIV BX
    
    MOV INT1,AX 
    MOV REMINDER,DX
        
    CMP INT1,0
    JL  NEGATION
    
    JMP REMINDER_CALC 
    
    
REMINDER_CALC:    
    CMP REMINDER,0
    JL  REMINDER_NEG 
    
    JMP END2 
    
REMINDER_NEG:
    NEG REMINDER 
    MOV REMINDER_SIGN,2DH
    
    JMP END2
    
NEGATION:
    NEG INT1
    MOV ANS_SIGN,2DH
    
    JMP REMINDER_CALC  
    
END2:
    RET
        
CALCULATION  ENDP
   
    


NUMBER_PRINT PROC 
    
    MOV COUNT,0
    
REPEAT1:

    MOV DX,0
    
    CMP AX,0
    JE PRINT 
    
    MOV BX,0AH
    DIV BX
    
    PUSH DX 
    
    INC COUNT
    
   
    JMP REPEAT1


PRINT:
    
    CMP COUNT,0
    JE END1
    
    POP DX
    
    ADD DX,30H
    
    MOV AH,2
    INT 21H
    
    DEC COUNT 
    
    JMP PRINT
        
    
END1:
    RET    
                   
NUMBER_PRINT ENDP  


    END MAIN
    