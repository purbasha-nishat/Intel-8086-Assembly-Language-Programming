.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER YOUR PASSWORD: $'
    MSG2 DB CR,LF,'VALID PASSWORD. $'
    MSG3 DB CR,LF,'INVALID PASSWORD. $' 
    U DB ?
    L DB ?
    N DB ?
    P DB ?

.CODE

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    
    MOV AH,9
    LEA DX,MSG1
    INT 21H
    

REPEAT: 
    MOV AH,1
    INT 21H
    ;MOV P,AL
    
    CMP     AL,21H
    JNGE    CHECK
    CMP     AL,7EH
    JNLE    CHECK 
    
    MOV P,AL
    JMP UPPERCASE
    
UPPERCASE:
    CMP P,41H
    JL  NUMBER
    CMP P,5AH
    JG  LOWERCASE
    
    MOV U,1
    JMP REPEAT
   
NUMBER:
    CMP P,30H
    JL  REPEAT
    CMP P,39H
    JG  REPEAT
    
    MOV N,1
    JMP REPEAT
    
LOWERCASE:
    CMP P,61H
    JL  REPEAT
    CMP P,7AH
    JG  REPEAT
    
    MOV L,1
    JMP REPEAT
    
CHECK:
    CMP U,1
    JNE INVALID
    CMP N,1
    JNE INVALID
    CMP L,1
    JNE INVALID
    
    MOV AH,9
    LEA DX,MSG2
    INT 21H
    JMP EXIT
    
INVALID:
    MOV AH,9
    LEA DX,MSG3
    INT 21H
    JMP EXIT

EXIT:    
    MOV AH,4CH
    INT 21H
    
MAIN ENDP

    END MAIN
    