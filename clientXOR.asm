%include 'utility.asm'

SECTION .bss
    msg: resb 10000

SECTION .text
%define SYS_EXIT 60

%define SYS_SOCKET 41
%define SYS_CONNECT 42
%define SYS_WRITE 1
%define SYS_READ 0
%define SYS_CLOSE 3

%define AF_INET 2
%define SOCK_STREAM 1
%define DEFAULT_PROC 0
; 127.0.0.1, but written in reverse since computer uses little endian but TCP uses big endian
%define LOCAL_HOST 0x0100007F

global  _start

_start:

socketCreate:
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, DEFAULT_PROC
    mov rax, SYS_SOCKET
    syscall

socketConnect:
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
    push dword LOCAL_HOST
    push word 0x401F ; Port 8000, but written in reverse since computer uses little endian but TCP uses big endian
    push word AF_INET

    mov rsi, rsp ; struct sokaddr *umyaddr
    mov rdx, 16 ; int addrlen
    mov rax, SYS_CONNECT
    syscall

_socketLoop:

    push rsi
    mov rsi, msg
    call emptyString
    pop rsi

    call readMsg
    call socketWrite

    mov rax, msg
    call slen
    cmp rax, 0
    je _socketClose

    call socketRead
    call printMsg

    jmp _socketLoop

readMsg:
    push rdi

    ; Read input
    mov rdi, STDIN
    mov rsi, msg  ; reserved space to store our input (known as a buffer)
    mov rdx, 10000    ; number of bytes to read
    mov rax, SYS_READ
    syscall

    pop rdi

    ret

socketWrite:
    mov rsi, msg
    mov rdx, 10000
    mov rax, SYS_WRITE
    syscall

    ret

socketRead:
    mov rsi, msg ; char* buf
    mov rdx, 10000 ; size_t count
    mov rax, SYS_READ
    syscall

    ret

printMsg:
    mov rsi, msg
    call sprint

    ret

_socketClose:
    mov rax, SYS_CLOSE
    syscall

call quit
