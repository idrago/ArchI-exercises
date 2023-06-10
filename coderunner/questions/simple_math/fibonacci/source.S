#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_leaf

      # call fib
      la    a0, num
      ld    a0, 0(a0)
      jal   ra, fib
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers

###ANSWER###
################################################################################
# Procedure fib(n) - Recursive Fibonacci
# a0 -> element to compute: note fib(0) = 0, fib(1) = 1
################################################################################
fib:
        beq  a0, zero, fib_end       # special case n = 0 --> result = 0
        addi t0, zero, 1
        beq  a0, t0, fib_end         # special case n = 1 --> result = 1

        # general case n > 1
        addi sp, sp, -16             # create space in stack to save 2 registers
        sd   ra, 0(sp)               # save ra
        sd   a0, 8(sp)               # save parameter

        addi a0, a0, -1              # compute n-1
        jal  fib                     # compute fib(n-1)
        ld   t0, 8(sp)               # recover n from stack
        sd   a0, 8(sp)               # since I will not need n again, save fib(n-1) in place of n
        addi a0, t0, -2              # compute n-2
        jal  fib                     # compute fib(n-2)

        ld   t0, 8(sp)               # restore from stack fib(n-1)
        add  a0, a0, t0              # compute fib(n) = fib(n-1) + fib(n-2)
        ld   ra, 0(sp)               # restore the return address
        addi sp, sp, 16              # restore the stack pointer
fib_end:
        ret


###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
      num: .dword 10

