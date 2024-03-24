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
# Perfect Squares
#*******************************************************************************
    li    t1, 0          # S
    li    t2, 1          # i=1
loop1:
    bgt   t2, t0, end1   # if (i > N) jump to end

    mul   t3, t2, t2     # t3 = i*i
    add   t1, t1, t3     # S = S + t3;

    addi  t2, t2, 1      # i++
    j     loop1          # jump for
end1:
    nop

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    printreg t1, __rt1
    check_saved_registers
.section .data
    N:     .word 1
