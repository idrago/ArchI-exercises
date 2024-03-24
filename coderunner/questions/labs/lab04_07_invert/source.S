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
# invert()
#*******************************************************************************
    la    t0, array      # load the vector address

    la    t1, size       # load the size address
    lw    t1, 0(t1)      # load the actual size
    addi  t1, t1, -1     # decrement the size
    slli  t1, t1, 3      # multiply the size-1 by 8
    add   t1, t0, t1     # calculate the off-set address 

LOOP_invert:
    ble   t1, t0, END_invert  # if s2 < s1 goto end

    ld    t2, 0(t0)      # load the element in the address t0
    ld    t3, 0(t1)      # load the element in the address t1
    sd    t3, 0(t0)      # store the element in the address t0
    sd    t2, 0(t1)      # store the element in the address t1

    addi  t0, t0, 8      # increment the address t0
    addi  t1, t1, -8     # decrement the address t1
    j     LOOP_invert
END_invert:
    
###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    print_array_double array size
    check_saved_registers
.section .data
    size:   .word  8                  # size of the array        
    array:  .dword 1,2,3,4,5,6,7,8    # array of long integers
