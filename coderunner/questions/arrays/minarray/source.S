#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_leaf

    # chiama minarray
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal  ra, minarray

    # print results
    printreg a0, __ra0

    # check whether the saved registers are preserved
    check_saved_registers

###ANSWER###
################################################################################
# Procedure minarray
#   Input:  a0 = array, a1 = size
#   Output: a0 = min_idx
################################################################################
minarray:
  li   t0, 0     # min_idx
  lw   t1, 0(a0) # min_value
  li   t2, 1     # i

  minarray_loop:
    # check if i == size
    beq  t2, a1, minarray_end

    # check if array[i] < min
    slli t3, t2, 2
    add  t3, a0, t3
    lw   t3, 0(t3)
    bgt  t3, t1, minarray_continue

    # update min
    mv   t1, t3
    mv   t0, t2

  minarray_continue:    
    addi t2, t2, 1  # increment i
  j minarray_loop

  minarray_end:
    mv   a0, t0
    jr   ra

###TESTCASE###
.section  .data
    size:  .word  10
    array: .word  3,1,6,6,23,17,9,25,2,1

