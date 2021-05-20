%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_EXIT 60

%define STDIN 0
%define STDOUT 1

;------------------------------------------
; int slen(char * s (%rax))
; String length calculation function
slen:
    push    rbx
    mov     rbx, rax

nextchar:
    cmp     byte [rax], 0
    jz      finished
    inc     rax
    jmp     nextchar

finished:
    sub     rax, rbx
    pop     rbx

    ret
    
;------------------------------------------
; void sprint(char *buf (%rsi))
; String printing function
sprint:
    push    rdx
    push    rax
    push    rdi

    mov     rax, rsi
    call    slen
    mov     rdx, rax

    mov     rdi, STDOUT
    mov     rax, SYS_WRITE
    syscall

    pop     rdi
    pop     rax
    pop     rdx

    ret


; char* buf (%rsi)
emptyString:
    push rsi

iterate:
    cmp byte [rsi], 0
    jz done
    mov byte [rsi], 0
    inc rsi
    jmp iterate 

done:
    pop rsi
    
    ret

;------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    xor rdi, rdi ; Set exit status to 0
    mov rax, SYS_EXIT
    syscall

