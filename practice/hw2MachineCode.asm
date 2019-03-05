# PASSWORD: culber done together with guinan and Rozhenko

mask: .word 0xFFFFF83F
start:  la   $t0,mask     # load address of .word into temp reg $t0
        lw   $t0,0($t0)   # load what the address of .word contains into reg $t0
        la   $s0,shiftr   # load the address of shiftr(last sll instr) into $s0 
        lw   $s0,0($s0)   # load the contents of shifter into $s0
        and  $s0,$s0,$t0  # AND $s0 and $t0 and stores it in $s0 which results in zeroing out sll's offset  
        andi $s2,$s2,0x1f # ANDS the address of s2 with 0x1f which results into keeping the low 5 bits
        sll  $s2,$s2,6    # shift $s2 by 6 bits to the left
        or   $s0,$s0,$s2  # ORs $s0 and $s2 which results in dropping the 5 bits into the shift offset
        la   $t5,shiftr   # load address of shifter into $t5
        sw   $s0,0($t5)   # store the contents of reg $t5 into $s0
shiftr: sll  $s0,$s1,0    # Execute instruction with new offset


# How the code works:
/*
    This code is run once. It start by having the assembler
    to researve a word of memory at 0xFFFFF83F. We load the address and value of .word into 
    register $t0. the program then stores the binary of shiftr. Next, when we AND
    $s0 and $t0 the zeroes in the $s0 will zero out any offset in the $t1. The andi
    is where we AND $s2 with 0x1f which only leaves the last five bits of $s2. We then move these 5 bits
    6 places to the left. When we OR the 5 bits from $s2 will be moved into the binary of $s0 and become the new offset.
    We have now changed the offset from 0 to what the bits of $s2 is. Finally load the address and value of shiftr into $s0 and
    we execute the shift instruction with the new offset.

    This type of self-modidying code is hazardous because it can become
    a security risk. Moreover, the code could modify itself to expose a security
    issue. This also means that all of the code has to be loaded in memory. If
    there is a way to get the program to jump errantly, you exploit it. This means
    you are running arbitrary code remotely.
*/
