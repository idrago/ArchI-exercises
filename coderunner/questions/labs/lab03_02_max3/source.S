#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_leaf

    la   t0, x
    lw   t0, 0(t0)                # x = *x
    la   t1, y
    lw   t1, 0(t1)                # y = *y
    la   t2, z
    lw   t2, 0(t2)                # z = *z
    
###ANSWER###
#*******************************************************************************
# max3()
#*******************************************************************************
    add   t3, zero, t0   # this register will hold the max
    bge   t3, t1, end1  
    add   t3, zero, t1   # if t1 > t0, hold t1
end1:
    bge   t3, t2, end2  
    add   t3, zero, t2   # if t2 > max(t1, t0), hold t2
end2:
    # t3 has the max
    nop

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    printreg t3, __rt3
    check_saved_registers
.section .data
    x:     .word 0
    y:     .word 1
    z:     .word 3
