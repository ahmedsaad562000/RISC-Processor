#########################################################
#        All numbers are in hex format   				#
#        We always start by reset signal 				#
#########################################################
#         This is a commented line
#        You should ignore empty lines and commented ones
# ---------- Don't forget to Reset before you start anything ---------- #


.org 0	#this means the the following line would be  at address  0 , and this is the reset address
100							
.org 1	#this hw interrupt handler
20	

#test1  JC taken
.org 100
SETC
LDM R1,0F0F                        #INTERRUPT HERE
LDM R3,80h
NOT R2,R1
JC R3				#this should be taken, forward
OUT R3 			

#test2 JC not taken, JZ taken
.org 80
LDM R3, 150H
JC R3				#NOT TAKEN, SINCE JC CLEAR CARRY
LDM R4, 08H
AND R5,R3,R4
JZ R4
INC R4		          #THIS SHOULDN’T EXECUTE

#test3  load-use + unconditional jump
.ORG 8
Push R3
Pop R5                               
JMP R5                             #load-use + unconditional jump
INC R5		      #THIS SHOULDN’T HAPPEN


#test4 call 
.ORG 150
SETC
LDM R1,200H
CALL R1
NOT R1		#THIS SHOULD BE EXECUTED AFTER CALL
OUT R1


#test 4 continue
.org 200                                #INTERRUPT IS RAISED
LDM R1, 400
RET
CLRC
OUT R1


#test INTERRUPT
.org 20
CLRC
LDM R7, 300
OUT R7
RTI
INC R2


