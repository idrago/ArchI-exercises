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
    
###ANSWER###
#*******************************************************************************
# .if ... then
#*******************************************************************************
    addi  t0, t0, -2            # x = (x - 2)
    add   t0, t0, t1            # x = x + y

    bge   t0, t1, else2         # if !(x < y) jump
    addi  t0, t0, 1             # 	x = x + 1
    j     end2                  # end
else2:
    addi  t1, t1, 1             # y = y + 1
end2:
    nop

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    printreg t1, __rt1
    check_saved_registers
.section .data
    x:     .word 0
    y:     .word 1
