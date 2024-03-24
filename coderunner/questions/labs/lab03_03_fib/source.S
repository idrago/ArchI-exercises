#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_leaf

    la   t0, N
    lw   t0, 0(t0)                # N

###ANSWER###
#*******************************************************************************
# Interactive fibonacci 
#*******************************************************************************
    li t1, 1
    li t2, 0
    li t3, 1
loop1:
    ble t0, zero, end1

    add  t1, t2, t3
    add  t2, t3, zero
    add  t3, t1, zero
    addi t0, t0, -1
    j loop1
end1:
    nop

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    printreg t1, __rt1
    check_saved_registers
.section .data
    N:     .word 1
