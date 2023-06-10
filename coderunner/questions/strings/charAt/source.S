#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_leaf

      # call charAt
      la   a0, str
      la   a1, n
      lw   a1, 0(a1)
      jal  ra, charAt

      # check the return value
      la   a1, str
      sb   a0, 0(a1)
      addi a1, a1, 1
      sb   zero, 0(a1)
      
      la   a0, __ra0
      jal  __printstr
      la   a0, str
      call __printstr
      la   a0, __nl
      call __printstr

      # check whether the saved registers are preserved
      check_saved_registers

###ANSWER###
#*******************************************************************************
# charAt()
#    a0: pointer to string
#    a1: index
#*******************************************************************************
charAt:
      add  a0, a0, a1
      lbu  a0, 0(a0)
      ret

###TESTCASE###
.section .data
    str: .ascii "Hello World!"
    n:   .word   5
      