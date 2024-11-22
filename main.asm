.code64

.global _start

stdout = 1
SYS_write = 1
SYS_exit = 60

.text
// Read the first command line argument and inform the user if its integer
// value is divisible by 7
_start:
    pop %rax
    cmp $2, %rax
    jl not_enough_args
    pop %r12
    mov %r12, %rdi
    call strlen
    add %rax, %r12
    inc %r12
    // r12 now points to the first user given
    // command line argument
    mov %r12, %rdi
    call atoi
    xor %rdx, %rdx
    mov $7, %rcx
    div %rcx
    test %rdx, %rdx
    jz .divisible
    mov $no, %rsi
    mov $stdout, %rdi
    call print
    xor %rdi, %rdi
    call gtfo
    .divisible:
    mov $yes, %rsi
    mov $stdout, %rdi
    call print
    xor %rdi, %rdi
    call gtfo
    
not_enough_args:
    mov $stdout, %rdi
    mov $gimme_more, %rsi
    call print
    xor %rdi, %rdi
    inc %rdi
    call gtfo

// call exit syscall with the return code stored in %rdi
gtfo:
    mov $SYS_exit, %rax
    syscall

// Take the null-terminated string pointed to by %rdi and return the length
// in %rax
strlen:
    xor %rax, %rax
    strlen.loop:
    mov (%rdi), %cl
    test %cl, %cl
    je strlen.end
    inc %rdi
    inc %rax
    jmp strlen.loop
    strlen.end:
    ret

// Take the null-terminated string pointed to by %rdi and return the integer
// value in %rax
atoi:
    xor %rax, %rax
    mov $10, %r10
    atoi.loop:
    xor %rcx, %rcx
    mov (%rdi), %cl
    test %cl, %cl
    je atoi.end
    cmp $0x30, %cl
    jl atoi.not_an_int
    cmp $0x39, %cl
    jg atoi.not_an_int
    mul %r10
    sub $0x30, %cl
    add %rcx, %rax
    inc %rdi
    jmp atoi.loop
    atoi.end:
    ret
    atoi.not_an_int:
    mov $not_an_int, %rsi
    mov $stdout, %rdi
    call print
    xor %rdi, %rdi
    inc %rdi
    call gtfo

// Take the null-terminated string pointed to by %rsi and print it to the
// file descriptor in %rdi
print:
    push %rdi
    push %rsi
    mov %rsi, %rdi
    call strlen
    mov %rax, %rdx
    pop %rsi
    pop %rdi
    mov $SYS_write, %rax
    syscall
    ret
    
.data
yes: .asciz "Yeah that's divisible\n"
no: .asciz "No that isn't divisible by 7\n"
gimme_more: .asciz "Please supply a number to test\n"
not_an_int: .asciz "That is not an integer. Be better.\n"
