#UFUKCAN ERDEM 1901042686
#CSE-331 HW #2

.data
	str2: .space 1024
	temp: .space 128 
	fout: .asciiz "input.txt" 	#INPUT
	fout2: .asciiz "output.txt"	#OUTPUT
	arr: .word 0:10			#Holds the readed array from txt	
	temp_arr: .word 1:10		
	temp_arr2: .word -99:10		#Holds sorted array after calculations
	comma: .asciiz ","		
	space: .asciiz " "
	prtlen: .asciiz " size:"
	newline: .asciiz "\n"
	left: .asciiz "["
	right: .asciiz "]"
.text
	.globl main
	main:
		# I Just copied open and write file so there is auto comments. Sorry about that.
		li $v0, 13 		# system call for open file
		la $a0, fout 		# output file name
		li $a1, 0 		# Open for writing (flags are 0: read, 1: write)
		li $a2, 0		# mode is ignored
		syscall 		# open a file (file descriptor returned in $v0)
		move $s6, $v0 		# save the file descriptor

		# Read from file just opened
		li $v0, 14 		# system call for write to file
		move $a0, $s6 		# file descriptor
		la $a1, str2 		# address of buffer from which to write
		li $a2, 1024		# hardcoded buffer length
		syscall 		# write to file

		###############################################################
		# Close the file
		li $v0, 16 		# system call for close file
		move $a0, $s6 		# file descriptor to close
		syscall 		# close file
		
		#CALL FOR 1. LINE OF TXT ( I WILL CALL SAME THINGS FOR 6 TIME FOR EACH LINE SO MY MAIN FUNCTION IS VERY LONG
		jal readfromfile		#THIS FUNCTIONS READ "input.txt" and holds it in str2
		
		addi $s0,$zero,0		#s0 hold size of array
		addi $a0,$zero,0		#i=0;
		
		jal find_arrsize		#This function calculates size of input array
		
		addi $a0,$zero,1		#i=1
		addi $a1,$zero,0		#j=0
		addi $s1,$zero,0		#s1 holds lenght of longestincsubseq=0
	
		jal find_lengs			#Find lengs for each element with algorithm you showed in ps session.
		
		addi $a0,$zero,0
		jal max_leng			#Find the longest leng of subsequences
		jal savelongest			#Save the longest subseq to temp_arr2
		
		addi $t0,$zero,0
		addi $t1,$zero,0
		addi $t2,$zero,0
		
		 ###############################################################
 		# Open (for writing) a file that does not exist
 		li   $v0, 13       # system call for open file
  		la   $a0, fout2     # output file name
  		li   $a1, 9        # Open for writing (flags are 0: read, 1: write)
  		li   $a2, 0        # mode is ignored
  		syscall            # open a file (file descriptor returned in $v0)
 	 	move $s6, $v0      # save the file descriptor
 	 	
 	 	li   $v0, 15       # system call for write to file
  		move $a0, $s6      # file descriptor 
  		la   $a1, left   # address of buffer from which to write
  		li   $a2, 1       # hardcoded buffer length
  		syscall            # write to file

		
		loopinmain:	#This loop for write to "output.txt" with desired order.
			mul $t1,$t0,4
			lw $t3,temp_arr2($t1)
			beq $t3,-99,exitloopinmain
			
			
  			addi $a0, $t3,0          
			la $a1, temp          	
			jal word_to_asciiz     	
			la   $a0, temp 
			li   $v0, 15      
  			move $a0, $s6      
  			la   $a1, temp   
  			bgt $t3,999,over999	#this if statement for do not write extra space to output. This gives digit count space as hardcoded buffer.
			b over99
				over999:
					li $a2, 4      
					b overexit
			over99:
			bgt $t3,99,over99in
			b over9
				over99in:
					li   $a2,3       
					b overexit
			over9:
			bgt $t3,9,over9in
			b over0
				over9in:
					li   $a2,2       
					b overexit
			over0:
			bgt $t3,-1,over0in
			b overexit
				over0in:
					li   $a2,1       
					b overexit
			overexit:
  			syscall            
  			
  			addi $t9,$s1,-1
  			beq $t9,$t0,donotcomma
  			li   $v0, 15      
  			move $a0, $s6      
  			la   $a1, comma   
 			li   $a2, 1       
  			syscall            
  			
  			donotcomma:
			addi $t0,$t0,1
			j loopinmain
		exitloopinmain:
		li   $v0, 15      
  		move $a0, $s6      
  		la   $a1, right   
  		li   $a2, 1      
  		syscall            
  		
  		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, prtlen   
  		li   $a2, 6      
  		syscall            
  		
  		
  		addi $a0, $s1,0           
		la $a1, temp          	
		jal word_to_asciiz     
		la   $a0, temp 
		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, temp   
  		li   $a2, 2
  		syscall
  		
  		
  		li   $v0, 15       
  		move $a0, $s6    
  		la   $a1, newline   
  		li   $a2, 1       
  		syscall            
		# Close the file 
  		li   $v0, 16       # system call for close file
  		move $a0, $s6      # file descriptor to close
  		syscall            # close file
		
		#CALL FOR 2. LINE OF TXT  	!!!!!!!!!!!!!!!!!THIS IS ALL SAME THINGS WITH JUST NAMECHANGES OF CALL FOR 1.LINE TXT!!!!!!!!!!!!!!!!!!!!!!!!!!
		jal resetDatas
		jal readfromfile
		
		addi $s0,$zero,0		#s0 hold size of array
		addi $a0,$zero,0		#i=0;
		
		jal find_arrsize
		
		addi $a0,$zero,1		#i=1
		addi $a1,$zero,0		#j=0
		addi $s1,$zero,0		#s1 holds lenght of longestincsubseq=0
	
		jal find_lengs
		
		addi $a0,$zero,0
		jal max_leng
		jal savelongest
		
		addi $t0,$zero,0
		addi $t1,$zero,0
		addi $t2,$zero,0
		
		 ###############################################################
 		# Open (for writing) a file that does not exist
 		li   $v0, 13       # system call for open file
  		la   $a0, fout2     # output file name
  		li   $a1, 9        # Open for writing (flags are 0: read, 1: write)
  		li   $a2, 0        # mode is ignored
  		syscall            # open a file (file descriptor returned in $v0)
 	 	move $s6, $v0      # save the file descriptor
 	 	
 	 	li   $v0, 15       # system call for write to file
  		move $a0, $s6      # file descriptor 
  		la   $a1, left   # address of buffer from which to write
  		li   $a2, 1       # hardcoded buffer length
  		syscall            # write to file
 	 	  
		
		loopinmain2:
			mul $t1,$t0,4
			lw $t3,temp_arr2($t1)
			beq $t3,-99,exitloopinmain2
			
			
  			addi $a0, $t3,0          
			la $a1, temp          	
			jal word_to_asciiz     	
			la   $a0, temp 
			li   $v0, 15       
  			move $a0, $s6      
  			la   $a1, temp   
  			bgt $t3,999,over9992
			b over992
				over9992:
					li   $a2,4       
					b overexit2
			over992:
			bgt $t3,99,over99in2
			b over92
				over99in2:
					li   $a2,3       
					b overexit2
			over92:
			bgt $t3,9,over9in2
			b over02
				over9in2:
					li   $a2, 2      
					b overexit2
			over02:
			bgt $t3,-1,over0in2
			b overexit2
				over0in2:
					li   $a2, 1       
					b overexit2
			overexit2:
  			syscall            
  			
  			addi $t9,$s1,-1
  			beq $t9,$t0,donotcomma2
  			li   $v0, 15       
  			move $a0, $s6      
  			la   $a1, comma  
 			li   $a2, 1       
  			syscall            
  			
  			donotcomma2:
			addi $t0,$t0,1
			j loopinmain2
		exitloopinmain2:
		li   $v0, 15       
  		move $a0, $s6     
  		la   $a1, right   
  		li   $a2, 1       
  		syscall            
  		
  		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, prtlen   
  		li   $a2, 6       
  		syscall           
  		
  		
  		addi $a0, $s1,0           
		la $a1, temp          	
		jal word_to_asciiz     	
		la   $a0, temp 
		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, temp   
  		li   $a2, 2
  		syscall
  		
  		
  		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, newline   
  		li   $a2, 1       
  		syscall           
		# Close the file 
  		li   $v0, 16       
  		move $a0, $s6      
  		syscall            
  		
  		#CALL FOR 3. LINE OF TXT-------------------------------------------------------------------------------------------------------------------------
		jal resetDatas
		jal readfromfile
		
		addi $s0,$zero,0		#s0 hold size of array
		addi $a0,$zero,0		#i=0;
		
		jal find_arrsize
		
		addi $a0,$zero,1		#i=1
		addi $a1,$zero,0		#j=0
		addi $s1,$zero,0		#s1 holds lenght of longestincsubseq=0
	
		jal find_lengs
		
		addi $a0,$zero,0
		jal max_leng
		jal savelongest
		
		addi $t0,$zero,0
		addi $t1,$zero,0
		addi $t2,$zero,0
		
		 ###############################################################
 		# Open (for writing) a file that does not exist
 		li   $v0, 13       # system call for open file
  		la   $a0, fout2     # output file name
  		li   $a1, 9        # Open for writing (flags are 0: read, 1: write)
  		li   $a2, 0        # mode is ignored
  		syscall            # open a file (file descriptor returned in $v0)
 	 	move $s6, $v0      # save the file descriptor
 	 	
 	 	li   $v0, 15      
  		move $a0, $s6      
  		la   $a1, left   
  		li   $a2, 1       
  		syscall            
 	 	  
		
		loopinmain3:
			mul $t1,$t0,4
			lw $t3,temp_arr2($t1)
			beq $t3,-99,exitloopinmain3
			
			
  			addi $a0, $t3,0          
			la $a1, temp          	
			jal word_to_asciiz     	
			la   $a0, temp 
			li   $v0, 15       
  			move $a0, $s6     
  			la   $a1, temp   
  			bgt $t3,999,over9993
			b over993
				over9993:
					li   $a2,4       
					b overexit3
			over993:
			bgt $t3,99,over99in3
			b over93
				over99in3:
					li   $a2,3       
					b overexit3
			over93:
			bgt $t3,9,over9in3
			b over03
				over9in3:
					li   $a2,2       
					b overexit3
			over03:
			bgt $t3,-1,over0in3
			b overexit3
				over0in3:
					li   $a2,1       
					b overexit3
			overexit3:
  			syscall            
  			
  			addi $t9,$s1,-1
  			beq $t9,$t0,donotcomma3
  			li   $v0, 15       
  			move $a0, $s6      
  			la   $a1, comma   
 			li   $a2, 1       
  			syscall           
  			
  			donotcomma3:
			addi $t0,$t0,1
			j loopinmain3
		exitloopinmain3:
		li   $v0, 15      
  		move $a0, $s6     
  		la   $a1, right   
  		li   $a2, 1      
  		syscall            
  		
  		li   $v0, 15      
  		move $a0, $s6      
  		la   $a1, prtlen   
  		li   $a2, 6      
  		syscall            
  		
  		
  		addi $a0, $s1,0           
		la $a1, temp          	
		jal word_to_asciiz     	
		la   $a0, temp 
		li   $v0, 15       
  		move $a0, $s6     
  		la   $a1, temp  
  		li   $a2, 2
  		syscall
  		
  		
  		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, newline   
  		li   $a2, 1       
  		syscall            
		# Close the file 
  		li   $v0, 16       
  		move $a0, $s6      
  		syscall            
  		
  		#CALL FOR 4. LINE OF TXT-------------------------------------------------------------------------------------------------------------------------
		jal resetDatas
		jal readfromfile
		
		addi $s0,$zero,0		#s0 hold size of array
		addi $a0,$zero,0		#i=0;
		
		jal find_arrsize
		
		addi $a0,$zero,1		#i=1
		addi $a1,$zero,0		#j=0
		addi $s1,$zero,0		#s1 holds lenght of longestincsubseq=0
	
		jal find_lengs
		
		addi $a0,$zero,0
		jal max_leng
		jal savelongest
		
		addi $t0,$zero,0
		addi $t1,$zero,0
		addi $t2,$zero,0
		
		 ###############################################################
 		# Open (for writing) a file that does not exist
 		li   $v0, 13       # system call for open file
  		la   $a0, fout2     # output file name
  		li   $a1, 9        # Open for writing (flags are 0: read, 1: write)
  		li   $a2, 0        # mode is ignored
  		syscall            # open a file (file descriptor returned in $v0)
 	 	move $s6, $v0      # save the file descriptor
 	 	
 	 	li   $v0, 15       # system call for write to file
  		move $a0, $s6      # file descriptor 
  		la   $a1, left   # address of buffer from which to write
  		li   $a2, 1       # hardcoded buffer length
  		syscall            # write to file
 	 	  
		
		loopinmain4:
			mul $t1,$t0,4
			lw $t3,temp_arr2($t1)
			beq $t3,-99,exitloopinmain4
			
			
  			addi $a0, $t3,0         
			la $a1, temp          	
			jal word_to_asciiz     
			la   $a0, temp 
			li   $v0, 15       
  			move $a0, $s6      
  			la   $a1, temp  
  			bgt $t3,999,over9994
			b over994
				over9994:
					li   $a2,4       
					b overexit4
			over994:
			bgt $t3,99,over99in4
			b over94
				over99in4:
					li   $a2,3       
					b overexit4
			over94:
			bgt $t3,9,over9in4
			b over04
				over9in4:
					li   $a2,2       
					b overexit4
			over04:
			bgt $t3,-1,over0in4
			b overexit4
				over0in4:
					li   $a2,1       
					b overexit4
			overexit4:
  			syscall           
  			
  			addi $t9,$s1,-1
  			beq $t9,$t0,donotcomma4
  			li   $v0, 15       
  			move $a0, $s6     
  			la   $a1, comma   
 			li   $a2, 1       
  			syscall            
  			
  			donotcomma4:
			addi $t0,$t0,1
			j loopinmain4
		exitloopinmain4:
		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, right   
  		li   $a2, 1       
  		syscall            
  		
  		li   $v0, 15       
  		move $a0, $s6     
  		la   $a1, prtlen   
  		li   $a2, 6      
  		syscall            
  		
  		
  		addi $a0, $s1,0           
		la $a1, temp          	
		jal word_to_asciiz     	
		la   $a0, temp 
		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, temp   
  		li   $a2, 2
  		syscall
  		
  		
  		li   $v0, 15      
  		move $a0, $s6      
  		la   $a1, newline  
  		li   $a2, 1       
  		syscall            
		# Close the file 
  		li   $v0, 16      
  		move $a0, $s6      
  		syscall            
  		
  		#CALL FOR 5. LINE OF TXT-------------------------------------------------------------------------------------------------------------------------
		jal resetDatas
		jal readfromfile
		
		addi $s0,$zero,0		#s0 hold size of array
		addi $a0,$zero,0		#i=0;
		
		jal find_arrsize
		
		addi $a0,$zero,1		#i=1
		addi $a1,$zero,0		#j=0
		addi $s1,$zero,0		#s1 holds lenght of longestincsubseq=0
	
		jal find_lengs
		
		addi $a0,$zero,0
		jal max_leng
		jal savelongest
		
		addi $t0,$zero,0
		addi $t1,$zero,0
		addi $t2,$zero,0
		
		 ###############################################################
 		# Open (for writing) a file that does not exist
 		li   $v0, 13       # system call for open file
  		la   $a0, fout2     # output file name
  		li   $a1, 9        # Open for writing (flags are 0: read, 1: write)
  		li   $a2, 0        # mode is ignored
  		syscall            # open a file (file descriptor returned in $v0)
 	 	move $s6, $v0      # save the file descriptor
 	 	
 	 	li   $v0, 15       # system call for write to file
  		move $a0, $s6      # file descriptor 
  		la   $a1, left   # address of buffer from which to write
  		li   $a2, 1       # hardcoded buffer length
  		syscall            # write to file
 	 	  
		
		loopinmain5:
			mul $t1,$t0,4
			lw $t3,temp_arr2($t1)
			beq $t3,-99,exitloopinmain5
			
			
  			addi $a0, $t3,0           
			la $a1, temp          	
			jal word_to_asciiz     	
			la   $a0, temp 
			li   $v0, 15       
  			move $a0, $s6      
  			la   $a1, temp   
  			bgt $t3,999,over9995
			b over995
				over9995:
					li   $a2, 4       
					b overexit5
			over995:
			bgt $t3,99,over99in5
			b over95
				over99in5:
					li   $a2, 3       
					b overexit5
			over95:
			bgt $t3,9,over9in5
			b over05
				over9in5:
					li   $a2, 2       
					b overexit5
			over05:
			bgt $t3,-1,over0in5
			b overexit5
				over0in5:
					li   $a2, 1       
					b overexit5
			overexit5:
  			syscall            
  			
  			addi $t9,$s1,-1
  			beq $t9,$t0,donotcomma5
  			li   $v0, 15       
  			move $a0, $s6      
  			la   $a1, comma  
 			li   $a2, 1       
  			syscall            
  			
  			donotcomma5:
			addi $t0,$t0,1
			j loopinmain5
		exitloopinmain5:
		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, right   
  		li   $a2, 1      
  		syscall            
  		
  		li   $v0, 15      
  		move $a0, $s6     
  		la   $a1, prtlen   
  		li   $a2, 6      
  		syscall            
  		
  		
  		addi $a0, $s1,0           
		la $a1, temp          	
		jal word_to_asciiz     	
		la   $a0, temp 
		li   $v0, 15      
  		move $a0, $s6      
  		la   $a1, temp   
  		li   $a2, 2
  		syscall
  		
  		
  		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, newline   
  		li   $a2, 1       
  		syscall            
		# Close the file 
  		li   $v0, 16       # system call for close file
  		move $a0, $s6      # file descriptor to close
  		syscall            # close file
  		
  		#CALL FOR 6. LINE OF TXT-------------------------------------------------------------------------------------------------------------------------
		jal resetDatas
		jal readfromfile
		
		addi $s0,$zero,0		#s0 hold size of array
		addi $a0,$zero,0		#i=0;
		
		jal find_arrsize
		
		addi $a0,$zero,1		#i=1
		addi $a1,$zero,0		#j=0
		addi $s1,$zero,0		#s1 holds lenght of longestincsubseq=0
	
		jal find_lengs
		
		addi $a0,$zero,0
		jal max_leng
		jal savelongest
		
		addi $t0,$zero,0
		addi $t1,$zero,0
		addi $t2,$zero,0
		
		 ###############################################################
 		# Open (for writing) a file that does not exist
 		li   $v0, 13       # system call for open file
  		la   $a0, fout2     # output file name
  		li   $a1, 9        # Open for writing (flags are 0: read, 1: write)
  		li   $a2, 0        # mode is ignored
  		syscall            # open a file (file descriptor returned in $v0)
 	 	move $s6, $v0      # save the file descriptor
 	 	
 	 	li   $v0, 15       # system call for write to file
  		move $a0, $s6      # file descriptor 
  		la   $a1, left   # address of buffer from which to write
  		li   $a2, 1       # hardcoded buffer length
  		syscall            # write to file
 	 	  
		
		loopinmain6:
			mul $t1,$t0,4
			lw $t3,temp_arr2($t1)
			beq $t3,-99,exitloopinmain6
			
			
  			addi $a0, $t3,0           
			la $a1, temp          	
			jal word_to_asciiz     	
			la   $a0, temp 
			li   $v0, 15      
  			move $a0, $s6      
  			la   $a1, temp   
  			bgt $t3,999,over9996
			b over996
				over9996:
					li   $a2,4       
					b overexit6
			over996:
			bgt $t3,99,over99in6
			b over96
				over99in6:
					li   $a2,3       
					b overexit6
			over96:
			bgt $t3,9,over9in6
			b over06
				over9in6:
					li   $a2,2       
					b overexit6
			over06:
			bgt $t3,-1,over0in6
			b overexit6
				over0in6:
					li   $a2,1       
					b overexit6
			overexit6:
  			syscall            
  			
  			addi $t9,$s1,-1
  			beq $t9,$t0,donotcomma6
  			li   $v0, 15       
  			move $a0, $s6      
  			la   $a1, comma  
 			li   $a2, 1       
  			syscall           
  			
  			donotcomma6:
			addi $t0,$t0,1
			j loopinmain6
		exitloopinmain6:
		li   $v0, 15       
  		move $a0, $s6     
  		la   $a1, right   
  		li   $a2, 1       
  		syscall            
  		
  		li   $v0, 15       
  		move $a0, $s6     
  		la   $a1, prtlen   
  		li   $a2, 6       
  		syscall            
  		
  		
  		addi $a0, $s1,0           
		la $a1, temp          	
		jal word_to_asciiz     
		la   $a0, temp 
		li   $v0, 15      
  		move $a0, $s6     
  		la   $a1, temp   
  		li   $a2, 2
  		syscall
  		
  		
  		li   $v0, 15       
  		move $a0, $s6      
  		la   $a1, newline   
  		li   $a2, 1       
  		syscall            
		# Close the file 
  		li   $v0, 16       # system call for close file
  		move $a0, $s6      # file descriptor to close
  		syscall            # close file
		
		#END OF PROGRAM
		li $v0,10
		syscall
	
	.globl find_lengs
	find_lengs:
		addi $t1,$s0,-2
		find_lengs2:
		bgt  $a1,$t1,exit	#while(j<size) size-2
		
		mul $t0,$a0,4
		lw $t5,arr($t0) #arr[i]
		
		mul $t0,$a1,4
		lw $t6,arr($t0) #arr[j]
		
		bgt $t5,$t6,if0
		addi $a1,$a1,1	#j++
		b   endif0
		
		if0:
			mul $t0,$a0,4
			lw $t7,temp_arr($t0) 	#temp_arr[i]
		
			mul $t0,$a1,4
			lw $t8,temp_arr($t0) 	#temp_arr[j]
			addi $t8,$t8,1 		#temp_arr[j]+1
			
			bgt $t8,$t7,if1	
			b   endif1
				if1:
					mul $t0,$a0,4
					sw $t8, temp_arr($t0)
			endif1:
				addi $a1,$a1,1	#j++
		
		endif0:
			beq $a0,$a1,if3
			b enif3
			if3:
				addi $a1,$zero,0	#j=0
				addi $a0,$a0,1		#i++
		enif3:
			j find_lengs2
			
		exit:
			jr $ra

		.globl max_leng
		max_leng:
			addi $t1,$s0,-1
			max_leng2:
			bgt  $a0,$t1,exit2	#while(i<size) size-1
			
			mul $t0,$a0,4
			lw $t9,temp_arr($t0) 	#temp_arr[0]
			
			bgt $t9,$s1,change_max
			b notchanged
				change_max:
					addi $s1,$t9,0
			notchanged:
				addi $a0,$a0,1
				j max_leng2
			
			exit2:
				jr $ra
				
		find_arrsize:
			addi $t0,$zero,0	#temporary
			
			loop_find_arrsize:
				beq $t0,-99,exit_find_arrsize
				mul $t0,$a0,4
				lw $t0,arr($t0)
				addi $s0,$s0,1	#arrsize++
				addi $a0,$a0,1	#i++
				j loop_find_arrsize
			
			exit_find_arrsize:
				addi $s0,$s0,-1	#for delete counted -99
				jr $ra
		.globl savelongest	
		savelongest:
			addi $t0,$s1,0		#holds longestincsubseq leng 
			addi $t1,$zero,999999	#temp
			addi $t2,$s1,0		#count=max
			addi $t3,$s0,1		#k=size+1
			addi $t4,$s0,1		#l=size+1
			
			
			
			loop_savelongest_i:
				addi $t3,$t3,-1
				addi $t4,$s0,0
				bltz $t3,savelongest_exit
				j loop_savelongest_j
			
			loop_savelongest_j:
				bltz $t4,loop_savelongest_i
				addi $t4,$t4,-1
				mul $t9,$t4,4
				lw $t5,arr($t9)	
				lw $t9,temp_arr($t9)		
			
				bne  $t2,$t9,not_j_if0
				ble  $t1,$t5,not_j_if0
				
				mul $t8,$t4,4
				lw $t9,arr($t8)
				addi $t1,$t9,0	#temp=arr[l]
				addi $t2,$t2,-1	#count--
				mul $t7,$t4,4
				mul $t8,$t2,4
				lw $t9,arr($t7)
				sw $t9,temp_arr2($t8)
				
				not_j_if0:
					j loop_savelongest_j
			
			savelongest_exit:
				addi $t1,$zero,0
				addi $t0,$zero,0
			loop_find_arrsize2:
				beq $t0,-99,exit_find_arrsize2
				mul $t0,$t1,4
				lw $t0,temp_arr2($t0)
				
				bne $t0,-99,printsubseqarr
				b donotprint
				
				printsubseqarr:
					
    					
				donotprint:
					addi $t1,$t1,1	#i++
					j loop_find_arrsize2
			
			exit_find_arrsize2:
				
   					
				jr $ra
		
		readfromfile:
		addi $t9,$zero,0	#count
		addi $t8,$zero,0	#temp
		addi $t7,$zero,0	#j
		addi $t6,$s2,1		#i
    					

		outerwhile:
		bgt $t6,999,endouter
		lb $s5,str2($t6)

		beq $s5,10,endouter	#checks newline 
		bgt $s5,57,donotadd
		blt $s5,48,donotadd
		addi $t7,$t6,0
		innerwhile:
			lb $s6,str2($t7) 
			beq $s6,44,endinnerwhile
			beq $s6,93,endinnerwhile
			addi $t8,$t8,1
			addi $t7,$t7,1
			j innerwhile
		endinnerwhile:
			addi $t3,$t8,-1		#pownum=temp-1
			addi $t4,$t8,0		#k=temp
			addi $t5,$zero,0	#rmul
			
			innerfor:
				blt $t4,1,endinnerfor
				sub  $t0,$t7,$t4
				lb $s3,str2($t0)
				addi $s3,$s3,-48	#lmul
				beq $t3,0,pownum0
				b pownum1
					pownum0:
					addi $t2,$zero,1
					b endpownum
				pownum1:
				beq $t3,1,pownum1_in
				b pownum2
					pownum1_in:
					addi $t2,$zero,10
					b endpownum
				pownum2:
				beq $t3,2,pownum2_in
				b pownum3
					pownum2_in:
					addi $t2,$zero,100
					b endpownum
				pownum3:
				beq $t3,3,pownum3_in
					pownum3_in:
					addi $t2,$zero,1000
					b endpownum  	
				endpownum:
				mul $t1,$t2,$s3
				mul $s7,$t9,4
				lw $t2, arr($s7)
				add $t1,$t1,$t2
				sw $t1,arr($s7)
		
				addi $t3,$t3,-1	#pownum--
				addi $t4,$t4,-1 #j--
				j innerfor
				
				endinnerfor:
				addi $t3,$zero,0 #pownum=0	
				addi $t9,$t9,1	#count++
				addi $t8,$t8,1
				add $t6,$t6,$t8	#i+=temp+1
				addi $t8,$zero,0 #temp=0
				b passelse		
		donotadd:
			addi $t6,$t6,1	#i++
		passelse:
			j outerwhile

		endouter:
			mul $s7,$t9,4		#adds -99 element for calculation to end of array
			addi $t2,$zero,-99
			sw $t2, arr($s7)
			addi $s2,$t6,0		#s2 holds adress of buffer on left in text
			jr $ra

		word_to_asciiz:
			addi $sp,$sp,-4         
			sw   $t0,($sp)          
			
			li   $t0,-1
			addi $sp,$sp,-4        
			sw   $t0,($sp)           

			add_nums:
				blez $a0,next1           
				li   $t0,10              
				div  $a0,$t0            
				mfhi $t0                  
				mflo $a0                 
				addi $sp,$sp, -4         
				sw   $t0,($sp)          
				j    add_nums          

			next1:
				lw   $t0,($sp)          
				addi $sp,$sp, 4          

				bltz $t0,neg_num       
				j    sub_nums          

			neg_num:
				li   $t0,'0'
				sb   $t0,($a1)           
				addi $a1,$a1, 1          
				j    next2                

			sub_nums:
				bltz $t0,next2           
				addi $t0,$t0, '0'        
				sb   $t0,($a1)           
				addi $a1,$a1, 1         
				lw   $t0,($sp)           
				addi $sp,$sp, 4          
				j    sub_nums          

			next2:
				sb  $zero,($a1)          
				lw   $t0,($sp)           
				addi $sp,$sp,4          
				jr  $ra                   
			
		resetDatas:
			#arr: .word 0:10
			#temp_arr: .word 1:10
			#temp_arr2: .word -99:10
			addi $t2,$zero,0
			addi $t1,$zero,0
			resetDatasloop:
				bgt $t2,9,finishresetDatas
				mul $t1,$t2,4
				
				addi $t0,$zero,0
				sw $t0,arr($t1)
				
				addi $t0,$zero,1
				sw $t0,temp_arr($t1)
				
				addi $t0,$zero,-99
				sw $t0,temp_arr2($t1)
				
				addi $t2,$t2,1
				j resetDatasloop
			finishresetDatas:
				addi $s0,$zero,0
				addi $s1,$zero,0
				addi $s3,$zero,0
				addi $s4,$zero,0
				addi $s5,$zero,0
				addi $s6,$zero,0
				addi $s7,$zero,0
				addi $t1,$zero,0
				addi $t2,$zero,0
				addi $t3,$zero,0
				addi $t4,$zero,0
				addi $t5,$zero,0
				addi $t6,$zero,0
				addi $t7,$zero,0
				addi $t8,$zero,0
				addi $t9,$zero,0
				jr $ra	
				
				
