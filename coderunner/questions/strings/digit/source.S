#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_leaf

      # call digit
      la   a0, d
      lbu  a0, 0(a0)
      jal  ra, digit
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers

###ANSWER###
#*******************************************************************************
# digit
#
# a0 - char
#*******************************************************************************
digit:
      li t0, 48
      li t1, 57
      blt a0, t0, return_0
      bgt a0, t1, return_0
      li a0, 1
      ret
return_0:
      li a0, 0
      ret

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
      d: .byte '0'



