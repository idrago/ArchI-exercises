#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_leaf

      # call strlen
      la   a0, str1
      la   a1, str2
      jal  ra, strcmp
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers


###ANSWER###
#*******************************************************************************
# strcmp
#
# a0 - str1
# a1 - str2
#*******************************************************************************
strcmp:
      lbu  t1, 0(a0)                # dereference str1[i]
      lbu  t2, 0(a1)                # dereference str2[i]

      bne  t1, t2, strcmp_end       # if str2 != str1, break
      bne  t1, zero, strcmp_cont    # if str2 == str1 && str1 == \0 return 0
      add  a0, zero, zero
      ret
strcmp_cont:
      addi a0, a0, 1                # i++
      addi a1, a1, 1
      j    strcmp                  # loop

strcmp_end:
      addi a0, zero, 1              # return 1
      ret


###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
      str1: .string "first."
      str2: .string "second."


