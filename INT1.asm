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
	CLI
	POP DS
	;初始化主片 8259
	MOV AL, 11H ;00010001,D7~D5无意义，设置为0，D4为标志位，1,D3为0表示上升沿触发，D2无意义，设置0，D1为0直接为0（指导书和书不一样，书上说0表示级联），D0为1表示需要ICW4
	OUT 20H, AL ;ICW1
	MOV AL, 08H ;00001000,D7~D3由程序设定，表示中断类型码的高5位内容，D2~D0按照中断请求的编码值自动填入，比如IR7就会填入111
	OUT 21H, AL ;ICW2
	MOV AL, 04H ;00000100, 每位表示IRx上有无从片8259A，如果是1表示则有，0则无，这里表示IR2连接从片
	OUT 21H, AL ;ICW3
	MOV AL, 01H	;00000001, D7~D5一定为0，D4为零，表示采用正常的完全嵌套方式，D3为0表示采用非缓冲方式，D2为0一定为0（指导书和书上不一样），D1为0表示采用正常中断结束。D0为1表示CPU为8686/8688
	OUT 21H, AL ;ICW4
	MOV AL, 6FH ;01101111，0表示允许IRx上的请求，1表示屏蔽IRx上的请求，这里表示允许IR4和IR7的请求，实验中IR4接串口0，IR7接MIR7，即我们的KK1+脉冲
	OUT 21H, AL ;OCW1
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
		
		MOV CX, 20 ;简单设置一个loop循环，循环调用DELAY，使得输出间隔一段时间
	S:
		CALL DELAY
		LOOP S
		
	JMP AA1
	MIR7: 
		STI
		CALL DELAY
		MOV AX, 0149H ;I
		INT 10H 
		MOV AX, 014EH ;N
		INT 10H 
		MOV AX, 0154H ;T
		INT 10H 
		MOV AX, 0131H ;1
		INT 10H
		MOV AX, 010DH ;\r
		INT 10H 
		MOV AX, 010AH ;\n
		INT 10H 
		MOV AL, 20H ;向8259发送EOI的固定格式
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