#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_leaf

    # chiama issorted
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal  ra, issorted

    # print results
    printreg a0, __ra0

    # check whether the saved registers are preserved
    check_saved_registers

###ANSWER###
################################################################################
# Procedure issorted
#   Input:  a0 = array, a1 = size
#   Output: a0 = 1 if the array is sorted, 0 otherwise
################################################################################
issorted:  
  beq a1, zero, issorted_return1

  li t0, 1                # idx
  lw t1, 0(a0)            # t1 contiene last

  issorted_loop:
    beq t0, a1, issorted_return1
    addi a0, a0, 4
    lw t2, 0(a0)
    blt t2, t1, issorted_return0 
    mv t1, t2
    addi t0, t0, 1
    j issorted_loop

  issorted_return1: 
    li a0, 1
    jr ra

  issorted_return0:
    li a0, 0
    jr ra

###TESTCASE###
.section  .data
    size:  .word  10
    #array: .word  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    array: .word  3,1,6,6,23,17,9,25,2,1

