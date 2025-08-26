.MODEL SMALL
.STACK 100h
.DATA
result DW ?

.CODE
MAIN PROC
    mov ax,@data
    mov ds,ax

    mov ax,12
    mov bx,4
    mov dl,'*'   

    cmp dl,'+'
    jne checksub
    add ax,bx
    jmp done

checksub:
    cmp dl,'-'
    jne checkmul
    sub ax,bx
    jmp done

checkmul:
    cmp dl,'*'
    jne checkdiv
    mul bx
    jmp done

checkdiv:
    cmp dl,'/'
    jne done
    xor dx,dx
    div bx

done:
    mov result,ax
    mov ax,result
    call print_num

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
