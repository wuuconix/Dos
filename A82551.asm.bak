SSTACK  SEGMENT STACK
        DW 32 DUP(?)
SSTACK  ENDS
CODE    SEGMENT
        ASSUME CS:CODE
START:  MOV DX, 0606H ;0646H->0606H
        MOV AL, 90H ;10010000 D7为0标志着它是方式选择控制字，D6D5为零，表示A口为方式0，D4为1表示输入，D2为0表示B口为方式0，D1为0表示B口为输出
        OUT DX, AL
AA1:    MOV DX, 0600H ;CPU通过8255读入开关信号
        IN  AL, DX
      	ROR AL, 4 ;将开关对应的信号右移4
        CALL DELAY
        MOV DX, 0602H ;CPU通过8255向LED显示单元发送数据
        OUT DX, AL
        JMP AA1 ;循环
DELAY:  PUSH CX
        MOV CX, 0F00H
AA2:    PUSH AX
        POP  AX
        LOOP AA2
        POP  CX
        RET
CODE    ENDS
        END  START