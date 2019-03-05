/* 
COMPILING A  C PROCEDURE THAT DOESN"T CALL ANOTHER PROCEDURE
    int leaf_example (int g, int h, int i, int j) {
        int f;

        f = (g + h) - (i + j);
        return f;
    }
*/

# What is the compiled MIPS assembly code?

# $a0->g  $a1->h  $a2->i $a3->j

# Stack allocation

leaf_example:
    addi $sp, $sp, -12  # adjust stack to make room for 3 items sp=> stack pointer
    sw   $t1, 8($sp)    # save register $t1 for use afterwards
    sw   $t0, 4($sp)    # save register $t0 for use afterwards
    sw   $s0, 0($sp)    # save register $s0 for use afterwards

# Computation

    add $t0, $a0, $a1   # register $t0 contains g + h
    add $t1, $a1, $a3   # register $t1 contains i + j
    sub $s0, $t0, $t1   # f = $t0 - $t1, which is (g + h) - (i + j)

# To return the value of f, we copy it into a return value register

    add $v0, $s0, $zero # returns f ($v0 = $s0 + 0)

# Before returning, we restore the three old values of the registers we saved by "popping" them from the stack:

    lw $s0, 0($sp)      # restore register $s0 for caller
    lw $t0, 4($sp)      # restore register $t0 for caller
    lw $t1, 8($sp)      # restore register $t1 for caller

# The procedure ends with a jump register using the return address

    jr $ra              # jump back to calling routine 

# THIS IS CALLED A LEAF PROCEDURE


/*
    COMPILING A RECURSIVE C PROCEDURE, SHOWING NESTED PROCEDURE LINKING

    int FACT (int n) {
        if (n < 1) 
            return (1);
        else
            return (n * FACT(n - 1));

    }

What is the MIPS assembly code?
*/

/* 
n->$a0

The compiled program starts with the label of the procedure and then 
saves two registers on the stack, the return address and $a0

*/

    FACT:
        addi $sp, $sp, -8 # adjust stack for 2 items
        sw   $ra, 4($sp)  # save the return address
        sw   $a0, 0($sp)  # save the argument n

    /*
     The first time FACT is called, sw saves an address in the program called fact.
     The next two instructions test whether n is less than 1, going to L1 if n >= 1
    */

        slti $t0, $a0, 1     # test for n < 1
        beq  $t0, $zero, L1  # if n >= 1, go to L!

    /* 
        if n < 1, FACT returns 1 by putting 1 into a value register:
        it adds 1 to 0 and places  that sum in $v0. It then pops the two saved 
        values off the stack and jumps to the return address:
    */
        addi $v0, $zero, 1 # return 1
        addi $sp, $sp, 8   # pop 2 items off stack
        jr   $ra           # return to caller

    /*
        If n is NOT < 1, the argument n is decremented and then FACT
        is called again with the decremented value:
    */

    L1: addi $a0, $a0, -1 # n >= 1; argument gets n -1
        jal fact          # call fact with (n - 1)

    /*
        The next instruction is where FACT returns. Now the old return
        address and old argument are restored, along with the stack pointer:
    */

        lw $a0, 0($sp)   # return from jal: restore argument n
        lw $ra, 4($sp)   # restore the return address
        addi $sp, $sp, 8 # adjust stack pointer to pop 2 items

    /*
        Next, the value register $v0 gets the product of old argument $a0
        and the current value of the value register. We assume a multiply instruction
        is available, even though it is not covered until Chapter 3
    */

        mul $v0, $a0, $v0 # return n * fact (n - 1)
    
    # Finally, FACT jumps again to the return address:
        jr $ra            # return to the caller



/*
    int sum(int n, int acc) {
        if (n > 0)
            return sum(n - 1, acc + n);
        else
            return acc;
    }
*/

    sum: slti $t0, $a0, 1           # test if n <= 0
         bne  $to, $zero, sum_exit  # go to sum_exit if n <= 0
         add  $a1, $a1, $a0         # add n to acc
         addi $a0, $a0m, -1         # subtract 1 from n
         j    sum                   # jump to sum
    sum_exit:
        add   $v0, $a1, $zero       # return value acc
        jr    $ra                   # return to caller

