#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_leaf

      # call serief
      la    a0, num
      lw    a0, 0(a0)
      jal   ra, serief
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers


###ANSWER###
#*******************************************************************************
# serief()
# f(1) = 1
# f(2) = 1
# f(3) = 1
# f(x) = f(x-1) + f(x-2) + f(x-3), for (x > 3)
#*******************************************************************************
serief:
      li    t0, 3
      bgt   a0, t0, serief_recursion
      li    a0, 1
      ret

serief_recursion:
      addi sp, sp, -24
      sd   ra, 0(sp)
      sd   s2, 8(sp)
      sd   s1, 16(sp)

      # f(x-1)
      addi  s2, a0, 0
      addi  a0, s2, -1
      jal   ra, serief
      add   s1, a0, zero

      # f(x-2)
      addi  a0, s2, -2
      jal   ra, serief
      add   s1, s1, a0

      # f(x-3)
      addi  a0, s2, -3
      jal   ra, serief
      add   a0, s1, a0

      ld   ra, 0(sp)
      ld   s2, 8(sp)
      ld   s1, 16(sp)
      addi sp, sp, 24
      ret

###TESTCASE###
.section .data
      num: .dword 10
