# Help functions to control whether the exercise is correct

# syscalls codes & co
.equ __SUCCESS,     0
.equ __STDOUT,      1
.equ __WRITE,       64
.equ __EXIT,        93
.equ __STDIN,       0
.equ __SYS_READ,    63

# some constant to check calling conventions
.equ C01, 326082506895068
.equ C02, 232851651844210
.equ C03, 327600777833497
.equ C04, 301188876459044
.equ C05, 326129751535302
.equ C06, 362186001968432
.equ C07, 326651590061523
.equ C08, 408174364268937
.equ C09, 228838004907967
.equ C10, 268965884335809
.equ FLAG_CALL, 230083545423227

################################################################################
# .dss Section
################################################################################
.section .data
.align 2

# this is a flag used to check whether a support function has been called
__FUNC_FLAG:    .DWORD  0

################################################################################
# .rodata
################################################################################
.section .rodata
.align 2

# useful strings for the output
__ra0:     .string "a0: "
__ra1:     .string "a1: "
__ra2:     .string "a2: "
__ra3:     .string "a3: "
__ra4:     .string "a4: "
__ra5:     .string "a5: "
__ra6:     .string "a6: "
__ra7:     .string "a7: "
__rt0:     .string "t0: "
__rt1:     .string "t1: "
__rt2:     .string "t2: "
__rt3:     .string "t3: "
__rt4:     .string "t4: "
__rt5:     .string "t5: "
__rs0:     .string "s0: "
__rs1:     .string "s1: "
__rs2:     .string "s2: "
__rs3:     .string "s3: "
__rs4:     .string "s4: "
__rs5:     .string "s5: "
__rs6:     .string "s6: "
__rs7:     .string "s7: "
__rs8:     .string "s8: "
__rs9:     .string "s9: "
__rs10:    .string "s10: "
__rs11:    .string "s11: "
__rra:     .string "ra: "
__rsp:     .string "sp: "
__array:   .string "array = "
__nl:      .string "\n"
__space:   .string " "
__error_1: .string "The solution does not properly preserve the saved registers.\n"
__error_2: .string "The solution is not invoking the requested support function.\n"

################################################################################
# Here the generic content of the main with some supporting functions
################################################################################
.section .text
.align 2
.globl  _start

################################################################################
# mess up with the registers
################################################################################
.macro messup_temp_regs

        # mess up with temp registers
        li   t0, C01
        li   t1, C02
        li   t2, C03
        li   t3, C04
        li   t4, C05
        li   t5, C06
        li   t6, C07

        # pedantic: mess up with parameter registers
        li   a1, C01
        li   a2, C02
        li   a3, C03
        li   a4, C04
        li   a5, C05
        li   a6, C06
        li   a7, C07
.endm

################################################################################
# macro to be called when existing a non-leaf functionm
################################################################################
.macro exit_required_leaf_function

        # flag that shows this function has been called
        la   t0, __FUNC_FLAG
        li   t1, FLAG_CALL
        sd   t1, 0(t0)

        # mess up with temp registers
        messup_temp_regs
.endm

################################################################################
# put some values on the saved registers
# check whether they are preserved
################################################################################
.macro start_saved_registers_nonleaf

        # change the temp registers
        messup_temp_regs

        # change FP, GP and TP
        add  fp,  sp, zero
        add  gp,  sp, zero
        add  tp,  sp, zero

        li   s1,  C01
        li   s2,  C02
        li   s3,  C03
        li   s4,  C04
        li   s5,  C05
        li   s6,  C06
        li   s7,  C07
        li   s8,  C08
        li   s9,  C09
        li   s10, C10
        add  s11, zero, sp # this one holds SP
.endm

.macro start_saved_registers_leaf
        start_saved_registers_nonleaf
        la   t0, __FUNC_FLAG
        li   t1, FLAG_CALL
        sd   t1, 0(t0)
.endm

.macro check_saved_registers

        # check the control variable and restore the initial sp
        la   t0, __FUNC_FLAG
        ld   t0, 0(t0)
        li   t1, FLAG_CALL
        bne  t0, t1, __not_using_function

        li   t0, C01
        bne  s1, t0, __not_preserved

        li   t0, C02
        bne  s2, t0, __not_preserved

        li   t0, C03
        bne  s3, t0, __not_preserved

        li   t0, C04
        bne  s4, t0, __not_preserved

        li   t0, C05
        bne  s5, t0, __not_preserved

        li   t0, C06
        bne  s6, t0, __not_preserved

        li   t0, C07
        bne  s7, t0, __not_preserved

        li   t0, C08
        bne  s8, t0, __not_preserved

        li   t0, C09
        bne  s9, t0, __not_preserved

        li   t0, C10
        bne  s10, t0, __not_preserved

        bne  s11, sp, __not_preserved
        #printreg fp, __ra0
        #printreg gp, __ra0
        #printreg tp, __ra0
        bne  fp,  sp, __not_preserved
        bne  gp,  sp, __not_preserved
        bne  tp,  sp, __not_preserved

        j    __end_checks

__not_preserved:
        # print error message
        la a0, __error_1
        jal __printstr
        j __end_checks

__not_using_function:
        # print error message
        la a0, __error_2
        jal __printstr

__end_checks:
        j  __exit
.endm


################################################################################
# read string from STDIN
################################################################################
.macro read_string buffer MAX_CHARS
      li a0, __STDIN
      la a1, \buffer
      li a2, \MAX_CHARS
      li a7, __SYS_READ
      ecall
.endm 

################################################################################
# dump a register as decimal
################################################################################
.macro printreg reg, name
        addi  sp, sp, -8
        sd    \reg, 0(sp)

        la    a0, \name
        jal   __printstr

        ld    \reg, 0(sp)
        addi  a0, \reg, 0
        jal   __num_print

        la    a0, __nl
        jal   __printstr

        ld    \reg, 0(sp)
        addi  sp, sp, 8
.endm

################################################################################
# __num_print - print the content of a0 as decimal
################################################################################
__num_print:
        addi  sp, sp, -40      # 22 bytes for the number as ascii
        sd    ra, 0(sp)
        sd    s1, 8(sp)

        li    t0, 0            # sign_bit
        li    t1, 10           # for division

        addi  t2, sp, -40      # t2 str[0]
        sb    zero, 0(t2)      # terminator

        bge   a0, zero, 1f     # if num >= 0 go to L1 else get absolute
        xori  a0, a0, -1       # (num ^ -1)
        addi  a0, a0, 1        # num + 1
        addi  t0, zero, 1      # negative

    1:  remu  t3, a0, t1       # num % 10
        addi  t3, t3, 48       # convert to ascii
        addi  t2, t2, -1       # decrement start pointer
        sb    t3, 0(t2)        # store value

        divu  a0, a0, t1       # num /= 10
        blt   zero, a0, 1b     # if num > 0 loop

        beq   t0, zero, 1f     # if sign_bit = 0 go to print else, add '-' char
        addi  t3, zero, '-'    # ascii '-'
        addi  t2, t2, -1       # decrement start pointer
        sb    t3, 0(t2)        # store '-'

    1:
        add   a0, t2, zero
        jal   __printstr

        ld    ra, 0(sp)
        ld    s1, 8(sp)
        addi  sp, sp, 40
        ret

################################################################################
# __printstr - print str on terminal
# a0 -> str
################################################################################
__printstr:
        addi  sp, sp, -16
        sd    ra, 0(sp)
        sd    s1, 8(sp)

        add   s1, a0, zero
        jal   __strlen
        add   a2, a0, zero # length of string

        li    a0, __STDOUT
        mv    a1, s1        # string to print
        li    a7, __WRITE     # syscall number for write
        ecall

        ld    ra, 0(sp)
        ld    s1, 8(sp)
        addi  sp, sp, 16
        ret

################################################################################
# Procedure print_array(v)
# a0 -> v address of array of DWORD
# a1 -> v size of the array
################################################################################
__print_array:
        addi  sp, sp, -32
        sd    s1, 0(sp)
        sd    a0, 8(sp)
        sd    a1, 16(sp)
        sd    ra, 24(sp)

        # print help string
        la    a0, __array
        jal   __printstr
        ld    a0, 8(sp)
        ld    a1, 16(sp)

        # print the sequence of DWORD
        li    s1, 0 # index
__print_array_loop:
        beq   s1, a1, __print_array_exit

        slli  t1, s1, 2     # calculates offset in the array
        add   t1, t1, a0    # t1 has the address of the element
        lw    t0, 0(t1)     # t0 has the number to print

        addi  a0, t0, 0     # print a number
        jal   __num_print

        la    a0, __space
        jal   __printstr

        ld    a0, 8(sp)      # recover the value of a0
        ld    a1, 16(sp)     # recover the value of a1
        addi  s1, s1, 1      # move to the next DWORD
        j     __print_array_loop

__print_array_exit:
        la    a0, __nl
        jal   __printstr

        ld    s1, 0(sp)
        ld    ra, 24(sp)
        addi  sp, sp, 32
        ret

###############################################################################
# Procedure print_array_half(v)
# a0 -> v address of array of half-word
# a1 -> v size of the array
################################################################################
__print_array_half:
        addi  sp, sp, -32
        sd    s1, 0(sp)
        sd    a0, 8(sp)
        sd    a1, 16(sp)
        sd    ra, 24(sp)

        # print help string
        la    a0, __array
        jal   __printstr
        ld    a0, 8(sp)
        ld    a1, 16(sp)

        # print the sequence of half-word
        li    s1, 0 # index
__print_array_half_loop:
        beq   s1, a1, __print_array_half_exit

        slli  t1, s1, 1     # calculates offset in the array
        add   t1, t1, a0    # t1 has the address of the element
        lh    t0, 0(t1)     # t0 has the number to print

        addi  a0, t0, 0     # print a number
        jal   __num_print

        la    a0, __space
        jal   __printstr

        ld    a0, 8(sp)      # recover the value of a0
        ld    a1, 16(sp)     # recover the value of a1
        addi  s1, s1, 1      # move to the next DWORD
        j     __print_array_half_loop

__print_array_half_exit:
        la    a0, __nl
        jal   __printstr

        ld    s1, 0(sp)
        ld    ra, 24(sp)
        addi  sp, sp, 32
        ret        

################################################################################
# __strlen
# a0 -> str
# return strlen(str) on a0
################################################################################
__strlen:
        move  t0, a0
    1:  lb    t1, 0(t0)
        beqz  t1, 1f
        addi  t0, t0, 1
        j 1b
    1:  sub   a0, t0, a0
        ret

################################################################################
# exit(0)
################################################################################
__exit:
        li    a0, __SUCCESS
        li    a7, __EXIT
        ecall
