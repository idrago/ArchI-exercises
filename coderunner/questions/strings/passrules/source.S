#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_nonleaf

      # call passrules
      la   a0, buffer
      jal  ra, passrules
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers

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
      exit_required_leaf_function
      ret
contains_zero:
      li    a0, 0                    # not found, return
      exit_required_leaf_function
      ret


###ANSWER###
#*******************************************************************************
# passrules
#
# a0 - str
#*******************************************************************************
passrules:
      addi  sp, sp, -24
      sd    ra, 0(sp)
      sd    a0, 8(sp)
      sd    s0, 16(sp)

      li    a1, 'A'
      li    a2, 'Z'
      jal   ra, contains
      add   s0, a0, zero

      ld    a0, 8(sp)
      li    a1, '0'
      li    a2, '9'
      jal   ra, contains

      and   a0, a0, s0

      ld    ra, 0(sp)
      ld    s0, 16(sp)
      addi  sp, sp, 24
      ret


###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
      buffer: .string  "BADPass4"


