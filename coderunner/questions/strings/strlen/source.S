#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_leaf

      # call strlen
      la   a0, str
      jal  ra, strlen
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers


###ANSWER###
#*******************************************************************************
# strlen
#
# a0 - str
#*******************************************************************************
strlen:
      add  t0, zero, zero        # i = 0

                                 # Start of for loop
strlen_loop:
      add  t1, t0, a0            # Add the byte offset for str[i]
      lbu  t1, 0(t1)             # dereference str[i]
      beq  t1, zero, strlen_end  # if str[i] == 0, break for loop
      addi t0, t0, 1             # i++
      j    strlen_loop           # loop

strlen_end:
      addi a0, t0, 0             # Move t0 into a0 to return
      ret

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
      str: .string  "My string"


