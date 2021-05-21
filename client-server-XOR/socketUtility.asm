; Parameters:
;   char* s (%rsi)
;   size_t numBytes
socketWrite:
    push rax
    mov rax, SYS_WRITE
    syscall
    pop rax

    ret

; Parameters:
;   char* s (%rsi)
;   size_t numBytes
socketRead:
    push rax
    mov rax, SYS_READ
    syscall
    pop rax
    
    ret

printMsg:
    push rsi
    mov rsi, msg
    call sprint
    pop rsi

    ret

; Parameters:
;     char* s (%rdi)
encrypt:   
    push rsi
    push rax

    mov rsi, key

encryptLoop:
    cmp byte [rdi], 0
    je finishEncryption

    cmp byte [rsi], 0
    je .repeatKey

    jmp .iterate

.repeatKey:
    mov rsi, key

.iterate:
    movzx rax, byte [rdi]
    xor al, byte [rsi]
    mov [rdi], al

    inc rdi
    inc rsi

    jmp encryptLoop

finishEncryption:
    pop rax
    pop rsi

    ret

; Parameters:
;     char* s (%rdi)
decrypt:   
    push rsi
    push rax

    mov rsi, key

    push rdi
    mov rdi, lenMsg
    call stringToInt ; Now rax holds message len.
    pop rdi

    mov rcx, rax
    add rcx, msg ; Now rcx holds the address of the char after the last character of msg.

decryptLoop:
    cmp rdi, rcx 
    je finishDecryption

    cmp byte [rsi], 0
    je .repKey

    jmp .iterateDec

.repKey:
    mov rsi, key

.iterateDec:
    movzx rax, byte [rdi]
    xor al, byte [rsi]
    mov [rdi], al

    inc rdi
    inc rsi

    jmp decryptLoop

finishDecryption:
    pop rax
    pop rsi

    ret