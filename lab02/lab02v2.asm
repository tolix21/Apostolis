# Palindrome detection in MIPS assembly using MARS
# for MYΥ-402 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou

        .globl main # declare the label main as global. 
        
        .text 
     
main:
        la         $s1, mesg         # get address of mesg to $s1
        addu       $s2, $s1,   $zero # $s2=$s1
loop:
        addiu      $s2, $s2,   1     # $s2=$s1 + 1
        lbu        $t0, 0($s2)       # get next character
        bne        $t0, $zero, loop  # repeat if char not '\0'
        # end of loop here

        addiu      $s2, $s2,  -1     # Adjust $s2 to point to last char
	addi       $a1, $0,    0                         # $a1=length 
        addu       $t1,$s1,  $zero                       # $t1=$s1 
        
        ########################################################################
# $a0=0 if it is palindrome,$a1=1 if it is not palindrome
# $a1=string length
# $s1 firts letters address
# $s2 last letters address
# $t0 first characters
# $t1 last characters
# $t2=1 if character not a letter
string_length:
	       
        
        addi       $a1, $a1,   1                 # increse counter
        addiu      $t1, $t1,   1                 # go to next character of the string
        lbu        $t0, 0($t1)                   # get next character
        bne        $t0, $zero, string_length     # repeat if char not '\0'
        j          palindrome_check
palindrome_check:
	slti       $a0, $a1,  2                  #if the current length is less than 2 then it's palindrome,$a0=1 else $a0=0
	bne        $a0, $zero, set_a0            #if $a0=1 go to set_a0 to set $a0=0 and exit 
	addi       $a0, $a0,  1			 # $a0=1 if it is not palindrome make sure a0=1 at exit
	lbu        $t0, 0($s1)                   #get  character that $s1 points at
	lbu        $t1, 0($s2)                   #get  character that $s2 points at
	bne        $t0,  $t1, space_check        #if first and last char are not equal ,go to space_check,a0 is still a0=1
        beq        $t0,  $t1, continue_check     #if first and last char are  equal go to continue_check
continue_check:
	addiu      $s1,$s1, 1                    #set $s1 to point to next first char
	addiu      $s2,$s2, -1                   #set $s2 to point to next last char
	addi	   $a1,$a1, -2                   #sustract legth as many chars as read
	j 	   palindrome_check		 #go to palindrome_check and check the next two characters
set_a0:
	addi       $a0,$a0,   -1                 # is palindrome but $a0=1,$a0=$a0-1,now you can exit
	j 	   exit                          # go to exit
space_check:
	lbu        $t0, 0($s1)                   #get  character that $s1 points at 
	slti       $t2,$t0, 65  		 #if this character is not'A'<=$t0<='z' (if $t0<65) $t2=1 else $t2=0
	bne	   $t1,$0,move_front		 #if $t2=1 go to move_front
	lbu        $t1, 0($s2)                   #get  character that $s2 points at
	slti       $t2,$t1,65			 #if this character is not'A'<=$t1<='z' (if $t1<65) $t2=1 else $t2=0
	bne        $t2,$0,move_back              #if $t2=1 go to move_front
	j	   exit				 #if both are  lower or upper case letters go to exit,a0 is still a0=1,is not palindrome
move_front:
	addiu      $s1,$s1, 1                    #set $s1 to point to next first char
	j	   palindrome_check              #continue check
move_back:
	addiu      $s2,$s2 -1                    #set $s2 to point to next last char
	j	   palindrome_check              #continue check
        ########################################################################

        
exit: 
        addiu      $v0, $zero, 10    # system service 10 is exit
        syscall                      # we are outta here.
        
###############################################################################

        .data
mesg:   .asciiz "ra cecar race car"   #changed the word so it includes spaces,it's still palindrome!!