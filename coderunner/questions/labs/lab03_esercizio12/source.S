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
# count ones in N
#*******************************************************************************
    li    t1, 1             # M
    li    t2, 0             # R
    li    t3, 64            # i
loop1:
    and   t5, t0, t1        # N & M
    add   t2, t2, t5        # R = R + N & M
    srli  t0, t0, 1         # N = N >> 1

    addi  t3, t3, -1        # i = i - 1
    ble   t3, zero, end1    # if (i<=0) end
    j     loop1	          # else continue
end1:
    nop

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    printreg t2, __rt2
    check_saved_registers
.section .data
    N:     .word 37
