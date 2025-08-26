.MODEL SMALL
.STACK 100h

.DATA
BUFMAX      EQU 63

msgAsk1     db 0Dh,0Ah,'Enter first string: $'
msgAsk2     db 0Dh,0Ah,'Enter second string: $'
msgLen      db 0Dh,0Ah,'strlen(s1) = $'
msgCmp      db 0Dh,0Ah,'strcmp(s1, s2) = $'
msgRev      db 0Dh,0Ah,'strrev(s1) -> $'
nl          db 0Dh,0Ah,'$'

in1         db BUFMAX,0,BUFMAX dup(0)
in2         db BUFMAX,0,BUFMAX dup(0)

str1        db BUFMAX+1 dup(0)
str2        db BUFMAX+1 dup(0)

.CODE
MAIN PROC
    mov ax,@data
    mov ds,ax

    mov dx,OFFSET msgAsk1
    mov ah,09h
    int 21h
    mov dx,OFFSET in1
    mov ah,0Ah
    int 21h
    mov dx,OFFSET in1
    mov di,OFFSET str1
    call BUF_TO_Z

    mov dx,OFFSET msgAsk2
    mov ah,09h
    int 21h
    mov dx,OFFSET in2
    mov ah,0Ah
    int 21h
    mov dx,OFFSET in2
    mov di,OFFSET str2
    call BUF_TO_Z

    mov dx,OFFSET msgLen
    mov ah,09h
    int 21h
    mov si,OFFSET str1
    call STRLEN
    mov ax,cx
    call PRINT_NUM
    mov dx,OFFSET nl
    mov ah,09h
    int 21h

    mov dx,OFFSET msgCmp
    mov ah,09h
    int 21h
    mov si,OFFSET str1
    mov di,OFFSET str2
    call STRCMP
    call PRINT_NUM_S
    mov dx,OFFSET nl
    mov ah,09h
    int 21h

    mov dx,OFFSET msgRev
    mov ah,09h
    int 21h
    mov si,OFFSET str1
    call STRREV
    mov si,OFFSET str1
    call PRINTZ
    mov dx,OFFSET nl
    mov ah,09h
    int 21h

    mov ax,4C00h
    int 21h
MAIN ENDP

BUF_TO_Z PROC
    push si
    push cx
    mov si,dx
    mov cl,[si+1]
    lea si,[si+2]
    xor ch,ch
    jcxz BTZ_end
BTZ_loop:
    mov al,[si]
    mov [di],al
    inc si
    inc di
    loop BTZ_loop
BTZ_end:
    mov byte ptr [di],0
    pop cx
    pop si
    ret
BUF_TO_Z ENDP

PRINTZ PROC
    push ax
    push dx
PZ_loop:
    mov al,[si]
    cmp al,0
    je PZ_done
    mov dl,al
    mov ah,02h
    int 21h
    inc si
    jmp PZ_loop
PZ_done:
    pop dx
    pop ax
    ret
PRINTZ ENDP

PRINT_NUM PROC
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
PRINT_NUM ENDP

PRINT_NUM_S PROC
    push ax
    cmp ax,0
    jge PNS_pos
    mov dl,'-'
    mov ah,02h
    int 21h
    neg ax
PNS_pos:
    call PRINT_NUM
    pop ax
    ret
PRINT_NUM_S ENDP

STRLEN PROC
    push si
    xor cx,cx
SL_loop:
    cmp byte ptr [si],0
    je SL_done
    inc si
    inc cx
    jmp SL_loop
SL_done:
    pop si
    ret
STRLEN ENDP

STRCMP PROC
    push si
    push di
SC_loop:
    mov al,[si]
    mov bl,[di]
    cmp al,bl
    jne SC_noteq
    cmp al,0
    je SC_eq
    inc si
    inc di
    jmp SC_loop
SC_noteq:
    jb SC_lt
    mov ax,1
    jmp SC_done
SC_lt:
    mov ax,-1
    jmp SC_done
SC_eq:
    xor ax,ax
SC_done:
    pop di
    pop si
    ret
STRCMP ENDP

STRREV PROC
    push si
    push di
    push cx
    push ax
    mov di,si
    call STRLEN
    jcxz SR_done
    dec cx
    add di,cx
SR_loop:
    cmp si,di
    jge SR_done
    mov al,[si]
    mov bl,[di]
    mov [si],bl
    mov [di],al
    inc si
    dec di
    jmp SR_loop
SR_done:
    pop ax
    pop cx
    pop di
    pop si
    ret
STRREV ENDP

END MAIN
