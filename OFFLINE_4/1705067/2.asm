.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER N : $'
    MSG2 DB CR,LF,'FIBONACCI SEIRES UPTO NTH ELEMENT: $'
    COUNT DW 0
    COUNT1 DW 0 
    SUM DW 0
    VAL DW ?

.CODE

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX 
    
    MOV AH,9
    LEA DX,MSG1
    INT 21H 
    CALL NUMBER_INPUT 
              
    MOV AH,9
    LEA DX,MSG2
    INT 21H       
    
    
    MOV DX,SUM 
REPEAT2:

    CMP COUNT,0
    JE LOOP1   
    
    CMP COUNT,DX
    JE ENDCODE 
    
    MOV AH,2
    MOV DL,2CH
    INT 21H  
    
    JMP LOOP1

LOOP1:    
       
    MOV AX,COUNT
    PUSH AX
    
    CALL FIBONACCI
    
    CALL NUMBER_PRINT
    
    INC COUNT  
    
    MOV DX,SUM
     
    JMP REPEAT2


ENDCODE:       
    MOV AH,4CH
    INT 21H 
    
MAIN ENDP 


FIBONACCI PROC
    
    PUSH BP
    MOV BP,SP
    MOV AX,[BP+4]
    
;BASE CASES 

    CMP AX,1H
    JLE BASE 
    
;COMPUTE FIB(N-1)

    MOV CX,[BP+4]
    SUB CX,1
    PUSH CX
    CALL FIBONACCI 
    PUSH AX
    
;COMPUTE FIB(N-2) 

    MOV CX,[BP+4]
    SUB CX,2
    PUSH CX
    CALL FIBONACCI

;COMPUTE FIB(N)

    POP BX
    ADD AX,BX    
    
BASE:
    POP BP 
    RET 2
       
    
FIBONACCI ENDP 


NUMBER_INPUT PROC
       
    MOV SUM,0 
   
REPEAT:
    MOV AH,1
    INT 21H 
        
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


NUMBER_PRINT PROC 
    
    MOV COUNT1,0
    
REPEAT1:

    MOV DX,0
    
    CMP AX,0
    JE ZERO_CHECK 
    
    MOV BX,0AH
    DIV BX
    
    PUSH DX 
    
    INC COUNT1
    
   
    JMP REPEAT1

ZERO_CHECK:
    CMP COUNT1,0
    JE ZERO_PRINT 
    
    JMP PRINT

PRINT:
    
    CMP COUNT1,0
    JE END1
    
    POP DX
    
    ADD DX,30H
    
    MOV AH,2
    INT 21H
    
    DEC COUNT1 
    
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