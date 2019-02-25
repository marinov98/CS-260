# If/Else example:
# 
#   if (i == j)
#       f = g + h;
#   else
#       f = g - h;
#
#

bne i,j,Else # go to else if i != j
add f,g,h # f = g + h (skipped if i != j)
j   Exit # go to exit
Else: sub f,g,h # f = g - h (skipped if i == j)



# WHILE loop
#
# while (save[i] == k)
#   i += 1;
#

Loop: sll $t1, i, 2 # temp reg $t1 gets i * 4
add $t1,$t1,$s6 # address of save[i]
lw $t0, 0($t1) # temp reg $t0 = save[i]
bne $t0, $s5, Exit # go to exit if save[i] != k
addi $s3, $s3, 1 # i = i + 1 
j Loop # go to loop
Exit:



















































