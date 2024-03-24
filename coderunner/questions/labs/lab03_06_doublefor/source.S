#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_leaf

    la   t0, a
    ld   t0, 0(t0)                # a
    la   t1, b
    ld   t1, 0(t1)                # b
    la   t2, R
    ld   t2, 0(t2)                # R
    
###ANSWER###
#*******************************************************************************
# doubleloop
#*******************************************************************************
    li   t3, 0           # i=0
LOOPI:
    bge  t3, t0, ENDI    # when (i>=a) jump
    li   t4, 0           # j
LOOPJ:
    bge  t4, t1, ENDJ    # when (j>=b) jump
    add  t2, t2, t2      # R=2R
    add  t5, t3, t4      # i+j
    add  t2, t2, t5      # R+=i+j
    addi t4, t4, 1       # j++
    j    LOOPJ
ENDJ:
    addi t3, t3, 1       # i++
    j    LOOPI
ENDI:
    nop

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    printreg t2, __rt2
    check_saved_registers
.section .data
    a:     .dword 1
    b:     .dword 2
    R:     .dword 3
