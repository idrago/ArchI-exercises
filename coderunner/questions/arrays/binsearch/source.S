#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_leaf

    # chiama binsearch
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    la   a2, needle
    lw   a2, 0(a2)
    jal  ra, binsearch
    printreg a0, __ra0

    # check whether the saved registers are preserved
    check_saved_registers

###ANSWER###
################################################################################
# Procedure binsearch(v, n, x)
# a0 -> v address
# a1 -> v size
# a2 -> x
################################################################################
binsearch:
    addi    t1, zero, 0  # left = 0
    addi    t2, a1, -1   # right = size - 1
    add     t3, zero, -1 # return value
    
binsearch_loop: # while loop
    bgt     t1, t2, binsearch_exit   # left > right, break
    add     t0, t1, t2   # mid = left + right
    srai    t0, t0, 1    # mid = (left + right) / 2

    # Get the element at the midpoint
    slli    t4, t0, 2    # Scale the midpoint by 4
    add     t4, a0, t4   # Get the memory address of arr[mid]
    lw      t4, 0(t4)    # Dereference arr[mid]

    # See if the needle (a2) > arr[mid]
    ble     a2, t4, binsearch_left
    # If we get here, then the needle is > arr[mid]
    addi    t1, t0, 1    # left = mid + 1
    j       binsearch_loop
binsearch_left:
    bge     a2, t4, binsearch_found
    # If we get here, then needle < arr[mid]
    addi    t2, t0, -1   # right = mid - 1
    j       binsearch_loop
binsearch_found:
    # If we get here, then needle == arr[mid]
    addi    t3, t0, 0

binsearch_exit:
    addi    a0, t3, 0
    ret

###TESTCASE###
.section .data
    needle: .word 10
    size:   .word 8
    array:  .word 1,2,3,7,9,10,11,15
