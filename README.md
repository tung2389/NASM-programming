# My programming practice with NASM (Netwide Assembler)

NASM version 2.15.05

## List of programs

1. [Reverse a string](./reverse/reverse.asm)
2. [Echo client-server with XOR encryption](./client-server-XOR/)

## Usage
1. Install NASM version 2.15.05 from [here](https://www.nasm.us/).

2. Choose a program that you want to use and run these commands to get the executable file.

- Compile to 64-bit program (for example, let's compile clientXOR.asm):
```
nasm -f elf64 -g clientXOR.asm
ld -static -o main clientXOR.o
```

- Compile to 32-bit program (only reverse.asm and reverse2.asm):
```bash
nasm -f elf reverse.asm
ld -m elf_i386 reverse.o -o main
```

3. Run ```./main``` to run the program.