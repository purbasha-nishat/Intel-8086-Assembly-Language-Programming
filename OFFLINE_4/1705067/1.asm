.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER 4 NUMBERS OF 1ST MATRIX : $'
    MSG2 DB CR,LF,'ENTER 4 NUMBERS OF 2ND MATRIX : $' 
    MSG3 DB CR,LF,'OUTPUT: $'
    LINE DB CR,LF,'$'
    SPACE DB 20H
    ARRAY1 DB 2 DUP(?)
           DB 2 DUP(?)
    COUNT DB ? 
    REMINDER DB ?
    ANSWER DB ?

.CODE

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    ;1ST NUMBER INPUT
    
    
    XOR BX,BX
    XOR SI,SI 
    
    MOV COUNT,0
    
    MOV AH,9
    LEA DX,MSG1
    INT 21H
    
    MOV AH,9
    LEA DX,LINE 
    INT 21H 

REPEAT1: 
    CMP COUNT,2H
    JE INTERMEDIATE1 
       
    MOV AH,1
    INT 21H    
    
    SUB AL,30H
    
    MOV ARRAY1[BX][SI],AL
    INC SI
    
    INC COUNT
    
    MOV AH,2
    MOV DL,SPACE
    INT 21H 
     
    JMP REPEAT1
    
INTERMEDIATE1:
    XOR SI,SI 
    ADD BX,2
    
    MOV AH,9
    LEA DX,LINE 
    INT 21H 
    
    JMP REPEAT2

REPEAT2: 
    CMP COUNT,4H
    JE SECOND
    
    MOV AH,1
    INT 21H 
    
    SUB AL,30H
    
    MOV ARRAY1[BX][SI],AL
    INC SI 
    
    INC COUNT
    
    MOV AH,2
    MOV DL,SPACE
    INT 21H
    
    JMP REPEAT2  
    
    ;2ND NUMBER INPUT + ADD
    
SECOND:    
    XOR BX,BX
    XOR SI,SI 
    
    MOV COUNT,0H
    
    MOV AH,9
    LEA DX,MSG2
    INT 21H
    
    MOV AH,9
    LEA DX,LINE 
    INT 21H 

REPEAT3: 
    CMP COUNT,2H
    JE INTERMEDIATE2 
       
    MOV AH,1
    INT 21H 
    
    SUB AL,30H
    
    ADD ARRAY1[BX][SI],AL
    INC SI  
    
    INC COUNT  
    
    MOV AH,2
    MOV DL,SPACE
    INT 21H
     
    JMP REPEAT3
    
INTERMEDIATE2:
    XOR SI,SI 
    ADD BX,2
    
    MOV AH,9
    LEA DX,LINE 
    INT 21H  
    
    JMP REPEAT4
    
REPEAT4:
    CMP COUNT,4H
    JE OUTPUT
    
    MOV AH,1
    INT 21H  
    
    SUB AL,30H
    
    ADD ARRAY1[BX][SI],AL
    INC SI  
    
    INC COUNT 
    
    MOV AH,2
    MOV DL,SPACE
    INT 21H
    
    JMP REPEAT4
    
    
    
     
    
OUTPUT:    
    
    ;OUTPUT MATRIX
    
    XOR BX,BX
    XOR SI,SI 
    
    MOV COUNT,0H
    
    MOV AH,9
    LEA DX,MSG3
    INT 21H  
    
    MOV AH,9
    LEA DX,LINE
    INT 21H

REPEAT5: 
    CMP COUNT,2H
    JE INTERMEDIATE3
    
    MOV AH,2 
    MOV DL,SPACE
    INT 21H
    
    MOV AH,0
    
    MOV AL,ARRAY1[BX][SI]
    MOV CL,0AH
    DIV CL
    INC SI
    
    MOV REMINDER,AH
    MOV ANSWER,AL 
    
    
    CMP ANSWER,0
    JE PRINT_REMINDER 
    
    ADD ANSWER,30H
    MOV AH,2 
    MOV DL,ANSWER
    INT 21H
    
PRINT_REMINDER:
    ADD REMINDER,30H   
    MOV AH,2 
    MOV DL,REMINDER
    INT 21H  
    
    INC COUNT
     
    JMP REPEAT5
    
INTERMEDIATE3:
    XOR SI,SI 
    ADD BX,2  
    
    MOV AH,9
    LEA DX,LINE 
    INT 21H
    
    JMP REPEAT6
    
REPEAT6: 
     
    
    CMP COUNT,4H
    JE END
    
    MOV AH,2 
    MOV DL,SPACE
    INT 21H
    
    MOV AH,0
    
    MOV AL,ARRAY1[BX][SI]
    MOV CL,0AH
    DIV CL
    INC SI
    
    MOV REMINDER,AH
    MOV ANSWER,AL
    
    CMP ANSWER,0
    JE PRINT_REMINDER1 
    
    ADD ANSWER,30H
    MOV AH,2 
    MOV DL,ANSWER
    INT 21H
    
PRINT_REMINDER1:
    ADD REMINDER,30H   
    MOV AH,2 
    MOV DL,REMINDER
    INT 21H
             
    INC COUNT
    
    LOOP REPEAT6 
    
    
END:    
    MOV AH,4CH
    INT 21H 
    
MAIN ENDP 


    END MAIN   