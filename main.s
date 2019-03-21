.section .rodata
usage_msg: .ascii "Usage: base64 [OPTION] [INP] [OUT]\nOptions:\n-d decode data\n-h print help\n"
open_error_msg: .ascii "Failed to open file\n"

.section .text
.extern base64_decode_file
.extern base64_encode_file

.globl _start
_start:
    ldr r6, [sp] @ argc
    mov r4, #0   @ standard input
    mov r5, #1   @ standard output

    cmp r6, #1
    beq work

    ldr r1, [sp, #8]

    ldrb r2, [r1]
    cmp r2, #'-'
    subeq r6, r6, #1
    bne open_files

    mov r3, #0
    ldrb r2, [r1, #1]
    cmp r2, #'h'
    beq print_usage
    cmp r2, #'d'
    moveq r3, #1
    bne print_usage

    cmp r6, #2
    addge sp, sp, #4
    blt work

open_files:
    mov r7, #5
    ldr r0, [sp, #8]
    mov r1, #0
    svc 0

    cmp r0, #0
    blt open_error
    mov r4, r0

    cmp r6, #3
    blt work

    ldr r0, [sp, #12]
    ldr r1, =577
    mov r2, #0644
    svc 0

    cmp r0, #0
    blt open_error
    mov r5, r0

work:
    mov r0, r4
    mov r1, r5

    cmp r3, #0
    bleq base64_encode_file
    blne base64_decode_file

    mov r7, #6
    mov r0, r4
    svc 0

    mov r0, r5
    svc 0
b exit
print_usage:
    mov r7, #4
    mov r0, #1
    ldr r1, =usage_msg
    mov r2, #73
    svc 0
    b exit
open_error:
    mov r7, #4
    mov r0, #1
    ldr r1, =open_error_msg 
    mov r2, #20
    svc 0
exit:
    mov r7, #1
    mov r0, #0
    svc 0
