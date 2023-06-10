#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
    # puts numbers on the saved registers
    start_saved_registers_nonleaf

    # call isnumber
    la   a0, numstr
    jal  ra, isnumber
    printreg a0, __ra0

    # check whether the saved registers are preserved
    check_saved_registers

#*******************************************************************************
# digit
#
# a0 - char
#*******************************************************************************
digit:
    li t0, 48
    li t1, 57
    blt a0, t0, return_0
    bgt a0, t1, return_0
    li a0, 1
    exit_required_leaf_function
    ret
return_0:
    li a0, 0
    exit_required_leaf_function
    ret


###ANSWER###
#*******************************************************************************
# isnumber
#
# a0 -> d
#*******************************************************************************
isnumber:
    addi sp, sp, -24
    sd ra, 0(sp)
    sd a0, 8(sp)
    sd s1, 16(sp)
    li s1, 0
loop_on_string:
    lbu a0, 0(a0)
    beq a0, zero, isnum_return_1
    jal digit
    beq a0, zero, isnum_return_0
    ld a0, 8(sp)
    addi s1, s1, 1
    add a0, a0, s1
    j loop_on_string
isnum_return_0:
    li a0, 0
    j isnumber_return
isnum_return_1:
    li a0, 1
isnumber_return:
    ld ra, 0(sp)
    ld s1, 16(sp)
    addi sp, sp, 24
    ret

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
    numstr: .string "1234567890"


