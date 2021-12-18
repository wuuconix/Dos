	.model small
DATA   SEGMENT                               
    	inputStrMsg  DB  "please input a string: ",'$' 	;提示输入一个字符串
    	inputNumMsg DB "input a number in  -8 to 8: ",13,10,"$"     ;提示输入一个数字
   	showCodeStrMsg  DB  "your input is: ",'$'	;提示输出的字符串
	RepeatInputMsg DB "input is erro ,exit !"	;提示重新输入
	encodeMsg  DB   "You chose encryption,after encode:    ",'$'	   ;提示加密后
	deCodeMsg  DB  "You chose decryption,after deconde:    ",'$'  ;提示解密后
 	num  DB    '0'	  ;定义用于存储输入的数字加密或解密偏移量
	NumBuffer DB  20	 ;预定义4字节的空间用于存储输入的凯撒解密期待偏移量
       	DB  ?		;待输入完成后，自动获得输入的字符个数
       	DB  20  DUP(0) 	;初始化全为0
BUFFER 	DB  20	 ;预定义20字节的空间
       	DB  ?		;待输入完成后，自动获得输入的字符个数
       	DB  20  DUP(0)          
CRLF   	DB  0AH, 0DH,'$'             
 	codeStr   DB  20 DUP('$')    ;20字节的空间,加密后的字符串
DATA   ENDS                                  
CODE   SEGMENT                              
	ASSUME CS:CODE, DS:DATA    	;建立段bai寄存器和段名之间关系
START:     					   
        	MOV AX, DATA      	 ;初始化数据
        	MOV DS, AX             
        	CALL  InputCodeStr     	;调用输入需要加密内容的代码块进行输入
        	CALL   inputNum		;调用输入加密或解密偏移量的代码块进行输入
        	LEA DX, CRLF            ;回车换行，另取一行                  
        	MOV AH, 09H							 
        	INT 21H  
;判断输入的数字是否是两位，大于零时是一位数，是负数是两位数，如果不符合直接结束程序
       	LEA SI,NumBuffer+1	
       	MOV AL,[SI]
       	CMP AL,0
       	JBE  Jump1
       	CMP AL,2
       	JA   Jump1
       	;结束判断输入的数字是否合法
       	LEA SI , NumBuffer +2							
       	MOV  AL , [SI ]		;获取 符号用于判读表示是否是负数
       	CMP  AL,'-'
    	JE Jump2  	;相等，是负数
    	CMP AL,'-'
  	JNE Jump3	;不相等，不是负数，表示大于或等于0
 	JMP   exit
Jump1:
	JMP erroInput
;输入字符串
InputCodeStr:      
        	LEA DX, inputStrMsg           ;打印提示输入信息    
        	MOV AH, 09H							 
        	INT 21H
        	LEA DX,BUFFER     ;接收字符串
        	MOV AH, 0AH	;调用dos系统中断函数进行输入
        	INT 21H
        	MOV AL, BUFFER+1      ;对字符串进行处理
        	ADD AL, 2
        	MOV AH, 0
        	MOV SI, AX
        	MOV BUFFER[SI], '$'	;给字符串末尾添加一个'$'结束符号
        	LEA DX, CRLF       ;另取一行                   
        	MOV AH, 09H							 
        	INT 21H
        	RET	;结束输入字符串

;输入数字作为凯撒加密器的偏移量
 inputNum:
      	LEA DX, inputNumMsg       ;打印提示输入信息    
        	MOV AH, 09H							 
        	INT 21H
        	LEA DX,NumBuffer     ;接收字符串
        	MOV AH, 0AH	  ;调用dos系统中断函数进行输入
        	INT 21H
        	MOV  AL, NumBuffer+1        ;对字符串进行处理
        	ADD AL, 2
        	MOV AH, 0
        	MOV SI, AX
        	MOV NumBuffer[SI], '$'	;给字符串末尾添加一个'$'结束符号
        	RET       ;结束输入数字作为凯撒加密器的偏移量	
Jump2:
	JMP NegativeNumber
Jump3:
	JMP PositiveNumber
 ;输入的整数为负数的情况
  NegativeNumber:
    	LEA DX, CRLF          	   ;另取一行                   
    	MOV AH, 09H						
    	INT  21h
    	LEA DX,deCodeMsg		;打印提示信息
    	MOV AH,09h
    	INT  21h
     	LEA DX, CRLF        	 ;回车换行           
    	MOV AH, 09H				
    	INT 21h										
		INC SI 		;输入的数为负数需要读取第四个数为偏移量
	MOV  AL,[SI] 	;读取输入的正整数
 	MOV num,AL	;获取输入的正整数偏移量保存到num中
 	SUB num,48	;将获取到的ASCII码转化为实际的数字要减去48
 	CMP  num,0
 	JB   erroInput	;小于0跳转到输入有误
 	CMP num,8
 	JG   erroInput	;大于8跳转跳转到输入错误
 	JMP  decode	;-8<=num<0,跳转到加密
    	JMP exit
     
;输入的整数是非负数的情况
PositiveNumber:
   	LEA DX, CRLF        	    ;回车换行              
    	MOV AH, 09H				
    	INT  21h
  	MOV  AL,[SI] 	;读取输入的正整数,位于第三个位置
   	MOV num,AL	;获取输入的正整数偏移量保存到num中
   	SUB num,48	;将获取到的ASCII码转化为实际的数字要减去48
     	CMP num,0
   	JE   showInputStr 	;输入的偏移量num = 0则直接显示输入的字符串
    	LEA DX, CRLF              ;回车换行                 
    	MOV AH, 09H				
    	INT  21h
  	CMP  num,0
  	JB   erroInput	 ;小于0跳转到输入有误
  	CMP num,8
  	JG   erroInput	;大于8跳转跳转到输入错误
    	LEA DX,encodeMsg		;提示加密信息
    	MOV AH,09h
    	INT  21h
   	JMP  ENCODE		;0 <num<=8,跳转到加密

  	;错误输入处理
erroInput:
   	LEA DX,RepeatInputMsg
   	MOV AH,09h
   	INT 21h
   	JMP exit   ;结束错误处理
  
	;直接显式输出输入的字符串
showInputStr:
       	LEA DX,showCodeStrMsg 				 ;显示提示信息
       	MOV AH,09h
       	INT 21h
       	LEA DX, BUFFER+2             ;输出输入的字符串
        	MOV AH, 09H							 
        	INT 21H
        	JMP exit
;加密处理
ENCODE:    
       	LEA  SI ,BUFFER+2		 ;键入字符串的起始地址
       	LEA  DI,codeStr  		;键入加密后字符串的起始地址
      	MOV  CL,BUFFER+2 	;初始化开始循环的起始地址
      	MOV CH,0
ENCODE_AGAIN:
 	MOV AL, [SI ]		;取来一个
 	CMP AL,'$'
       	JE  showCodeStr		;加密结束，打印解密后的字符串
 	CMP  AL, 'A'
 	JL    ENCODE_NEXT		 ;小于'A'不用处理，转移到下一个
 	CMP AL,'z' 		
 	JG  ENCODE_NEXT		 ;大于'z'不用处理，转移到下一个
 	CMP AL, 'a'
 	JL   ENCODE_Uppercase 		;小于'a'可能是大写，转移
 	CMP AL,'a'
 	JAE   ENCODE_Lowercase
ENCODE_Lowercase:
	ADD  AL, num;		;当前字符加上加密的偏移量
 	CMP  AL,'z'
 	JA  EncodeSub 		;大于'z'，超过了最后的字母，应减去26
	JMP  ENCODE_NEXT	;跳转到处理字符函数
ENCODE_Uppercase:
 	CMP AL, 'Z' 								
	JG  ENCODE_NEXT 		 ;大于'Z'不用处理，转移到下一个
	ADD  AL, num
	CMP  AL, 'Z'
	JA  EncodeSub		;大于'Z'，超过了最后的字母，应减去26
 	JMP ENCODE_NEXT		;跳转到处理字符函数
EncodeSub:
 	SUB AL, 26		;当前字符减去26
 	JMP ENCODE_NEXT			;跳转到处理字符函数	
ENCODE_NEXT:
 	MOV  [DI], AL		;将当前的字符保存到保存密码
 	INC SI			;SI指针自增1
	INC DI			;DI指针自增1
 	LOOP   ENCODE_AGAIN         	  ;重新进行循环
;加密结束


;解密处理
DECODE:
  	LEA  SI ,BUFFER+2			 ;键入字符串的起始地址
      	LEA  DI,codeStr			 ;键入加密后字符串的起始地址
      	MOV  CL,BUFFER+2 		;初始化开始循环的起始地址
      	MOV CH,0
DECODE_AGAIN:
 	MOV AL, [SI ]					;取来一个
 	CMP AL,'$' 	
       	JE  showCodeStr		;循环结束，打印解密后的字符串
 	CMP  AL, 'A'
 	JB DECODE_NEXT					
 	CMP AL,'z' 
 	JA DECODE_NEXT		 ;大于'z'不用处理，转移到下一个
 	CMP AL, 'a'
 	JB DECODE_Uppercase	 ;小于'a'可能是大写，转移
DECODE_Lowercase:
	SUB  AL, num		;向左偏移 num个位置
 	CMP  AL,'a'
 	JB  DecodeAdd		;大于'z'，超过了最后的字母，应减去26
	JMP  DECODE_NEXT
DECODE_Uppercase:
 	CMP AL, 'Z' 
	JA DECODE_NEXT  			;大于'Z'不用处理，转移到下一个
	SUB  AL, num 		 ;向左偏移 num个位置
 	CMP  AL, 'A'
	JB   DecodeAdd				 ;小于A，应该加上26
 	JMP DECODE_NEXT
DECODE_NEXT:
 	MOV  [DI], AL		;将当前的字符保存到保存密码
 	INC SI				;SI指针自增1
	INC DI			;DI指针自增1
 	LOOP   DECODE_AGAIN          	  ;重新进行循环
 DecodeAdd:
  	ADD  AL,26	;当前字符需要加上26
  	JMP DECODE_NEXT            ;跳转到处理字符函数
 ;解密结束
 
;输出加密或者解密后的字符串
showCodeStr:
       	LEA DX,codeStr
       	MOV AH,09h
       	INT 21h
      	JMP  exit
;结束输出加密或者解密后的字符串
 
 ;结束程序
exit: 
        	MOV AH, 4CH                      ;返回DOS系统
        	INT 21H
	CODE   ENDS                                  
	END    START                                              
