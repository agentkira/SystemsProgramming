.MODEL SMALL
.STACK 100h
.DATA
arr1 DB 1,2,3,4,5,6,7,8,9,10
arr2 DB 10 DUP(?)

.CODE
MAIN PROC
    mov ax,@data
    mov ds,ax
    mov es,ax

    lea si,arr1
    lea di,arr2
    mov cx,10

next:
    mov al,[si]
    mov bl,5
    mul bl
    add al,10
    mov [di],al
    inc si
    inc di
    loop next

    ; print result
    lea si,arr2
    mov cx,10
print_loop:
    mov al,[si]
    call print_num
    mov dl,' '
    mov ah,02h
    int 21h
    inc si
    loop print_loop

    mov ah,4Ch
    int 21h
MAIN ENDP

print_num PROC
    push ax bx cx dx
    xor cx,cx
    mov bx,10
conv_loop:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne conv_loop
out_loop:
    pop dx
    add dl,'0'
    mov ah,02h
    int 21h
    loop out_loop
    pop dx cx bx ax
    ret
print_num ENDP
END MAIN
