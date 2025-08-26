.MODEL SMALL
.STACK 100h

.DATA
msg1 db 0Dh,0Ah,'Enter first number: $'
msg2 db 0Dh,0Ah,'Enter operator (+ - * /): $'
msg3 db 0Dh,0Ah,'Enter second number: $'
msgR db 0Dh,0Ah,'Result = $'
nl   db 0Dh,0Ah,'$'

in1  db 6,0,6 dup(0)
in2  db 6,0,6 dup(0)

num1 dw ?
num2 dw ?
opch db ?

.CODE
MAIN PROC
    mov ax,@data
    mov ds,ax

    mov dx,OFFSET msg1
    mov ah,09h
    int 21h
    mov dx,OFFSET in1
    mov ah,0Ah
    int 21h
    mov dx,OFFSET in1
    call ascii_to_word
    mov num1,ax

    mov dx,OFFSET msg2
    mov ah,09h
    int 21h
    mov ah,01h
    int 21h
    mov opch,al
    mov dx,OFFSET nl
    mov ah,09h
    int 21h

    mov dx,OFFSET msg3
    mov ah,09h
    int 21h
    mov dx,OFFSET in2
    mov ah,0Ah
    int 21h
    mov dx,OFFSET in2
    call ascii_to_word
    mov num2,ax

    mov ax,num1
    mov bx,num2
    mov dl,opch

    cmp dl,'+'
    jne Lsub
    add ax,bx
    jmp Ldone
Lsub:
    cmp dl,'-'
    jne Lmul
    sub ax,bx
    jmp Ldone
Lmul:
    cmp dl,'*'
    jne Ldiv
    mul bx
    jmp Ldone
Ldiv:
    cmp dl,'/'
    jne Ldone
    xor dx,dx
    div bx
Ldone:
    mov dx,OFFSET msgR
    mov ah,09h
    int 21h
    call print_num_s
    mov dx,OFFSET nl
    mov ah,09h
    int 21h

    mov ax,4C00h
    int 21h
MAIN ENDP

ascii_to_word PROC
    push bx
    push cx
    push dx
    push si
    xor ax,ax
    lea si,[dx+2]
    mov cl,[dx+1]
    jcxz A_end
A_loop:
    mov dl,[si]
    inc si
    sub dl,'0'
    xor dh,dh
    mov bx,ax
    shl ax,1
    shl bx,3
    add ax,bx
    add ax,dx
    loop A_loop
A_end:
    pop si
    pop dx
    pop cx
    pop bx
    ret
ascii_to_word ENDP

print_num PROC
    push ax
    push bx
    push cx
    push dx
    xor cx,cx
    mov bx,10
PN_loop:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne PN_loop
PN_out:
    pop dx
    add dl,'0'
    mov ah,02h
    int 21h
    loop PN_out
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num ENDP

print_num_s PROC
    push ax
    cmp ax,0
    jge P_pos
    mov dl,'-'
    mov ah,02h
    int 21h
    neg ax
P_pos:
    call print_num
    pop ax
    ret
print_num_s ENDP

END MAIN
