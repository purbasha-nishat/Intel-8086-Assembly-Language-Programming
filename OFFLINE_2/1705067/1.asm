.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER THREE NUMBERS: $'
    MSG2 DB CR,LF,'ALL THE NUMBERS ARE EQUAL. $'
    MSG3 DB CR,LF,'THE 2ND HIGHEST NUMBER IS: $' 
    COMP DB ?

.CODE

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    MOV AH,9
    LEA DX,MSG1
    INT 21H
    
    ;1ST NUMBER
    
    MOV AH,1
    INT 21H
    
    MOV BL,AL 
    
    ;COMMA
    
    MOV AH,1
    INT 21H
    
    ;2ND NUMBER
    
    MOV AH,1
    INT 21H
    
    MOV CL,AL
    
    ;COMMA
               
    MOV AH,1
    INT 21H
    
    ;3RD NUMBER
    
    MOV AH,1
    INT 21H
    
    CMP AL,BL
    JL  LESS1
    JE  EQUAL1
    JG  GREATER1 
    
LESS1:  
    CMP AL,CL
    JL  LESS2
    JE  EQUAL2
    JG  GREATER2
    
EQUAL1: 
    CMP AL,CL
    JL  LESS3
    JE  EQUAL3
    JG  GREATER3

GREATER1:
    CMP BL,CL
    JL  LESS4
    JE  EQUAL4
    JG  GREATER4

LESS2:
    CMP BL,CL
    JL  LESS5
    JE  EQUAL5
    JG  GREATER5

EQUAL2:
    MOV COMP,AL

    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW
            
GREATER2: 
    MOV COMP,AL

    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW

LESS3:
    MOV COMP,AL
 
    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW

EQUAL3: 
    MOV AH,9 
    LEA DX,MSG2
    JMP SHOW

GREATER3: 
    MOV COMP,CL

    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW

LESS4:
    CMP AL,CL
    JL  LESS6
    JE  EQUAL6
    JG  GREATER6

EQUAL4:
    MOV COMP,BL
 
    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW

GREATER4:    
    MOV COMP,BL

    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW

LESS5:
    MOV COMP,BL
  
    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW   

EQUAL5:   
    MOV COMP,AL

    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW

GREATER5:
    MOV COMP,CL
 
    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW

LESS6:  
    MOV COMP,AL

    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW
    
EQUAL6: 
    MOV COMP,BL

    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW

GREATER6:
    MOV COMP,CL

    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2 
    MOV DL,COMP
    JMP SHOW 
    
SHOW:
    INT 21H
    
    
    MOV AH,4CH
    INT 21H
    
MAIN ENDP

    END MAIN
    