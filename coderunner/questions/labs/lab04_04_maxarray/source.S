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
# maxarray()
#*******************************************************************************
        la    t5, array      # load the vector address
        la    t4, size       # load the size address
        lw    t0, 0(t4)      # load the actual size
        lw    t2, 0(t5)      # hold the max so far (first element)
loop:
        lw    t1, 0(t5)      # next element of the vector
        bge   t2, t1, skip1  # check whether t2 > t1
        add   t2, t1, zero   # if not t2 > t1, we update the max so far
skip1:
        addi  t5, t5, 4      # move to the next word in the array
        addi  t0, t0, -1     # decrement the counter for number of elements yet to be checked
        bne   t0, zero, loop # if not done, jump

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
