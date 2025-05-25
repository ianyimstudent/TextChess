.data
	chessBoard:	.asciiz "     a b c d e f g h     \n   -------------------   \n 8 | r n b q k b n r | 8 \n 7 | p p p p p p p p | 7 \n 6 |                 | 6 \n 5 |                 | 5 \n 4 |                 | 4 \n 3 |                 | 3 \n 2 | P P P P P P P P | 2 \n 1 | R N B Q K B N R | 1 \n   -------------------   \n     a b c d e f g h\n\n"
	firstPrompt:	.asciiz "Prompt with start position to end position.\n\tFor example: e2e4(e4)\n"
	secondPrompt:	.asciiz "\tSome of the invalid instruction would be error messaged\n"
	thirdPrompt:	.asciiz "\tEspecially castling and check and checkmate has not been made\n\n"
	whitePrompt:	.asciiz "White to Move(* to exit): "
	blackPrompt:	.asciiz "Black to Move(* to exit): "
	moveMsg:	.asciiz "Move number: "
	errorMsg:	.asciiz "Invalid Input, re-input: "
	endMsg:		.asciiz "Game over\n"
	input:		.asciiz ""
	
.text  					

main:
	li	$v0, 4			# print_str()
	la	$a0, chessBoard		# chessBoard
	syscall 
	
	li	$v0, 4			# print_str()
	la	$a0, firstPrompt	# firstPrompt
	syscall 
	
	li	$v0, 4			# print_str()
	la	$a0, secondPrompt	# secondPrompt
	syscall 
	
	li	$v0, 4			# print_str()
	la	$a0, thirdPrompt	# thirdPrompt
	syscall 
	
	li	$s1, 0			# s1 = 0
	
	j	loop
	
loop:
	li	$v0, 4			# print_str()
	la	$a0, whitePrompt	# whitePrompt
	syscall 
	
	jal	readInput		# readInput()
	
	li	$v0, 4			# print_str()
	la	$a0, chessBoard		# chessBoard
	syscall 
	
	li	$s0, 1			# currentPlayer(s0) = 1(white)
	jal 	movePiece		# movePiece()
	
	addi	$s1, $s1, 1		# s1++
	
	li	$v0, 4			# print_str()
	la	$a0, moveMsg		# moveMsg
	syscall 
	
	li	$v0, 1			# print_int()
	addu	$a0, $zero, $s1		# s1
	syscall
	
	li	$v0, 11			# print_char()
	li	$a0, '\n'		# '\n'
	syscall 
	
	li	$v0, 4			# print_str()
	la	$a0, blackPrompt	# blackPrompt
	syscall 
	
	jal	readInput		# readInput()
	
	li	$v0, 4			# print_str()
	la	$a0, chessBoard		# chessBoard
	syscall 
	
	li	$s0, 0			# currentPlayer(s0) = 0(black)
	jal 	movePiece		# movePiece()
	
	addi	$s1, $s1, 1		# s1++
	
	li	$v0, 4			# print_str()
	la	$a0, moveMsg		# moveMsg
	syscall 
	
	li	$v0, 1			# print_int()
	addu	$a0, $zero, $s1		# s1
	syscall
	
	li	$v0, 11			# print_char()
	li	$a0, '\n'		# '\n'
	syscall 
	
	j	loop

readInput:
	#standard prologue
	addiu  	$sp, $sp, -24
	sw     	$fp, 0($sp)
	sw     	$ra, 4($sp)
	addiu  	$fp, $sp, 20
	
	li	$v0, 8			# read_str()
	la	$a0, input		# save to input
	li	$a1, 5			# length 4 max(excluding null)
	syscall
	
	li	$v0, 11			# print_char()
	li	$a0, '\n'		# '\n'
	syscall 
	
	li	$v0, 11			# print_char()
	li	$a0, '\n'		# '\n'
	syscall 
	
	j	END
	
decodeInput:
	# standard prologue
	addiu  	$sp, $sp, -24
	sw     	$fp, 0($sp)
	sw     	$ra, 4($sp)
	addiu  	$fp, $sp, 20
	
	jal	isValidInput		# isValidInput()
	beq	$v0, $zero, END		# if(v0 == 0), END
	
	li	$v0, 57			# v0 = 57
	
	la	$t0, input		# t0 = &input
	lb	$t1, 0($t0)		# t1 = input.charAt(0)
	
	beq	$t1, '*', exit		# if(t1 == '*'), exit
	
	subi	$t1, $t1, 'a'		# t1 -= 'a'
	add 	$t1, $t1, $t1		# t1 *= 2
	add	$v0, $v0, $t1		# v0 += t1
	
	lb	$t1, 1($t0)		# t1 = input.charAt(1)
	li	$t5, '8'		# t5 = '8'
	sub	$t1, $t5, $t1		# t1 = '8' - t1
	add	$t1, $t1, $t1		# t1 *= 2
	add	$t2, $t1, $t1		# t2 = t1 + t1
	add	$t2, $t2, $t2		# t2 += 2
	add	$v0, $v0, $t1 		# v0 += t1
	add	$v0, $v0, $t2		# v0 += t2
	add	$v0, $v0, $t2		# v0 += t2
	add	$v0, $v0, $t2		# v0 += t2
	
	li	$v1, 57			# v0 = 57
		
	lb	$t1, 2($t0)		# t1 = input.charAt(2)
	subi	$t1, $t1, 'a'		# t1 -= 'a'
	add 	$t1, $t1, $t1		# t1 *= 2
	add	$v1, $v1, $t1		# v1 += t1
	
	lb	$t1, 3($t0)		# t1 = input.charAt(3)
	li	$t5, '8'		# t5 = '8'
	sub	$t1, $t5, $t1		# t1 = '8' - t1
	add	$t1, $t1, $t1		# t1 *= 2
	add	$t2, $t1, $t1		# t2 = t1 + t1
	add	$t2, $t2, $t2		# t2 *= 2
	add	$v1, $v1, $t1 		# v1 += t1
	add	$v1, $v1, $t2		# v1 += t2
	add	$v1, $v1, $t2		# v1 += t2
	add	$v1, $v1, $t2		# v1 += t2
	
	j	END
	
movePiece:
	# standard prologue
	addiu  	$sp, $sp, -24
	sw     	$fp, 0($sp)
	sw   	$ra, 4($sp)
	addiu 	$fp, $sp, 20
	
	jal	decodeInput		# decodeInput()
	beq	$v0, $zero, END		# if(v0 == 0), END
	
	la	$t0, chessBoard		# t0 = &chessBoard
	add	$t1, $t0, $v0		# t1 = t0 + v0
	add	$t2, $t0, $v1		# t2 = t0 + v1
	
	lb	$t3, 0($t1)		# t3 = t1
	lb	$t4, 0($t2)		# t4 = t2
	
	beq	$t3, ' ', errorExit	# if(t3 == ' '), errorExit
	
	slti	$t5, $t3, 'Z'		# t5 = t3 < 'Z'
	bne	$t5, $s0, errorExit	# if(t5 != s0), errorExit
	
	beq	$t4, ' ', capture	# if(t4 == ' '), capture
	slti	$t5, $t4, 'Z'		# t5 = t4 < 'Z'
	beq	$t5, $s0, errorExit	# if(t5 == s0), errorExit
	
	j	capture

capture:
	li 	$t4, ' '		# t4 = ' '
	sb	$t3, 0($t2) 		# &t2 = t3
	sb	$t4, 0($t1)		# &t1 = t4
	
	li	$v0, 4			# print_str()
	la	$a0, chessBoard		# chessBoard
	syscall 
	
	j	END
		
isValidInput:
	# standard prologue
	addiu  	$sp, $sp, -24
	sw     	$fp, 0($sp)
	sw     	$ra, 4($sp)
	addiu  	$fp, $sp, 20
	
	la	$t0, input		# t0 = &input
	lb	$t1, 0($t0)		# t1 = input.charAt(0)
	
	li	$v0, 1			# v0 = 1
	beq	$t1, '*', END		# if(t1 == '*'), END
	
	li	$v0, 0			# v0 = 0
	slti	$t2, $t1, 'a'		# t2 = t1 < 'a'
	bne	$t2, $zero, errorExit	# if(t2), errorExit
	
	slti	$t2, $t1, 'i'		# t2 = t1 < 'i'
	beq	$t2, $zero, errorExit	# if(!t2), errorExit
	
	lb	$t1, 1($t0)		# t1 = input.charAt(1)
	
	slti	$t2, $t1, '1'		# t2 = t1 < '1'
	bne	$t2, $zero, errorExit	# if(t2), errorExit
	
	slti	$t2, $t1, '9'		# t2 = t1 < '9'
	beq	$t2, $zero, errorExit	# if(!t2), errorExit
	
	lb	$t1, 2($t0)		# t1 = input.charAt(2)
	
	slti	$t2, $t1, 'a'		# t2 = t1 < 'a'
	bne	$t2, $zero, errorExit	# if(t2), errorExit		
	
	slti	$t2, $t1, 'i'		# t2 = t1 < 'i'
	beq	$t2, $zero, errorExit	# if(!t2), errorExit
	
	lb	$t1, 3($t0)		# t1 = input.charAt(3)
	
	slti	$t2, $t1, '1'		# t2 = t1 < '1'
	bne	$t2, $zero, errorExit	# if(t2), errorExit
	
	slti	$t2, $t1, '9'		# t2 = t1 < '9'
	beq	$t2, $zero, errorExit	# if(!t2), errorExit	
	
	li	$v0, 1			# v0 = 1
	j	END

errorExit:
	li	$v0, 4			# print_str()
	la	$a0, errorMsg		# errorMsg
	syscall
	
	jal	readInput		# readInput()
	jal	movePiece		# movePiece()
	
	li	$v0, 0			# return 0
	
	# standard epilogue
	lw     	$ra, 4($sp)
	lw     	$fp, 0($sp)
	addiu  	$sp, $sp, 24
	jr     	$ra
			
END:	
	# standard epilogue
	lw     	$ra, 4($sp)
	lw     	$fp, 0($sp)
	addiu  	$sp, $sp, 24
	jr     	$ra
	
exit:
	li	$v0, 4			# print_str()
	la	$a0, endMsg		# endMsg
	syscall
	
	
	li	$v0, 10			# System.exit(0)
	syscall
