.data	
	description: .asciiz "The first player to form a diagonal, vertical or horizontal sequence wins.\n"
	occupied_msg: .asciiz "The position is occupied \n"
	invalid_msg: .asciiz "Invalid position! \n"
	player1_row_msg: .asciiz "Enter a row position player 1: \n"
	player1_column_msg: .asciiz "Enter a column position player 1: \n"
	player2_row_msg: .asciiz "Enter a row position player 2: \n"
	player2_column_msg: .asciiz "Enter a column position player 2: \n"
	player1live_msg: .asciiz "Player 1 won! \n"
	player2live_msg: .asciiz "Player 2 won! \n"
	tie: .asciiz "This game is a draw"
	size: .word 3
	space: .asciiz " "
	nextline: .asciiz "\n"
	table1: .word 0,0,0,0,0,0,0,0,0
	table2: .word 0,0,0,0,0,0,0,0,0
	table3: .byte '_','_','_','_','_','_','_','_','_'
	#table3: .word 5,5,5,5,5,5,5,5,5
.text
	 main:
		la $a1,table1
		la $a2,table2
		la $a3,table3
		
		li $s0,1      # couter for total no. of turns
	
		li $v0,4
		la $a0,description
		syscall
	
	playerx:
		bgt $s0,9,gametie
		player1:
			jal print
			li $v0,4
			la $a0,player1_row_msg
			syscall
			li $v0,5
			syscall
			move $t0,$v0
			li $v0,4
			la $a0,player1_column_msg
			syscall
			li $v0,5
			syscall
			move $t1,$v0
			
			jal validity_row
			bne $v1,1,player1
			jal validity_column
			bne $v1,1,player1
			jal valid
			bne $v1,1,player1
		
			jal execute1
			addi $s0,$s0,1
			
			jal check_win1
			beq $v1,1,end
			bne $v1,1,playery

	playery:
		bgt $s0,9,gametie
		player2:
			jal print
			li $v0,4
			la $a0,player2_row_msg
			syscall
			li $v0,5
			syscall
			move $t0,$v0
			li $v0,4
			la $a0,player2_column_msg
			syscall
			li $v0,5
			syscall
			move $t1,$v0
			
			jal validity_row
			bne $v1,1,player2
			jal validity_column
			bne $v1,1,player2
			jal valid
			bne $v1,1,player2
			
			jal execute2
			addi $s0,$s0,1
			
			jal check_win2
			beq $v1,1,end
			bne $v1,1,playerx
			
	end:	
		li $v0,10   # Main end
		syscall
		
	gametie:
		li $v0,4
		la $a0,tie
		syscall
		li $v0,10
		syscall
	
	execute1:
		li $t7,1
		li $t6,'X'
		
		mul $t2,$t0,3
		add $t2,$t2,$t1
		sll $t2,$t2,2
		add $t2,$t2,$a1
		sw $t7,($t2)
		
		li $t2,0
		
		mul $t2,$t1,3
		add $t2,$t2,$t0
		sll $t2,$t2,2
		add $t2,$t2,$a2
		sw $t7,($t2)
		
		li $t2,0
		
		mul $t2,$t0,3
		add $t2,$t2,$t1
		add $t2,$t2,$a3
		sb $t6,($t2)
		
		jr $ra
	
	execute2:
		li $t7,-1
		li $t6,'O'
	
		mul $t2,$t0,3
		add $t2,$t2,$t1
		sll $t2,$t2,2
		add $t2,$t2,$a1
		sw $t7,($t2)
		
		li $t2,0
		
		mul $t2,$t1,3
		add $t2,$t2,$t0
		sll $t2,$t2,2
		add $t2,$t2,$a2
		sw $t7,($t2)
		
		li $t2,0
		
		mul $t2,$t0,3
		add $t2,$t2,$t1
		add $t2,$t2,$a3
		sb $t6,($t2)
		
		jr $ra
	
	check_win1:
		move $t2,$a1   #base address
		li $t3,0      #sum
		li $t5,0     # counter for columns
		check_row1:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,check_row1
		check_row1_win:
			bne $t3,3,initialize_check_row2
			li $v0,4
			la $a0,player1live_msg
			syscall
			li $v1,1
			jr $ra
		initialize_check_row2:
			move $t2,$a1
			addi $t2,$t2,12  
			li $t3,0      
			li $t5,0
		check_row2:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,check_row2
		check_row2_win:
			bne $t3,3,initialize_check_row3
			li $v0,4
			la $a0,player1live_msg
			syscall
			li $v1,1
			jr $ra
		initialize_check_row3:
			move $t2,$a1
			addi $t2,$t2,24  
			li $t3,0      
			li $t5,0
		check_row3:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,check_row3
		check_row3_win:
			bne $t3,3,initialize_check_column1
			li $v0,4
			la $a0,player1live_msg
			syscall
			li $v1,1
			jr $ra
		initialize_check_column1:
			move $t2,$a2
			li $t3,0
			li $t5,0
		check_column1:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,check_column1
		check_column1_win:
			bne $t3,3,initialize_check_column2
			li $v0,4
			la $a0,player1live_msg
			syscall
			li $v1,1
			jr $ra
		initialize_check_column2:
			move $t2,$a2
			addi $t2,$t2,12  
			li $t3,0      
			li $t5,0
		check_column2:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,check_column2
		check_column2_win:
			bne $t3,3,initialize_check_column3
			li $v0,4
			la $a0,player1live_msg
			syscall
			li $v1,1
			jr $ra
		initialize_check_column3:
			move $t2,$a2
			addi $t2,$t2,24  
			li $t3,0      
			li $t5,0
		check_column3:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,check_column3
		check_column3_win:
			bne $t3,3,initialize_check_diagonal
			li $v0,4
			la $a0,player1live_msg
			syscall
			li $v1,1
			jr $ra
		initialize_check_diagonal:
			move $t2,$a2  
			li $t3,0
			li $t6,0      
		check_diagonal:
			lw $t4,($t2)
			add $t3,$t3,$t4
			add $t2,$t2,8
			lw $t4,($t2)
			add $t6,$t6,$t4
			add $t2,$t2,8
			lw $t4,($t2)
			add $t3,$t3,$t4
			add $t6,$t6,$t4
			add $t2,$t2,8
			lw $t4,($t2)
			add $t6,$t6,$t4
			add $t2,$t2,8
			lw $t4,($t2)
			add $t3,$t3,$t4
		check_diagonal1_win:
			bne $t3,3,check_diagonal2_win
			li $v0,4
			la $a0,player1live_msg
			syscall
			li $v1,1
			jr $ra
		check_diagonal2_win:
			bne $t6,3,exit3
			li $v0,4
			la $a0,player1live_msg
			syscall
			li $v1,1
			jr $ra
		exit3:
			li $v1,0
			jr $ra
			
	
	check_win2:
		move $t2,$a1   #base address
		li $t3,0      #sum
		li $t5,0     # counter for columns
		two_check_row1:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,two_check_row1
		two_check_row1_win:
			bne $t3,-3,two_initialize_check_row2
			li $v0,4
			la $a0,player2live_msg
			syscall
			li $v1,1
			jr $ra
		two_initialize_check_row2:
			move $t2,$a1
			addi $t2,$t2,12  
			li $t3,0      
			li $t5,0
		two_check_row2:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,two_check_row2
		two_check_row2_win:
			bne $t3,-3,two_initialize_check_row3
			li $v0,4
			la $a0,player2live_msg
			syscall
			li $v1,1
			jr $ra
		two_initialize_check_row3:
			move $t2,$a1
			addi $t2,$t2,24  
			li $t3,0      
			li $t5,0
		two_check_row3:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,two_check_row3
		two_check_row3_win:
			bne $t3,-3,two_initialize_check_column1
			li $v0,4
			la $a0,player2live_msg
			syscall
			li $v1,1
			jr $ra
		two_initialize_check_column1:
			move $t2,$a2
			li $t3,0
			li $t5,0
		two_check_column1:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,two_check_column1
		two_check_column1_win:
			bne $t3,-3,two_initialize_check_column2
			li $v0,4
			la $a0,player2live_msg
			syscall
			li $v1,1
			jr $ra
		two_initialize_check_column2:
			move $t2,$a2
			addi $t2,$t2,12  
			li $t3,0      
			li $t5,0
		two_check_column2:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,two_check_column2
		two_check_column2_win:
			bne $t3,-3,two_initialize_check_column3
			li $v0,4
			la $a0,player2live_msg
			syscall
			li $v1,1
			jr $ra
		two_initialize_check_column3:
			move $t2,$a2
			addi $t2,$t2,24  
			li $t3,0      
			li $t5,0
		two_check_column3:
			lw $t4,($t2)
			add $t3,$t3,$t4
			addi $t2,$t2,4
			addi $t5,$t5,1
			blt $t5,3,two_check_column3
		two_check_column3_win:
			bne $t3,-3,two_initialize_check_diagonal
			li $v0,4
			la $a0,player2live_msg
			syscall
			li $v1,1
			jr $ra
		two_initialize_check_diagonal:
			move $t2,$a2  
			li $t3,0
			li $t6,0      
		two_check_diagonal:
			lw $t4,($t2)
			add $t3,$t3,$t4
			add $t2,$t2,8
			lw $t4,($t2)
			add $t6,$t6,$t4
			add $t2,$t2,8
			lw $t4,($t2)
			add $t3,$t3,$t4
			add $t6,$t6,$t4
			add $t2,$t2,8
			lw $t4,($t2)
			add $t6,$t6,$t4
			add $t2,$t2,8
			lw $t4,($t2)
			add $t3,$t3,$t4
		two_check_diagonal1_win:
			bne $t3,-3,two_check_diagonal2_win
			li $v0,4
			la $a0,player2live_msg
			syscall
			li $v1,1
			jr $ra
		two_check_diagonal2_win:
			bne $t6,-3,two_exit3
			li $v0,4
			la $a0,player2live_msg
			syscall
			li $v1,1
			jr $ra
		two_exit3:
			li $v1,0
			jr $ra
			
	validity_row:
		zero_check_row:
			bne $t0,0,one_check_row
			li $v1,1
			jr $ra
		one_check_row:
			bne $t0,1,two_check_row
			li $v1,1
			jr $ra
		two_check_row:
			bne $t0,2,exit
			li $v1,1
			jr $ra
		exit:
			li $v0,4
			la $a0,invalid_msg
			syscall
			li $v1,0
			jr $ra
					
	validity_column:
		zero_check_column:
			bne $t1,0,one_check_column
			li $v1,1
			jr $ra
		one_check_column:
			bne $t1,1,two_check_column
			li $v1,1
			jr $ra
		two_check_column:
			bne $t1,2,exit1
			li $v1,1
			jr $ra
		exit1:
			li $v0,4
			la $a0,invalid_msg
			syscall
			li $v1,0
			jr $ra		
		
	valid:
		mul  $t2,$t0,3
		add $t2,$t2,$t1
		sll $t2,$t2,2
		add $t2,$t2,$a1
		
		lw $t3,($t2)
		bne $t3,0,exit2
		li $v1,1
		jr $ra
		
		exit2:
			li $v0,4
			la $a0,occupied_msg
			syscall
			li $v1,0
			jr $ra
		
	print:
		li $t3,0    # initialize outer loop counter to zero
		print_row_major_matrix_outer_loop:
		bge $t3,3,print_row_major_matrix_outer_loop_end
		li $t4,0    # initialize inner loop counter to zero
		print_row_major_matrix_inner_loop:
		bge $t4,3,print_row_major_matrix_inner_loop_end
		mul $t5,$t3,3
		add $t5,$t5,$t4
		mul $t5,$t5,1
		add $t5,$t5,$a3
		li $v0,11
		lb $a0,($t5)
		syscall
		li $v0,4
		la $a0,space
		syscall
		addiu $t4,$t4,1
		b print_row_major_matrix_inner_loop
		print_row_major_matrix_inner_loop_end:
		addi $t3,$t3,1
		li $v0,4
		la $a0,nextline
		syscall
		b print_row_major_matrix_outer_loop 
		print_row_major_matrix_outer_loop_end:
		jr $ra
		
	
	
	
	