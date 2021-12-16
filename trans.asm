data segment
	info0 db 'please input a character:$'
	info1 db 0dh, 0ah, 'not a alpha!$' ;不是字母时的提示性语句
	info2 db 0dh, 0ah, 'uppdercase alpha! change to $' ;是大写字母时的提示性语句
	info3 db 0dh, 0ah, 'lowercase alpha! change to $' ;是小写字母时的提示性语句
data ends

code segment ;代码段
assume cs:code, ds:data ;伪指令用以关联段寄存器和段名
start:
    mov ax, data ;虽然assume了但是仍然需要手动为ds赋值
    mov ds, ax
	lea dx, info0 ;获得info0的偏移量，作为输出的数据 
	mov ah, 09h ;09号功能，打印一个字符串
	int 21h
	mov ah, 01h ;从键盘输入并输出到屏幕
	int 21h	;经过这一步，输入的字母会存在al寄存里，其值位ascii码值（16进制）
	cmp al, 65 ;A的ascii码，<A 说明不是字母
	jb notAlpha
	cmp al, 122 ;z的ascii码，>z 说明不是字母
	ja notAlpha
	cmp al, 90 ;Z的ascii码, <=Z 说明是大写字母
	jbe Upper
	cmp al, 97 ;a的ascii码, >=a 说明是小写字母
	jae Lower
	jmp notAlpha; 剩下的情况说明是在Z和a之间的非字母, 这一句没有也行，因为顺序执行到 notAlpha
	notAlpha: 
		lea dx, info1 ;获得info1的偏移量，作为输出的数据 
    	mov ah, 09h ;09号功能，打印一个字符串
    	int 21h
		jmp final
	Upper:
		lea dx, info2
		mov ah, 09h
		int 21h
		add al, 32 ;ascii加32变成小写
		mov dl, al ;将转化后的ascii码存到dl中用以输出
		mov ah, 02h ;02号功能，打印一个字符，即letter
		int 21h
		jmp final 
	Lower:
		lea dx, info3 ;输出提示信息
		mov ah, 09h
		int 21h
		sub al, 32 ;ascii减32变成大写
		mov dl, al ;将转化后的ascii码存到dl中用以输出
		mov ah, 02h ;02号功能，打印一个字符，即letter
		int 21h
		jmp final ;可以不写，顺序执行
	final:
		mov ah,4ch ;带返回值结束
   	 	int 21h
code ends
end start