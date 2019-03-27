# Name: Marin P. Marinov
.data
frameBuffer: .space 0x80000 # 512 wide X 256 high pixels
n:	.word 40
m:	.word 40

.text
la $s1,frameBuffer
add $t1,$s1,$zero # s1 has address of frame

# variable allocation
la $a0,n # load address of n
la $a1,m # load adress of m

lw $a0,0($a0) # a0 <- n
lw $a1,0($a1) # a1 <- m

# Making sure bounds are even
andi $t8,$a0,1 # AND n and 1
beq  $t8,1,fix_n # make n even if it's odd
j try_next

fix_n:
	addi $a0,$a0,1 # make n even
	j  try_next # test m 

try_next:
	andi $t8,$a1,1 # AND m and 1
	beq $t8,1,fix_m # make m even if it is odd
	j Program # start the program if m is already even

fix_m:
	addi $a1,$a1,1 # make  m even


Program:

# colors initialization
li $t3,0x00FFFF00 # $t3 ← yellow  
li $t4,0x000000FF # $t4 <- blue


# calculations
addi $s2,$zero,512 # s2 <- 512
addi $s3,$zero,256 # s3 <- 256

sll $t0,$a0,2 # t0 <- 4n

srl $t2,$a0, 1 # t2 <- n/2
sub $t2,$s3,$t2 # t2 <- 256 - n/2

add  $s4,$zero,$a1 # s4 <- m
sll  $s4,$s4,1     # s4 <- 2m
add  $s5,$s4,$a0   # s5 <- 2m + n

sub $s6,$s2,$s5  # s6 <- 512 - (2m + n)
srl $s6,$s6,1    # s6 <- (512 - (2m + n))/2

sub $s7,$s3,$s5 # s7 <- 256 - (2m + n)
srl $s7,$s7,1   # s7 <- (256 - (2m + n)/2

# Checking bounds
slt $t8,$s3,$s5 # check 2m + n < 256
beq  $t8,1,Exit


# counters
li $t6,131072 # area of rectangle
li $t7,0


fill_yellow:
	sw $t3,0($t1) # fill square with yellow
	addi $t1,$t1,4 # increment address by 4
	addi $t9,$t9,1 # increment by 1
	beq $t9,$t6,reset1 # reset once we have filled the screen with yellow pixels
	j fill_yellow # keep filling


# resets frame to beginning
reset1:
	add $t1,$s1,$zero # start from beginning
	add $t9,$zero,$zero # set all registers used before to 0
	add $s0,$zero,$zero # s0 <- 0
	sll $t6,$s2,2  # t6 <- 2048

############## VERTICAL Rectangle

rectangle_X:
	sll $s7,$s7, 11  # multiply (256 - (2m + n)/2 by 2^11 
	add $t1,$t1,$s7 # go to starting row
	sll $t5,$t2,2 # t5 <- 4(256 - n/2)
	add $t1,$t1,$t5 # go to starting column


fill_in_row:
	beq $t7,$a0,next_row  # when reached length n start filling next row
	sw $t4, 0($t1) # store blue
	addi $t1,$t1,4 # increment address
	addi $t7,$t7,1 # keep track of how many times we've incremented the address
	j fill_in_row 

next_row:
	beq $s0,$s5,reset2 # if s0 = 2m + n go make the next rectangle
	addi $s0,$s0,1 # check how many times we have filled in a column
	sub  $t1,$t1,$t0 # subtract offset
	addi  $t1,$t1,2048 # go to next row
	add $t7,$zero,$zero # t7 is reset
	j   fill_in_row
	
#####################################

################ HORIZONTAL rectangle

reset2:
	add $t1,$s1,$zero
	# set all registers used before to 0
	add $t7,$zero,$zero # t7 <- 0
	sll $s4,$s4,1 # s4 <- 4m
	add $s0,$zero,$zero # s0 <- 0
	sll $t9,$s5,2 # t9 <- 4n


rectangle_Y:
	sll $t5,$s6,2 # t5 <- 4(512 - n/2)
	add $t1,$t1,$t5 # go to proper column
	sll $t9,$s4,2 # t9 <- 4m
	sll $t9,$s5,2 # t9 <- 4(2m + n)
	subi $t2,$t2,128 # s3 <- 256 n/2 -128 
	sll $t2,$t2,11
	add $t1,$t1,$t2 # move to proper row

fillrow:
	beq $t7,$s5,nextrow # when reached 2m + n length got to next row
	sw $t4, 0($t1) # fill current column with blue until we reach 2m + n
	addi $t1,$t1,4 # increment address
	addi $t7,$t7,1 # keep track how many times we have filled a column
	j fillrow

nextrow:
	beq $s0,$a0,Exit # if done n times exit, we are done
	addi $s0,$s0,1 # check how many times we went to the next row
	sub $t1,$t1,$t9 # subtract the offset
	addi $t1,$t1,2048 # go to next row
	add $t7,$zero,$zero # t7 <- 0
	j fillrow # start filling the row 
	
##########################

Exit:
li $v0,10
syscall


