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
# sorted()
#*******************************************************************************
    la    t5, array      # load the vector address
    la    t4, size       # load the size address
    lw    t0, 0(t4)      # load the actual size
    addi  t0, t0, -1     # decrement the size 
    li    t2, 1          # result: is sorted?
loop:
    ble   t0, zero, save # if done, jump
    ld    t1, 0(t5)      # current element of the vector
    addi  t5, t5, 8      # move to the next word in the array
    ld    t6, 0(t5)      # next element of the vector
    bgt   t1, t6, break  # if the vector is not sorted, jump
    addi  t0, t0, -1     # decrement the counter controlling the number of elements yet to be checked
    j     loop
break:
    li    t2, 0          # if the vector is not sorted
save:
    la    t1, result
    sw    t2, 0(t1)
    
    
###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    print_word result
    check_saved_registers
.section .data
    size:   .word  8                  # size of the array        
    array:  .dword 1,2,3,4,5,6,7,8    # array of long integers
    result: .word  -1                 # store the result
