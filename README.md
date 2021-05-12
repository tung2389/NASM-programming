# My programming practice with NASM (Netwide Assembler)

NASM version 2.15.05

## List of programs

1. [Reverse a string](./reverse.asm)

## Usage
1. Install NASM version 2.15.05 from [here](https://www.nasm.us/).

2. Choose a program that you want to use. For example, if you choose reverse.asm, you can run these commands to get the executable file.

```bash
nasm -f elf reverse.asm
ld -m elf_i386 reverse.o -o main
```

3. Run ```./main``` to run the program.