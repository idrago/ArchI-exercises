#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_leaf

    # chiama swap
    la   a0, array
    la   a1, x
    lw   a1, 0(a1)
    la   a2, y
    lw   a2, 0(a2)
    jal  ra, swap

    # print results
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal __print_array

    # check whether the saved registers are preserved
    check_saved_registers

###ANSWER###
################################################################################
# Procedure swap(array, x, y)
# a0  -> address of array
# a1 -> index x
# a2 -> index y
# does not return anything
################################################################################
swap:
      slli  a1, a1, 2     # calculates offset of x
      slli  a2, a2, 2     # calculates offset of y
      add   t0, a0, a1    # address of array[x]
      add   t1, a0, a2    # address of array[y]

      lw    t2, 0(t0)     # swap the values
      lw    t3, 0(t1)
      sw    t3, 0(t0)
      sw    t2, 0(t1)
      ret                 # return

###TESTCASE###
.section .data
    size:  .word 8
    array: .word 1,5,3,7,2,6,4,8
    x:     .word 0
    y:     .word 1
