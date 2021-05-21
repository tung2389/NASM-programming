%include '../utility.asm'
%include './socketUtility.asm'

SECTION .bss
    msg: resb 10000
    lenMsg: resb 3

SECTION .text

%define SYS_EXIT 60

%define SYS_SOCKET 41
%define SYS_BIND 49
%define SYS_LISTEN 50
%define SYS_ACCEPT 43
%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_CLOSE 3

%define AF_INET 2
%define SOCK_STREAM 1
%define DEFAULT_PROC 0
%define ANY_ADDR 0
%define MAX_QUEUE 1

global  _start

_start:

socketCreate:
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, DEFAULT_PROC
    mov rax, SYS_SOCKET
    syscall

socketBind:
    mov rdi, rax ;socket fd
    
    ; struct sockaddr_in {
    ;     sa_family_t    sin_family; /* address family: AF_INET */
    ;     in_port_t      sin_port;   /* port in network byte order */
    ;     struct in_addr sin_addr;   /* internet address */
    ; };

    ; /* Internet address. */
    ; struct in_addr {
    ;     uint32_t       s_addr;     /* address in network byte order */
    ; };
    
    ; sockaddr_in 
    push qword 0 ; padding
    push dword ANY_ADDR
    push word 0x401F ; Port 8000, but need to convert to big endian since TCP uses big endian
    push word AF_INET

    mov rsi, rsp ; struct sokaddr *umyaddr
    mov rdx, 16 ; int addrlen
    mov rax, SYS_BIND
    syscall

socketListen:
    mov rsi, MAX_QUEUE
    mov rax, SYS_LISTEN
    syscall

socketAccept:
    sub rsp, 8
    mov rsi, rsp ; struct sockaddr *upeer_sockaddr
    push dword 8
    mov rdx, rsp ; int *upeer_addrlen

    mov rax, SYS_ACCEPT
    syscall

mov rdi, rax ; file descritor of new accepted socket

_socketLoop:
    push rsi
    mov rsi, msg
    call emptyString
    pop rsi

    ; Read message's len information sent by client
    mov rsi, lenMsg ; char* buf
    mov rdx, 3 ; size_t count
    call socketRead

    ; Read message sent by client
    mov rsi, msg ; char* buf
    mov rdx, 10000 ; size_t count
    call socketRead

    ; Decrypt client's message
    push rdi
    mov rdi, msg
    call decrypt
    pop rdi
    
    ; Print client's message
    call printMsg

    ; If no more data received, close the socket
    mov rax, msg
    call slen
    cmp rax, 0
    je _socketClose

    ; rax now holds message length

    ; Write message len into a string to send that information to client
    push rdi
    mov rdi, rax
    mov rsi, lenMsg
    call intToString
    pop rdi

    ; Send message's len to the client
    mov rsi, lenMsg
    mov rdx, 3
    call socketWrite

    ; Encrypt the message
    push rdi
    mov rdi, msg
    call encrypt
    pop rdi

    ; Send message to the client
    mov rsi, msg
    mov rdx, 10000
    call socketWrite

    jmp _socketLoop



_socketClose:
    mov rax, SYS_CLOSE
    syscall

call quit

SECTION .data:
    key db 'iwoeru328947298ewff$!@#$%^^&*)&#^#*&!#@!@))8u382daad~-=', 0