#include "support.S"

###GLOBALEXTRA###
#*******************************************************************************
# main()
#*******************************************************************************
_start:
	# puts numbers on the saved registers
	start_saved_registers_leaf

	# call strlen
    la   a0, numstr
    jal  ra, __strlen
	
    # call atoi
    mv   a1, a0
    la   a0, numstr
    jal  ra, atoi

	printreg a0, __ra0

	# check whether the saved registers are preserved
	check_saved_registers

###ANSWER###
#*******************************************************************************
# atoi(str, n)
# a0 - str
# a1 - n
#*******************************************************************************
atoi:
  	bne  a1, zero, go_ahead	# if (n!=0) continue
	add  a0, zero, zero
	jr   ra

go_ahead:
	addi sp, sp, -16
	sd	 ra, 0(sp)
	sd   s1, 8(sp)		
	
	addi a1, a1, -1		# n-1
	add  t0, a0, a1		# offset str[n-1]
	lbu  s1, 0(t0)		# load on s1 value on str[n-1]
	addi s1, s1, -48	# convert it to numeric value: s1=str[n-1] - '0'
	jal  atoi		    # a0 has the result of atoi(str, n-1)
	
	li 	 t0, 10
	mul  t0, t0, a0		# 10 * atoi(str, n-1)
	add  a0, s1, t0	    # atoi(str, n) = 10*atoi(str, n-1) + str[n-1] - '0'
	
	ld 	 ra, 0(sp)
	ld   s1, 8(sp)
	addi sp, sp, 16
	jr   ra

###TESTCASE###
.section .data
	numstr: .string "00011"
