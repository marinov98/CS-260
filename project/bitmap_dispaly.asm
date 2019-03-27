# Name: Marin P. Marinov
.data
frameBuffer: .space 0x80000 # 512 wide X 256 high pixels
n:	.word 20
m:	.word 20

.text
la $s1,frameBuffer

# variable allocation
la $a0,n
la $a1,m

lw $a0,0($a0)
lw $a1,0($a1)



# Making sure bounds are even

# colors initialization
li $t3,0x00FFFF00 # $t3 ← yellow  
li $t4,0x000000FF # $t4 <- blue


# calculations
addi $s2,$zero,512 # s2 <- 512
addi $s3,$zero,256 # s3 <- 256

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
li $t9,0 # t9 gets 0
li $t2,0 # t2 gets 0
li $t5,0 # t5 gets 0


add $t1,$s1,$zero # s1 has address of frame

fill_yellow:
sw $t3,0($t1) # fill square
addi $t1,$t1,4 # increment address by 4
addi $t9,$t9,1 # increment by 1
beq $t9,$t6,reset1
j fill_yellow


# resets frame to beginning
reset1:
add $t1,$s1,$zero # start from beginning
add $t9,$zero,$zero # set all registers used before to 0
j rectangle_X

## Notes
# This prints a vertical rectangle (needs a way to go by specifications

###################################################
#### Rectangle X

length_bottom_X:
sll $t9,$t9,2
sub $t1,$t1,$t9 # subtract amount wanted
addi $t1,$t1,2048 # go to next row
add $t9,$zero,$zero
addi $t2,$t2,1
beq $t2,$s7,reset2 # length of rectangle (move to rectangle Y when finished) (512 - (n + 2m))/2
j make_rectangle_X


rectangle_X:

length_top_X:
beq  $t5,$s7,make_rectangle_X # (512 - (n  + 2m))/2
addi $t1,$t1,2048 # go to next row
addi $t5,$t5,1 # increment t5 by 1 

j length_top_X

make_rectangle_X:
sw $t4,780($t1)
addi $t1,$t1,4 # increment adress
addi $t9,$t9,1 # check how many times address was incremented
beq $t9,$a0,length_bottom_X # n goes here
j make_rectangle_X

###################################################

### Rectangle Y 

## Notes 
# This prints a horizontal rectangle needs a way to work with bounds

# resets frame to beginning again
reset2:
add $t1,$s1,$zero
# set all registers used before to 0
add $t9,$zero,$zero
add $t5,$zero,$zero
add $t2,$zero,$zero
j rectangle_Y

length_bottom_Y:
sll  $t9,$t9,2
sub $t1,$t1,$t9 # subtract amount wanted
addi $t1,$t1,2048 # go to next row
add $t9,$zero,$zero
addi $t2,$t2,1
beq $t2,$a0,Exit # length of rectangle from bottom (512 - (n + 2m))/2
j make_rectangle_Y


rectangle_Y:

length_top_Y:
beq  $t5,$s6,make_rectangle_Y # lenght top (512 - (n + 2m)) /2
addi $t1,$t1,2048 # go to next row
addi $t5,$t5,1 # increment t5 by 1 
j length_top_Y

make_rectangle_Y:
sw $t4,780($t1)
addi $t1,$t1,4 # increment adress
addi $t9,$t9,1 # check how many times address was incremented
beq $t9,$s7,length_bottom_Y # 2m + n goes here
j make_rectangle_Y


Exit:
li $v0,10
syscall
