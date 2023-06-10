#include "support.S"

###GLOBALEXTRA###
.section .rodata
.align 2
__varname: .string "dststr: "

.section .text

#*******************************************************************************
# main()
#*******************************************************************************
_start:
      # puts numbers on the saved registers
      start_saved_registers_nonleaf

      # call strcpy
      la   a0, srcstr
      la   a1, dststr
      jal  ra, strcpy

      # print the result
      la   a0, __varname
      jal __printstr
      la   a0, dststr
      jal __printstr
      la   a0, __nl
      jal __printstr

      # check whether the saved registers are preserved
      check_saved_registers
      
#*******************************************************************************
# strlen
# a0 - str
#*******************************************************************************
strlen:
      add  t0, zero, zero
strlen_loop:
      add  t1, t0, a0    
      lbu  t1, 0(t1)     
      beq  t1, zero, strlen_end
      addi t0, t0, 1 
      j    strlen_loop
strlen_end:
      addi a0, t0, 0
      exit_required_leaf_function
      ret       

###ANSWER###
################################################################################
# strcpy
# a0 = char *dst
# a1 = const char *src
################################################################################
strcpy:
      addi sp, sp, -32
      sd   ra, 0(sp)
      sd   a0, 8(sp)
      sd   a1, 16(sp)
      sd   s1, 24(sp)

      jal  ra, strlen            # strlen src
      add  s1, a0, zero          # s1 = n

      ld   a0, 16(sp)            # strlen dst
      jal  ra, strlen
      add  t0, a0, zero          # t0 = m -> assuming m > n
      sub  t1, t0, s1	         # t1 = m-n

      ld   a0, 8(sp)             # recover a0
      ld   a1, 16(sp)            # recover a1
STRCPY_L1:
      beq  t0, zero, STRCPY_L4   # done if i == m
      ble  t0, t1, STRCPY_L2     # if i > n then put a \0
      lbu  t2, 0(a0)             # dereference str[i]
      sb   t2, 0(a1)             # str[i] -> dst[i]
      addi a0, a0, 1             # increment a0
      j    STRCPY_L3
STRCPY_L2:                       # else put a \0
      sb   zero, 0(a1)
STRCPY_L3:
      addi a1, a1, 1             # increment the other registers
      addi t0, t0, -1
      j    STRCPY_L1             # loop

STRCPY_L4:
      ld   s1, 24(sp)
      ld   ra, 0(sp)
      addi sp, sp, 32
      ret

###TESTCASE###
# Markup for moodle - where the testcode will be inserted
# Text in this zone will be replaced by the content of the test case
.section .data
    srcstr: .string  "string to be copied"
    dststr: .string  "destination string is long enough"
