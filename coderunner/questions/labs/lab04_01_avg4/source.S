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
# avg4()
#*******************************************************************************
    la   t1, v1          # get the v1 address
    lw   t2, 0(t1)       # copy the first word to t2
    lw   t3, 4(t1)       # copy the second word to t3
    add  t4, t2, t3      # sum the words and save it on register t4
    lw   t3, 8(t1)       # copy the third word to t3
    add  t4, t4, t3      # sum it and save on register t4
    lw   t3, 12(t1)      # copy the fourth word to t3
    add  t4, t4, t3      # sum it and save on register t4
    srai t4, t4, 2       # shift to the right by 2 positions
    sw   t4, 16(t1)      # store the sum in the 5th word
    
###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    print_word result
    check_saved_registers
.section .data
    v1: .word 1
    v2: .word 2
    v3: .word 3
    v4: .word 4
    result: .word 0
