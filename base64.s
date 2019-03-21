.code 32
.section .rodata
ch64: .ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

.section .bss
.lcomm buffer48, 48
.lcomm buffer64, 64

.section .text

.global base64_encode
.global base64_decode
.global base64_encode_file
.global base64_decode_file

@ int base64_encode(char *d, char *s, int len)
base64_encode:
    push {r3-r7}
    ldr r6, =ch64
    mov r7, r0
be_cycle:
    ldrb r3, [r1]
    lsr r4, r3, #2
    ldrb r4, [r6, r4]
    strb r4, [r0]

    add r0, r0, #1
    add r1, r1, #1
    subs r2, r2, #1
    moveq r4, #0
    ldrneb r4, [r1]

    and r3, r3, #3
    lsl r3, r3, #4
    lsr r5, r4, #4
    orr r3, r3, r5
    ldrb r3, [r6, r3]
    strb r3, [r0]

    add r0, r0, #1
    add r1, r1, #1
    beq be_store2
    subs r2, r2, #1
    moveq r3, #0
    ldrneb r3, [r1]

    and r4, r4, #15
    lsl r4, r4, #2
    lsr r5, r3, #6
    orr r4, r4, r5
    ldrb r4, [r6, r4]
    strb r4, [r0]

    add r0, r0, #1
    add r1, r1, #1
    beq be_store1

    and r3, r3, #0x3f
    ldrb r3, [r6, r3]
    strb r3, [r0]

    add r0, r0, #1
    subs r2, r2, #1
    beq be_exit
    bne be_cycle
be_store2:
    mov r3, #'='
    strb r3, [r0]
    add r0, r0, #1
be_store1:
    mov r3, #'='
    strb r3, [r0]
    add r0, r0, #1
be_exit:
    sub r0, r0, r7
    pop {r3-r7}
    mov pc, lr

@ int base64_decode(char *d, char *s, int len)
base64_decode:
    push {r3-r6,lr}
    mov r3, r0
    mov r6, r0
bd_cycle:
    ldrb r0, [r1]
    bl char_decode
    add r1, r1, #1

    lsl r4, r0, #2
    ldrb r0, [r1]
    bl char_decode
    add r1, r1, #1

    lsr r5, r0, #4
    orr r4, r4, r5
    strb r4, [r3]
    add r3, r3, #1

    lsl r4, r0, #4
    ldrb r0, [r1]
    cmp r0, #'='
    beq exit
    bl char_decode
    add r1, r1, #1

    lsr r5, r0, #2
    orr r4, r4, r5
    strb r4, [r3]
    add r3, r3, #1

    lsl r4, r0, #6
    ldrb r0, [r1]
    cmp r0, #'='
    beq exit
    bl char_decode
    add r1, r1, #1

    orr r4, r4, r0
    strb r4, [r3]
    add r3, r3, #1
    subs r2, r2, #4
    bne bd_cycle
exit:
    sub r0, r3, r6
    pop {r3-r6, pc}

@ char char_decode(char c)
char_decode:
    subs r0, r0, #'A'
    blt cd_digit
    cmp r0, #25
    subgt r0, r0, #6
    mov pc, lr
cd_digit:
    adds r0, r0, #17
    blt cd_ps
    add r0, r0, #52
    mov pc, lr
cd_ps:
    cmn r0, #5
    moveq r0, #62
    movne r0, #63
    mov pc, lr

@ int base64_encode_file(int ifd, int ofd)
base64_encode_file:
    push {r2,r3,r4,r7,lr}
    mov r3, r0
    mov r4, r1
bef_cycle:
    mov r7, #3
    mov r0, r3
    ldr r1, =buffer48
    mov r2, #48
    svc 0

    cmp r0, #0
    blt bef_exit

    mov r2, r0
    ldr r0, =buffer64
    ldr r1, =buffer48
    bl base64_encode

    cmp r0, #64

    mov r2, r0
    mov r7, #4
    mov r0, r4
    ldr r1, =buffer64
    svc 0

    beq bef_cycle
bef_exit:
    pop {r2,r3,r4,r7,pc}

@ int base64_decode_file(int ifd, int ofd)
base64_decode_file:
    push {r2,r3,r4,r7,lr}
    mov r3, r0
    mov r4, r1
bdf_cycle: 
    mov r7, #3
    mov r0, r3
    ldr r1, =buffer64
    mov r2, #64
    svc 0

    cmp r0, #0
    blt bdf_exit

    mov r2, r0
    ldr r0, =buffer48
    ldr r1, =buffer64
    bl base64_decode

    cmp r0, #48

    mov r2, r0
    mov r7, #4
    mov r0, r4
    ldr r1, =buffer48
    svc 0

    beq bdf_cycle
bdf_exit:
    pop {r2,r3,r4,r7,pc}
