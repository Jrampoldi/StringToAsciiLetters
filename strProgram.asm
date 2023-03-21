#####################################################################
# Program: Enter String.	Programmer: Jourdan Rampoldi
# Last Modified: 03/ 21/ 2023
#####################################################################
# Functional Description: This program allows users to input a word and 
# will print out all letters of that word. Any characters that do not that 
# condition will not be printed. 
#####################################################################
# Pseudocode:
# string word = "";
# cin >> word;
# int i = 0;
# while (word[i] != 0)
#{
#	if (word[i] < maxVal && word[i] < midLow && word[i] > midMax && word[i] > lowVal)
#	{
#		cout << word[i];
#	}
#	i += 1;
#}
#
######################################################################
# Register Usage:
# $v0: pass sys code
# $a0: pass args
# $s0: hold address of usrWrd var
# $t0: address to manipulate for usrWrd
# $t4: load byte information for comparison
# $s2: hold maxVal byte information
# $s3: hold lowVal byte information
# $s4: hold midMax byte information
# $s5: hold midLow byte information
######################################################################
.data
	prnt2usr:	.asciiz "Please enter a sentence (max 100 char): "
	ltrfnd:		.asciiz "\nHere is your string with only the alphabet: "
	usrWrd:		.space 100				# var for user entry of string
	lowVal:		.byte 0x41				# hex val for A (lowest value of ascii letters)
	maxVal:		.byte 0x7A				# hex val for z (highest value of asscii letters)
	midMax:		.byte 0x61
	midLow:		.byte 0x5A

.text
	main:							# main procedure
		li	$v0, 4					# print_string sys code
		la	$a0, prnt2usr				# load address of user msg
		syscall

		li	$a1, 100

		li	$v0, 8					# read_string sys code
		la	$a0, usrWrd				# load address of string input var
		syscall
		
		li	$v0, 4					# print_string sys code
		la	$a0, ltrfnd
		syscall
		
		la	$s0, usrWrd				# move address to different reg to manipulate

# ---------------------------------------- done with read string ------------------------------------------------------- #

		move	$t0, $s0				# move address of user string to loop through
		lb	$s2, maxVal				# load max value of ascii for comparison
		lb	$s3, lowVal				# load min value of ascii for comparison
		lb	$s4, midMax				# load middle max values of special char
		lb	$s5, midLow				# load middle min values of special char
		
	loop:
		lb	$t4, 0($t0)				# load byte address into temp reg to loop through (usr wrd)

		beqz	$t4, done				# test for end of string

		addi	$t0, $t0, 1				# usrwrd[ + 1]

		bgt	$t4, $s2, loop				# break if not char (high)
		blt	$t4, $s3, loop				# break if not char (low)

		slt	$t5, $s5, $t4				# char > mid low
		slt	$t6, $t4, $s4				# char < mid max

		and	$t7, $t5, $t6				# both conditions true?

		bnez	$t7, loop				# branch to loop if conditions are true

# -------------------------------------- done with if statements ------------------------------------------------------- #
		

		li	$v0, 11					# passes if statements, then print char
		lb	$a0, -1($t0)				# use last char before $t0++
		syscall

		j	loop					# loop to find more
		
		
	done: 							# procedure to terminate program


		li	$v0, 10					# terminate prog sys code
		syscall
