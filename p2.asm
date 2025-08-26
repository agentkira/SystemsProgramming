.MODEL SMALL
.STACK 100h
.DATA
arr DB 5,8,3,7,9,2,6,1,4,10,11,15,12,20,14,19,17,13,18,16

.CODE
MAIN PROC
    mov ax,@data
    mov ds,ax

    lea si,arr
    mov cx,19

zigzag:
    mov al,[si]
    mov bl,[si+1]
    test si,1
    jz lessthan

greater:
    cmp al,bl
    jg skip
    xchg al,bl
    mov [si],al
    mov [si+1],bl
    jmp skip

lessthan:
    cmp al,bl
    jl skip
    xchg al,bl
    mov [si],al
    mov [si+1],bl

skip:
    inc si
    loop zigzag

    ; print array
    lea si,arr
    mov cx,20
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
