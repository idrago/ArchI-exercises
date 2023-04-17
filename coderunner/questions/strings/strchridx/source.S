#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_leaf

      # call strchridx
      la   a0, str
      la   a1, c
      lbu  a1, 0(a1)
      jal  ra, strchridx
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers

###ANSWER###
#*******************************************************************************
# strchridx
#
# a0 - str
# a1 = c
#*******************************************************************************
strchridx:
      addi t0, zero, 0
strchridx_loop:      
      lbu  t1, 0(a0)
      beq  t1, a1, strchridx_end
      addi a0, a0, 1
      addi t0, t0, 1
      bne  t1, zero, strchridx_loop
      addi a0, zero, -1
      ret
strchridx_end: 
      addi a0, t0, 0
      ret

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
        str:  .string "my long string"
        c:    .byte   'g'
