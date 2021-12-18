SSTACK  SEGMENT STACK ; 编码测试
        DW 32 DUP(?)
SSTACK  ENDS
CODE    SEGMENT
        ASSUME CS:CODE
START:  MOV DX, 0646H
        MOV AL, 80H ;10000000 设置A口为方式0的输出，B口为方式0的输出
        OUT DX, AL
        MOV BX, 0AA55H ;10100101 设置流水灯的初始灯效 
AA1:    MOV DX, 0640H
        MOV AL, BH
        OUT DX, AL
        ROL BH, 1 ;左移1
        MOV DX, 0642H
        MOV AL, BL
        OUT DX, AL
        ROR BL, 1 ;右移1
        CALL DELAY
        CALL DELAY
        JMP AA1
DELAY:  PUSH CX
        MOV CX, 0F000H
AA2:    PUSH AX
        POP  AX
        LOOP AA2
        POP  CX
        RET
CODE    ENDS
        END  START