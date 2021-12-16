    .model small
    .stack
    .data
string  db      'flag{songge_yyds}'
        db      0dh, 0ah, '$'
        .code
start:  mov ax,@data
        mov ds, ax
        lea dx, string
        mov ah, 9
        int 21h
        mov ax, 4c00h
        int 21h
        end start