.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER X: $'
    MSG2 DB CR,LF,'ENTER Y: $' 
    MSG3 DB CR,LF,'Z = X-2Y = $'
    MSG4 DB CR,LF,'Z = 25-(X+Y) = $'
    MSG5 DB CR,LF,'Z = 2X-3Y = $'
    MSG6 DB CR,LF,'Z = Y-X+1 = $'
    Z DW ? 
    COMP DW ?

.CODE

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX 
    
    ;INPUT X
    
    MOV AH,9
    LEA DX,MSG1
    INT 21H
    
    MOV AH,1
    INT 21H 
    
    MOV BX,AX
    SUB BL,30H  
     
    ;INPUT Y
    
    MOV AH,9
    LEA DX,MSG2
    INT 21H
    
    MOV AH,1
    INT 21H 
     
    MOV CX,AX
    SUB CX,30H
    
    ;Z=X-2Y
    
    MOV Z,BX
    SUB Z,CX
    SUB Z,CX 
    ADD Z,30H
   
    
    MOV AH,9
    LEA DX,MSG3
    INT 21H
    
    MOV AH,2
    MOV DX,Z
    INT 21H 
    
    ;Z=25-(X+Y)
    
    MOV Z,19H
    SUB Z,BX
    SUB Z,CX 
    ADD Z,30H
   
    
    MOV AH,9
    LEA DX,MSG4
    INT 21H
    
    MOV AH,2
    MOV DX,Z
    INT 21H 
    
    ;Z=2X-3Y
    
    MOV Z,BX
    ADD Z,BX
    SUB Z,CX
    SUB Z,CX
    SUB Z,CX 
    ADD Z,30H
   
    
    MOV AH,9
    LEA DX,MSG5
    INT 21H
    
    MOV AH,2
    MOV DX,Z
    INT 21H 
    
    ;Z=Y-X+1
    
    MOV Z,CX
    SUB Z,BX
    ADD Z,1H 
    ADD Z,30H
   
    
    MOV AH,9
    LEA DX,MSG6
    INT 21H
    
    MOV AH,2
    MOV DX,Z
    INT 21H
    
    MOV AH,4CH
    INT 21H
    
MAIN ENDP

    END MAIN   