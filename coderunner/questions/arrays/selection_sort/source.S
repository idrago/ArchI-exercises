#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_nonleaf

    # chiama selection_sort
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal  ra, selection_sort

    # print results
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal __print_array

    # check whether the saved registers are preserved
    check_saved_registers

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
    exit_required_leaf_function
    jr   ra

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

###ANSWER###
################################################################################
# Procedure selection_sort
#   Input:  a0 = array, a1 = size
#   Output: none
################################################################################
selection_sort:
	bne	a1,zero, selection_sort_continue
	ret
selection_sort_continue:
	addi sp,sp,-32
	sd	ra,24(sp)
	sd  s0,16(sp)
	sd  s1,8(sp)

	mv	s1,a0
	mv	s0,a1
	call minarray

	mv	a2,a0
	li	a1,0
	mv	a0,s1
	call swap

	addi a1,s0,-1
	addi a0,s1,4
	call selection_sort

	ld	 ra,24(sp)
	ld	 s0,16(sp)
	ld	 s1,8(sp)
	addi sp,sp,32
	jr	ra

###TESTCASE###
.section .data
    size:  .word 8
    array: .word 1,5,3,7,2,6,4,8

