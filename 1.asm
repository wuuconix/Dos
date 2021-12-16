data segment ;数据段
    string db '*********#', 0dh, 0ah, '********##', 0dh, 0ah, '*******###', 0dh, 0ah, '******####', 0dh, 0ah, '*****#####', 0dh, 0ah, '****######', 0dh, 0ah, '***#######', 0dh, 0ah, '**########', 0dh, 0ah, '*#########$' ;要求打印的字符阵列
data ends

code segment ;代码段
assume cs:code,ds:data
start:
    mov ax, data ;获取段基址
    mov ds, ax ;将段基址送入寄存器
    mov dx, offset string1 ;利用offset指令
    mov ah, 9 ;显示字符至屏幕
    int 21h
    mov ah, 4ch ;带返回值结束
    int 21h
code ends
end start