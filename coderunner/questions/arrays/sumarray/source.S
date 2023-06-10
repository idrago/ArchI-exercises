#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_leaf

    # call sumarray
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal  ra, sumarray
    printreg a0, __ra0

    # check whether the saved registers are preserved
    check_saved_registers

###ANSWER###
################################################################################
# Procedure sumarray(v) - interactive sum
# a0 -> v address
# a1 -> v size
################################################################################
sumarray:
    addi  sp, sp, -8
    sd    ra, 0(sp)

    li    t0, 0                     # final sum
sumarray_loop:
    ble   a1, zero, sumarray_end    # if a1 <= 0 goto end
    lw    t1, 0(a0)                 # first element of the vector
    add   t0, t0, t1                # sum the element
    addi  a1, a1, -1                # decrement the counter
    addi  a0, a0, 4                 # move to the next word in the array
    j     sumarray_loop    

sumarray_end:
    mv    a0, t0                    # load the result
    ld    ra, 0(sp)                 # restore the return address
    addi  sp, sp, 8                 # restore the stack pointer
    ret

###TESTCASE###
.section .data
    array: .word  1,2,3,4,5,6,7,8,9,10
    size:  .word  10
