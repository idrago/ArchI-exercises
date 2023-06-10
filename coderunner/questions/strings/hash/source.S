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
      jal  ra, hash
      printreg a0, __ra0

      # check whether the saved registers are preserved
      check_saved_registers

###ANSWER###
#*******************************************************************************
# hash()
#    a0: pointer to string
#*******************************************************************************
hash:
      addi  sp, sp, -40
      sd    ra, 0(sp)

      lbu   t0,0(a0)
      li    t1,5381
hash_loop:
      beq   t0,zero,hash_exit
      slli  t2,t1,5
      add   t1,t2,t1
      add   t1,t1,t0
      addi  a0,a0,1
      lbu   t0,0(a0) 
      j     hash_loop
hash_exit:
      mv    a0,t1
      ld    ra, 0(sp)
      addi  sp, sp, 40
      ret

###TESTCASE###
.section .data
    str: .string "V"
