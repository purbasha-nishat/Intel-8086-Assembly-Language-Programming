.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER 1ST NUMBER: $'
    MSG2 DB CR,LF,'ENTER 2ND NUMBER: $'
    MSG3 DB CR,LF,'ENTER THE OPERATOR: $' 
    MSG4 DB CR,LF,'WRONG OPERATOR $'
    MSG5 DB CR,LF,'[$'
    MSG6 DB '[$'
    MSG7 DB ']$'
    MSG8 DB ' $'
    VAL  DW ? 
    SUM  DW 0 
    INT1 DW ?
    INT2 DW ? 
    INT1_F DW ?
    INT2_F DW ?
    OUT1 DW ?
    TEMP_SIGN DB ?
    SIGN_1  DB 0
    SIGN_2  DB 0  
    SIGN DB 0 
    ANS_SIGN DB 0
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
    MOV INT1_F,CX 
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
    MOV INT2_F,CX  
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
    
    ;PRINT EVERYTHING
    
    ;INPUT 1
            
    MOV AH,9
    LEA DX,MSG5
    INT 21H 
    
    MOV CL,SIGN_1
    MOV TEMP_SIGN,CL
    
    MOV AX,INT1_F  
    CALL NUMBER_PRINT
    
    MOV AH,9
    LEA DX,MSG7
    INT 21H
    
    ;OPERATOR
    
    MOV AH,9
    LEA DX,MSG6
    INT 21H
    
    MOV AH,2
    MOV DL,SIGN
    INT 21H
    
    MOV AH,9
    LEA DX,MSG7
    INT 21H
    
    ;INPUT 2
           
    MOV AH,9
    LEA DX,MSG6
    INT 21H 
    
    MOV CL,SIGN_2
    MOV TEMP_SIGN,CL
    MOV AX,INT2_F 
    CALL NUMBER_PRINT
    
    MOV AH,9
    LEA DX,MSG7
    INT 21H
    
    ;BLANK
    
    MOV AH,9
    LEA DX,MSG8
    INT 21H
    
    ;EQUAL
    
    MOV AH,2
    MOV DL,3DH
    INT 21H
    
    ;BLANK
    
    MOV AH,9
    LEA DX,MSG8
    INT 21H
    
    ;OUTPUT
    
    MOV AH,9
    LEA DX,MSG6
    INT 21H 
    
    MOV CL,ANS_SIGN
    MOV TEMP_SIGN,CL 
    MOV AX,OUT1 
    CALL NUMBER_PRINT
    
    MOV AH,9
    LEA DX,MSG7
    INT 21H
    
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
    MOV OUT1,CX 
    
    CMP OUT1,0
    JL  NEGATION
    
    JMP END2
    

SUB_FUNC:
    MOV CX,INT1
    SUB CX,INT2
    MOV OUT1,CX 
    
    CMP OUT1,0
    JL  NEGATION
    
    JMP END2 
    
MUL_FUNC:
    MOV AX,INT1
    MOV BX,INT2
    IMUL BX
    
    MOV OUT1,AX
    
    CMP OUT1,0
    JL  NEGATION
    
    JMP END2 
    
DIV_FUNC:
    MOV AX,INT1 
    CWD
    MOV BX,INT2
    IDIV BX
    
    MOV OUT1,AX 
        
    CMP OUT1,0
    JL  NEGATION
    
    JMP END2
    
NEGATION:
    NEG OUT1
    MOV ANS_SIGN,2DH
    
    JMP END2 
    
END2:
    RET
        
CALCULATION  ENDP
   
    


NUMBER_PRINT PROC 
    
    MOV COUNT,0
    
REPEAT1:

    MOV DX,0
    
    CMP AX,0
    JE ZERO_CHECK 
    
    MOV BX,0AH
    DIV BX
    
    PUSH DX 
    
    INC COUNT
    
   
    JMP REPEAT1

ZERO_CHECK:
    CMP COUNT,0
    JE ZERO_PRINT 
    
    JMP SIGN_CHECK

SIGN_CHECK:
    CMP TEMP_SIGN,2DH
    JE SIGN_PRINT
    
    JMP PRINT
    

SIGN_PRINT:
    MOV AH,2
    MOV DL,TEMP_SIGN
    INT 21H 
    
    JMP PRINT

PRINT:
    
    CMP COUNT,0
    JE END1
    
    POP DX
    
    ADD DX,30H
    
    MOV AH,2
    INT 21H
    
    DEC COUNT 
    
    JMP PRINT
    
ZERO_PRINT:
    MOV AH,2
    MOV DL,30H
    INT 21H 
    JMP END1
    
END1:
    RET    
                   
NUMBER_PRINT ENDP  


    END MAIN
    