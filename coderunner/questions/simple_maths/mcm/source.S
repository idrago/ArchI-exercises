#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_nonleaf

      # call MCM
      la    a0, num1
      la    a1, num2
      ld    a0, 0(a0)
      ld    a1, 0(a1)     
      jal   ra, mcm
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers

#*******************************************************************************
# MCD(a,b)
#
# a0 -> a
# a1 -> b
#*******************************************************************************
mcd:
mcd_while:
      beq     a0, a1, mcd_end
      bge     a1, a0, mcd_else
      sub     a0, a0, a1
      j       mcd_while
mcd_else:
      sub     a1, a1, a0
      j       mcd_while
mcd_end:
      exit_required_leaf_function
      ret

###ANSWER###
#*******************************************************************************
# MCM(a,b)
#
# a0 -> a
# a1 -> b
#*******************************************************************************
mcm:
        addi    sp, sp, -16
        sd      ra, 8(sp)
        sd      s1, 0(sp)

        mul     s1, a0, a1
        jal     ra, mcd         # after this, a0 has mcd
        div     a0, s1, a0

        ld      s1, 0(sp)
        ld      ra, 8(sp)
        addi    sp, sp, 16      # restore the stack pointer
        ret

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
      num1: .dword 5
      num2: .dword 6
