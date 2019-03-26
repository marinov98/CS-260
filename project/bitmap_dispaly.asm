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
li $t2,512
li $t5,256


fill_yellow:
sw $t3,0($t1) # fill square
add $t1,$t1,$t0 # increment address by 4
add $t9,$t9,$t7 # increment by 1
beq $t9,$t6,reset
j fill_yellow


# reset
reset:
sub $t1,$t1,$t0
sub $t9,$t9,$t7 # decrement by one
beq $t9,0,first_rectangle
j reset

reroll:
addi $t1,$t1,2048
add $t9,$zero,$zero


first_rectangle: 
sw $t4,256($t1)
addi $t1,$t1,4
add $t9,$t9,$t7
beq $t9,128,reroll
j first_rectangle




Exit:
li $v0,10
syscall
