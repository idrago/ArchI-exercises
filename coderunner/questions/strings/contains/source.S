#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_leaf

      # call contains
      la   a0, buffer
      la   a1, low
      la   a2, high
      lbu  a1, 0(a1)
      lbu  a2, 0(a2)
      jal  ra, contains
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers

###ANSWER###
#*******************************************************************************
# Contains
#
# a0 - str
# a1 - low
# a2 - high
#*******************************************************************************
contains:
      lbu   t1, 0(a0)                # reads a char and move pointer
      addi  a0, a0, 1

      beqz  t1, contains_zero        # string is over without find char
      blt   t1, a1, contains         # if not in range, continue
      bgt   t1, a2, contains

      li    a0, 1                    # found, return
      ret 
contains_zero:
      li    a0, 0                    # not found, return
      ret

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
      buffer: .string  "test string"
      low:    .byte  'A'
      high:   .byte  'Z'
      