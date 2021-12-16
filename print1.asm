data segment ;数据段
    string1 db '*********#', 0dh, 0ah, '********##', 0dh, 0ah, '*******###', 0dh, 0ah, '******####', 0dh, 0ah, '$' ;分成两个变量，不然报错Line too long
    string2 db '*****#####', 0dh, 0ah, '****######', 0dh, 0ah, '***#######', 0dh, 0ah, '**########', 0dh, 0ah, '*#########$' ;要求打印的字符阵列
data ends

code segment ;代码段
assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax
    mov dx, offset string1 ;获得string变量的偏移量，作为输出的数据  用lea也行
    mov ah, 9 ;9号功能，打印一个字符串
    int 21h ;调用中断
    mov dx, offset string2
    mov ah, 9
    int 21h
    mov ah, 4ch ;带返回值结束
    int 21h
code ends
end start