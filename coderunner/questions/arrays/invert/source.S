#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:    
    # puts numbers on the saved registers
    start_saved_registers_nonleaf

    # chiama invert
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal  ra, invert

    # print results
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal __print_array

    # check whether the saved registers are preserved
    check_saved_registers

################################################################################
# Procedure swap(v, x, y)
# a0  -> address of v
# a1 -> index x
# a2 -> index y
# does not return anything
################################################################################
swap:
      slli  a1, a1, 2     # calculates offset of x
      slli  a2, a2, 2     # calculates offset of y
      add   t0, a0, a1    # address of v[x]
      add   t1, a0, a2    # address of v[y]

      lw    t2, 0(t0)     # sway the values
      lw    t3, 0(t1)
      sw    t3, 0(t0)
      sw    t2, 0(t1)
      
      exit_required_leaf_function
      ret                 # return

###ANSWER###
################################################################################
# Procedure invert(v)
# a0 -> v address
# a1 -> v size
################################################################################
invert:
      addi  sp, sp, -32
      sd    ra, 0(sp)
      sd    a0, 8(sp)
      sd    s1, 16(sp)
      sd    s2, 24(sp)

      addi  s1, zero, 0         # index of first element
      addi  s2, a1, -1          # index of last element
LOOP_invert:
      blt   s2, s1, END_invert  # if s2 < s1 goto end

      ld    a0, 8(sp)
      add   a1, s1, zero
      add   a2, s2, zero
      jal   ra, swap
      addi  s1, s1, 1
      addi  s2, s2, -1
      j     LOOP_invert
END_invert:

      ld    ra, 0(sp)           # restore the return address
      ld    s1, 16(sp)
      ld    s2, 24(sp)
      addi  sp, sp, 32          # restore the stack pointer
      ret

###TESTCASE###
.section .data
    size:  .word 8
    array: .word 1, 2, 3, 4, 5, 6, 7, 8
