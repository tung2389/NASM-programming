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
; void sprint(char* buf (%rsi))
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

; Parameters:
;   char* s (%rdi)
; Output: rax
stringToInt:
    push rdi
    push rbx
    push rdx

    mov rdx, rdi

iterat:
    cmp byte [rdi], 48
    jb convertToNum
    inc rdi
    jmp iterat

convertToNum:
    dec rdi
    mov rcx, 1
    mov rax, 0

iterateBack:
    cmp rdi, rdx
    jb doneConversion

    movzx rbx, byte [rdi]
    sub rbx, 48 ; ASCII code to digit
    
    imul rbx, rcx
    add rax, rbx

    imul rcx, 10
    dec rdi

    jmp iterateBack

doneConversion:

    pop rdx
    pop rbx
    pop rdi

    ret

; Parameters:
;   int a (%rdi), char* buf (%rsi)
intToString:
    push rdx
    push rbx
    push rax
    push rcx

    mov rbx, 10
    mov rax, rdi
    mov rcx, 0

divideLoop:
    
    cmp rax, 0
    je writeDigitToStr

    xor rdx, rdx
    div rbx
    add rdx, 48
    push rdx
    inc rcx

    jmp divideLoop

writeDigitToStr:
    cmp rcx, 0
    jz endLoop

    pop rdx
    mov byte [rsi], dl
    inc rsi
    dec rcx

    jmp writeDigitToStr

endLoop:

    pop rcx
    pop rax
    pop rbx
    pop rdx

    ret

;------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    xor rdi, rdi ; Set exit status to 0
    mov rax, SYS_EXIT
    syscall

