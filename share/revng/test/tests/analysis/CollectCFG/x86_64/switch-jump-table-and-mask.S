#
# This file is distributed under the MIT License. See LICENSE.md for details.
#

    .intel_syntax noprefix
    .type myfunc, @function
    .globl myfunc
myfunc:
    # The switch index is constrained by a bitmask (`and`) rather than a
    # `cmp`/`ja` bounds check. The goal of this test is to verify if we can
    # catch the pattern `(x & 7) << 2`, which internally becomes `(x << 2) & 0x1c`
    mov    rax, QWORD PTR [rax]
    and    eax, 0x7
    lea    rcx, [rip + jumptable]
    movsxd rax, DWORD PTR [rcx + rax*4]
    add    rax, rcx
    jmp    rax
one:
    mov rax, 0x3
    ret
two:
    mov rax, 0x5
    ret
three:
    mov rax, 0x6
    ret
four:
    mov rax, 0x7
    ret
five:
    mov rax, 0x8
    ret
six:
    mov rax, 0x9
    ret
seven:
    mov rax, 0xa
    ret
eight:
    mov rax, 0xb
    ret

    .intel_syntax noprefix
    .type _start, @function
    .globl _start
_start:
    mov rax, rdi
    call myfunc
    mov rdi, rax
    ret

    .section        .rodata
jumptable:
    .long one - jumptable
    .long two - jumptable
    .long three - jumptable
    .long four - jumptable
    .long five - jumptable
    .long six - jumptable
    .long seven - jumptable
    .long eight - jumptable
