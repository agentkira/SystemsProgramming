.MODEL SMALL
.STACK 100h
.DATA
buf DB '0000$'

.CODE
MAIN PROC
    mov ax,@data
    mov ds,ax

    mov ax,1234h
    mov cx,4
    lea si,buf+3

convert:
    mov bl,al
    and bl,0Fh
    cmp bl,9
    jbe digit
    add bl,7
digit:
    add bl,'0'
    mov [si],bl
    dec si
    shr ax,4
    loop convert

    mov dx,OFFSET buf
    mov ah,09h
    int 21h

    mov ah,4Ch
    int 21h
MAIN ENDP
END MAIN
