data segment
	letter db ?, '$'
	info1 db 0dh, 0ah, 'not a alpha!$'
	info2 db 0dh, 0ah, 'uppdercase alpha! change to $'
	info3 db 0dh, 0ah, 'lowercase alpha! change to $'
data ends

code segment
assume cs:code, ds:data
start:
	mov ax, data
	mov ds, ax
	mov ah, 01h ;从键盘输入并输出到屏幕
	int 21h	;经过这一步，输入的字母会存在al寄存里，其值位ascii码值（16进制）
	;mov letter, al
	cmp al, 65 ;A的ascii码，比A小说明不是字母
	jb notAlpha
	cmp al, 122 ;z，比z大说明不是字母
	ja notAlpha
	cmp al, 90 ; Z,比Z小说明是大写字母
	jbe Upper
	cmp al, 97; a,比a大说明是小写字母
	jae Lower
	jmp notAlpha; 剩下的情况说明是在Z和a之间的非字母
	notAlpha: 
		lea dx, info1 ;和mov dx, offset leeter一个效果
    	mov ah,9 ;显示字符至屏幕
    	int 21h
		jmp final
	;mov dx, offset letter
	Upper:
		lea dx, info2 ;输出提示信息
		mov ah, 9
		int 21h
		add al, 32 ;ascii加32变成小写
		mov letter, al ;输出字母
		lea dx, letter
		mov ah, 9
		int 21h
		jmp final 
	Lower:
		lea dx, info3 ;输出提示信息
		mov ah, 9
		int 21h
		sub al, 32; ascii减32变成大写
		mov letter, al ;输出字母
		lea dx, letter
		mov ah, 9
		int 21h
		jmp final
	final:
		mov ah,4ch ;带返回值结束
   	 	int 21h
code ends
end start