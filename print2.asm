data segment ;数据段
    crlf db 0ah, 0dh, '$'
    row dw 0000h ;define world 因为之后row会和cx比较，故需要16位 
data ends

code segment ;代码段
assume cs:code, ds:data
start:
    mov ax,data
    mov ds,ax
    mov cx, 9 ;一共九行，循环九次
    mov row, 1
    outter:
        push cx ;控制外层（即控制行）的cx的值入栈进行保存，因为里层 列的循环也需要用到cx寄存器。
        mov cx, 10 ;一行中有十个字符，循环十次
        inner:
            cmp row, cx
            jb ChooseChr1 ;如果这时 row 小于里层的 cx, 则输出 *，否则输出#
            jmp ChooseChr2
            ChooseChr1:
                mov dx, '*'
                jmp Output
            ChooseChr2:
                mov dx, '#'
            Output:
                mov ah, 02h ;02号中断功能，输出一个字符，值就放在dx里
                int 21h
            loop inner
        pop cx ;弹栈，恢复外层的cx
        inc row ;row自增1，表示行数加1
        lea dx, crlf; 输出换行，因为一行已经结束
        mov ah, 09h ;09号中断，输出一个字符串
        int 21h
        loop outter 
    mov ah,4ch ;带返回值结束
    int 21h
code ends
end start