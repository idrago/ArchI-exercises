#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_leaf

###ANSWER###
#*******************************************************************************
# max3()
#*******************************************************************************
    la    t4, x          # get the x address
    lw    t0, 0(t4)      # copy the first word
    lw    t1, 4(t4)	     # copy the second word
    lw    t2, 8(t4)	     # copy the third word

    add   t3, zero, t0   # this will hold the max among the three

    bge   t3, t1, skip1  # check whether t1 < t0
    add   t3, zero, t1   # if t1 > t0, hold t1
skip1:
    bge   t3, t2, skip2  # check whether t2 < max(t1, t0)
    add   t3, zero, t2   # if t2 > max(t1, t0), hold t2
skip2:
    sw    t3, 12(t4)
    
###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    print_word result
    check_saved_registers
.section .data
    x: .word 1
    y: .word 2
    z: .word 3
    result: .word 0
