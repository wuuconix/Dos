data segment
    flag db 'flag{', ? , '}$'
data ends

code segment
assume cs:code, ds:data
start:
    mov ah, 01h ;输入
    int 21h
    mov flag, al
    lea dx, flag
    mov ah, 09h ;输出
    int 21h
    mov ah, 4ch ;exit
    int 21h
code ends
end start
