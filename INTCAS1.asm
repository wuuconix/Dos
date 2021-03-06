SSTACK SEGMENT STACK
DW 32 DUP(?)
SSTACK ENDS

CODE SEGMENT
	ASSUME CS:CODE
START: 
	PUSH DS
	MOV AX, 0000H
	MOV DS, AX
	MOV AX, OFFSET MIR7 ;取中断入口地址
	MOV SI, 003CH ;中断矢量地址
	MOV [SI], AX ;填 IRQ7 的偏移矢量
	MOV AX, CS ;段地址


	MOV SI, 003EH
	MOV [SI], AX ;填 IRQ7 的段地址矢量
	MOV AX, OFFSET SIR1
	MOV SI, 00C4H
	MOV [SI], AX
	MOV AX, CS
	MOV SI, 00C6H
	MOV [SI], AX
	CLI
	POP DS
	;初始化主片 8259
	MOV AL, 11H ;00010001, D3为0表示边沿触发
	OUT 20H, AL ;ICW1
	MOV AL, 08H ;00001000, 表示中断向量地址高5位为00001
	OUT 21H, AL ;ICW2
	MOV AL, 04H ;00000100, D2为1 表示IR2连接从片
	OUT 21H, AL ;ICW3
	MOV AL, 01H ;00000001, D4为0 表示采用全嵌套方式  D2为0 表示禁用自动中断结束
	OUT 21H, AL ;ICW4
	;初始化从片 8259
	MOV AL, 11H ;00010001, D3为0表示边沿触发
	OUT 0A0H, AL ;ICW1
	MOV AL, 30H ;00110000 表示中断向量地址高5位为00110
	OUT 0A1H, AL ;ICW2
	MOV AL, 02H ;00000010 固定格式
	OUT 0A1H, AL ;ICW3
	MOV AL, 01H ;00000001  D4为0 表示采用全嵌套方式  D2为0 表示禁用自动中断结束
	OUT 0A1H, AL ;ICW4 

	MOV AL, 0FDH ;11111101 表示接收SIR1上的请求
	OUT 0A1H,AL ;从 OCW1 = 1111 1101
	MOV AL, 6BH ;01101011 表示接收IR2和IR4的请求
	OUT 21H, AL ;主 8259 OCW1
	STI
	AA1: 
		MOV AX, 0172H ;r
		INT 10H 
		MOV AX, 0175H ;u
		INT 10H 
		MOV AX, 016eH ;n
		INT 10H 
		MOV AX, 010AH ;\r
		INT 10H
		MOV AX, 010DH ;\n
		INT 10H  
		MOV CX, 20
		S:
			CALL DELAY
			LOOP S
		JMP AA1
	MIR7:
		CALL DELAY
		MOV AX, 014DH ;M
		INT 10H 
		MOV AX, 010DH ;\r
		INT 10H 
		MOV AX, 010AH ;\n
		INT 10H 
		MOV AL, 20H ;向8259发送EOI的固定格式
		OUT 20H, AL ;中断结束命令
		IRET
	SIR1: 
		CALL DELAY
		MOV AX, 0153H ;S
		INT 10H 
		MOV AX, 010DH ;\r
		INT 10H 
		MOV AX, 010AH ;\n
		INT 10H 
		MOV AL, 20H
		OUT 0A0H, AL ;向8259发送EOI的固定格式
		OUT 20H, AL ;中断结束命令
		IRET
	DELAY: 
		PUSH CX
		MOV CX, 0F00H
		AA0: 
			PUSH AX
			POP AX
			LOOP AA0
		POP CX
		RET
CODE ENDS
END START