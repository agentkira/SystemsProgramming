.MODEL SMALL
.STACK 100h

.DATA
msgAsk  db 0Dh,0Ah,'Enter 16-bit hex (up to 4 digits): $'
msgOut  db 0Dh,0Ah,'ASCII = $'
nl      db 0Dh,0Ah,'$'
buf     db '0000$'
inbuf   db 5,0,5 dup(0)

.CODE
MAIN PROC
    mov ax,@data
    mov ds,ax

    mov dx,OFFSET msgAsk
    mov ah,09h
    int 21h

    mov dx,OFFSET inbuf
    mov ah,0Ah
    int 21h

    xor ax,ax
    lea si,inbuf+2
    xor cx,cx
    mov cl,[inbuf+1]
    cmp cl,4
    jbe short L_lenok
    mov bl,cl
    sub bl,4
    xor bh,bh
    add si,bx
    mov cl,4
L_lenok:
    jcxz L_parsedone
L_parse:
    mov dl,[si]
    inc si
    and dl,11011111b
    cmp dl,'9'
    jle short L_isdigit
    sub dl,'A'
    add dl,10
    jmp short L_have
L_isdigit:
    sub dl,'0'
L_have:
    shl ax,1
    shl ax,1
    shl ax,1
    shl ax,1
    or  al,dl
    loop L_parse
L_parsedone:

    mov cx,4
    lea si,buf+3
L_conv:
    mov bl,al
    and bl,0Fh
    cmp bl,9
    jbe short L_ok
    add bl,7
L_ok:
    add bl,'0'
    mov [si],bl
    dec si
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    loop L_conv

    mov dx,OFFSET msgOut
    mov ah,09h
    int 21h
    mov dx,OFFSET buf
    mov ah,09h
    int 21h
    mov dx,OFFSET nl
    mov ah,09h
    int 21h

    mov ax,4C00h
    int 21h
MAIN ENDP
END MAIN
