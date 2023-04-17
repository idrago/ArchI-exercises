#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_leaf

      # call MCD
      la    a0, num1
      la    a1, num2
      ld    a0, 0(a0)
      ld    a1, 0(a1)     
      jal   ra, mcd
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers

###ANSWER###
#*******************************************************************************
# MCD(a,b)
#
# a0 -> a
# a1 -> b
#*******************************************************************************
mcd:
      # as we do not touch SP e FP we skip this
      # addi    sp, sp, -8    # open space for a double word
      # sd      fp, 0(sp)     # save the previous frame pointer
mcd_while:
      beq     a0, a1, mcd_end
      bge     a1, a0, mcd_else
      sub     a0, a0, a1
      j       mcd_while
mcd_else:
      sub     a1, a1, a0
      j       mcd_while
mcd_end:
      # ld      fp, 0(sp)     # restore the frame pointer
      # addi    sp, sp, 8     # restore the stack pointer
      ret

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
      num1: .dword 24
      num2: .dword 30


