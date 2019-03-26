# Name: Marin P. Marinov
.data
frameBuffer: .space 0x80000 # 512 wide X 256 high pixels
n:	.word 20
m:	.word 20

.text
drawLine: la $t1,frameBuffer

# colors initialization
li $t3,0x00FFFF00 # $t3 ← yellow  
li $t4,0x000000FF # $t4 <- blue

# counters
li $t6,131072 # area of rectangle
li $t7,1 # incremenet by one
li $t0,4 
li $t9,0
li $t2,0
li $t5,256
la $a0,50
la $a1,100

fill_yellow:
sw $t3,0($t1) # fill square
add $t1,$t1,$t0 # increment address by 4
add $t9,$t9,$t7 # increment by 1
beq $t9,$t6,reset
j fill_yellow


# resets frame to beginning
reset:
sub $t1,$t1,$t0
sub $t9,$t9,$t7 # decrement by one
beq $t9,0,rectangle_X 
j reset 

## PROBLEMS
# technically an infinite loop, if X is uncommented Y may never be reached because X runs forever
# Does not work well if both loops are uncommented!

## Notes
# This prints a vertical rectangle (needs a way to go by specifications

reroll_X:
subi $t1,$t1,512
addi $t1,$t1,2048
add $t9,$zero,$zero


rectangle_X:
sw $t4,780($t1)
addi $t1,$t1,4
add $t9,$t9,$t7
beq $t9,128,reroll_X
j rectangle_X

## Notes 
# This prints a horizontal rectangle needs a way to work with bounds


#reroll_Y:
#beq $t2,50,Exit
#addi $t2,$t2,1
#subi $t1,$t1,2048
#addi $t1,$t1,2048
#add $t9,$zero,$zero

#rectangle_Y:
#sw $t4,($t1)
#addi $t1,$t1,4
#add $t9,$t9,$t7
#beq $t9,512,reroll_Y
#j rectangle_Y

Exit:
li $v0,10
syscall
