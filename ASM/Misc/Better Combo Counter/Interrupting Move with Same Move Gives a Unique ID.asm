#To be inserted at 80089610
.macro branchl reg, address
lis \reg, \address @h
ori \reg,\reg,\address @l
mtctr \reg
bctrl
.endm

.macro branch reg, address
lis \reg, \address @h
ori \reg,\reg,\address @l
mtctr \reg
bctr
.endm

.macro load reg, address
lis \reg, \address @h
ori \reg, \reg, \address @l
.endm

.macro loadf regf,reg,address
lis \reg, \address @h
ori \reg, \reg, \address @l
stw \reg,-0x4(sp)
lfs \regf,-0x4(sp)
.endm

.macro backup
mflr r0
stw r0, 0x4(r1)
stwu	r1,-0x100(r1)	# make space for 12 registers
stmw  r20,0x8(r1)
.endm

 .macro restore
lmw  r20,0x8(r1)
lwz r0, 0x104(r1)
addi	r1,r1,0x100	# release the space
mtlr r0
.endm

.macro intToFloat reg,reg2
xoris    \reg,\reg,0x8000
lis    r18,0x4330
lfd    f16,-0x7470(rtoc)    # load magic number
stw    r18,0(r2)
stw    \reg,4(r2)
lfd    \reg2,0(r2)
fsubs    \reg2,\reg2,f16
.endm

.set PrevASStart,0x23F0
.set CurrentAS,0x10
.set OneASAgo,PrevASStart+(0*0x2)
.set TwoASAgo,PrevASStart+(1*0x2)
.set ThreeASAgo,PrevASStart+(2*0x2)
.set FourASAgo,PrevASStart+(3*0x2)
.set FiveASAgo,PrevASStart+(4*0x2)
.set SixASAgo,PrevASStart+(5*0x2)

#Check If Move Was Interrupted With the Same Move
  lwz r3,0x10(r26)  #New Move
  lhz r4,OneASAgo(r26)  #Previous Moe
  cmpw  r3,r4
  bne Original

#Interrupted move with same move, assign unique move ID
  branch r12,0x8008961c

Original:
  lbz	r0, 0x2073 (r31)
