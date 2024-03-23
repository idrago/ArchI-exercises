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
# sumarray()
#*******************************************************************************
        la    t5, array      # load the vector address
        la    t4, size       # load the size address
        lw    t0, 0(t4)      # load the actual size
        li    t2, 0          # final sum
loop:
        beq   t0, zero, save # if done, jump
        lw    t1, 0(t5)      # first element of the vector
        add   t2, t2, t1     # sum the element
        addi  t0, t0, -1     # decrement the counter controlling the number of elements yet to be checked
        addi  t5, t5, 4      # move to the next word in the array
        j     loop
save:
        la    t1, result
        sw    t2, 0(t1)
    
###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    print_word result
    check_saved_registers
.section .data
     size:   .word 16
     array:  .word 12, 2, 1, 3, 5, 1, 7, 1, -1, 4, -2, -3, 1, 9, -6, 10
     result: .word 0
