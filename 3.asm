data segment ;数据段
    chr1 db '*$'
    chr2 db '#$'
    row dw 0000h
data ends
code segment ;代码段
assume cs:code, ds:data
start:
    mov ax,data ;获取段基址
    mov ds,ax ;将段基址送入寄存器
    mov cx, 9
    mov row, 1
    outter:
        push cx
        mov cx, 10
        inner:
            cmp row, cx
            jb ChooseChr1
            jmp ChooseChr2
            ChooseChr1:
                lea dx, chr1
                jmp Output
            ChooseChr2:
                lea dx, chr2
            Output:
                mov ah, 09h
                int 21h
            loop inner
        pop cx
        inc row
        mov ah, 02h
        mov dl, 0ah
        int 21h
        loop outter 
    mov ah,4ch ;带返回值结束
    int 21h
code ends
end start