.MODEL SMALL
.STACK 100h
.DATA
str1 DB 'HELLO$',0
str2 DB 'HELLO$',0

.CODE
MAIN PROC
    mov ax,@data
    mov ds,ax

    lea si,str1
    call STRREV

    mov dx,OFFSET str1
    mov ah,09h
    int 21h

    mov ah,4Ch
    int 21h
MAIN ENDP

; ---------- String Procedures ----------
STRLEN PROC
    mov cx,0
next:
    cmp BYTE PTR [si],0
    je done
    inc si
    inc cx
    jmp next
done:
    ret
STRLEN ENDP

STRCMP PROC
nextc:
    mov al,[si]
    mov bl,[di]
    cmp al,bl
    jne notequal
    cmp al,0
    je equal
    inc si
    inc di
    jmp nextc
notequal:
    mov ax,1
    ret
equal:
    mov ax,0
    ret
STRCMP ENDP

STRREV PROC
    push si
    call STRLEN
    dec cx
    mov di,si
    add di,cx
revloop:
    cmp si,di
    jge done
    mov al,[si]
    mov bl,[di]
    mov [si],bl
    mov [di],al
    inc si
    dec di
    jmp revloop
done:
    pop si
    ret
STRREV ENDP
END MAIN
