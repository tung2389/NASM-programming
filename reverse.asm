%include 'utility.asm'

SECTION .data
    inputMsg db 'Enter your string: ', 0Ah 
    lenInputMsg equ $ - inputMsg 

    outputMsg db 'The reverse of your string is: ', 0Ah
    lenOutputMsg equ $ - outputMsg

SECTION .bss
    input: resb 255
    output: resb 255
 
SECTION .text
global  _start
 
_start:
    mov	edx, lenInputMsg     ;message length
    mov	ecx, inputMsg     ;message to write
    call fprint

    mov edx, 255 ; number of bytes to read
    mov ecx, input ; reserved space to store our input (known as a buffer)
    call read

    mov edx, lenOutputMsg
    mov ecx, outputMsg
    call fprint

    mov eax, input

iterate:
    cmp     byte [eax], 0
    jz      setCounter

    inc     eax
    jmp     iterate

setCounter:
    mov ecx, output
    dec eax
    dec eax

reverse:
    cmp eax, input
    jb printReverse

    movzx esi, byte [eax]
    mov [ecx], esi

    inc ecx
    dec eax 

    jmp reverse

printReverse:
    mov [ecx], dword 0x0a ; Add new line character at the end of reversed string
    mov ecx, output
    call sprint

    call quit

