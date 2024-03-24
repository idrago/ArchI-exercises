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
# bubblesort()
#*******************************************************************************
    la    t0, array      # load the vector address
    la    t1, size       # load the size address
    lw    t1, 0(t1)      # load the actual size
    addi  t1, t1, -1     # size-1  
    li    t2, 1          # change

LOOP_bubble1:
    beq   t2, zero, END_bubble # if t2 == 0, then the array is sorted

    li    t2, 0          # reset the change flag
    mv    t3, t0         # keep the array address 
    mv    t4, t1         # keep the size

LOOP_bubble2:
    ble   t4, zero, LOOP_bubble1   # if t4 < 1, finished

    ld    t5, 0(t3)      # load the first element
    ld    t6, 8(t3)      # load the second element

    ble   t5, t6, SKIP_bubble  # first element is smaller, skip
    sd    t5, 8(t3)      # swap the elements
    sd    t6, 0(t3)
    li    t2, 1          # set the change flag

SKIP_bubble:
    addi  t4, t4, -1     # set the change flag
    add   t3, t3, 8      # increment the address
    j     LOOP_bubble2   # repeat the loop

END_bubble:
    
###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
    print_array_double array size
    check_saved_registers
.section .data
    size:   .word  8                       # size of the array        
    array:  .dword 8, 7, 6, 5, 4, 3, 2, 1  # array of double
