;------------------------------------------
; int slen(char * s (in eax))
; String length calculation function
slen:
    push    ebx
    mov     ebx, eax
 
nextchar:
    cmp     byte [eax], 0
    jz      finished
    inc     eax
    jmp     nextchar
 
finished:
    sub     eax, ebx
    pop     ebx
    
    ret

;------------------------------------------
; void sprint(String message (in ecx))
; String printing function
sprint:
    push    edx
    push    ebx
    push    eax
    
    mov     eax, ecx
    call    slen
    mov     edx, eax
 
    mov     ebx, 1
    mov     eax, 4
    int     80h
    
    pop     eax
    pop     ebx
    pop     edx 

    ret

;------------------------------------------
; void fprint(String message (in ecx), int len (in edx))
; String printing function
fprint:

    push    ebx
    push    eax
 
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     eax
    pop     ebx

    ret

; void read 
read:
    push    ebx
    push    eax

    mov     ebx, 0 ; write to the STDIN file
    mov     eax, 3 ; invoke SYS_READ (kernel opcode 3)
    int     80h

    pop     eax
    pop     ebx

    ret
 
;------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    mov     ebx, 0
    mov     eax, 1
    int     80h

    ret