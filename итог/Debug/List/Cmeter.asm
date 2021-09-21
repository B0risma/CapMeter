
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_capt_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x0,0x43,0x48,0x45,0x43,0x4B,0x0,0x6D
	.DB  0x41,0x0,0x45,0x52,0x52,0x4F,0x52,0x0
	.DB  0x54,0x45,0x53,0x54,0x49,0x4E,0x47,0x0
	.DB  0x20,0x20,0x20,0x20,0x75,0x66,0x0,0x20
	.DB  0x20,0x20,0x20,0x6F,0x68,0x6D,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _0x9
	.DW  _0x0*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 15.05.2021
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;#define CUR2 PORTD.7
;#define CUR1 PORTB.0
;#define DISCH PORTB.1
;#define LCD_LINE1 lcd_com(0x80)
;#define LCD_LINE2 lcd_com(0xC0)
;#define LCD_CLR lcd_com(0x01)
;#define CLK 16  //MHz
;#define CLK_PSL 8
;#define REF 1.25
;
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Standard Input/Output functions
;//#include <stdio.h>
;#include <stdlib.h>
;//#include <string.h>
;#include <iobits.h>
;#include <delay.h>
;#include <spi.h>
;
;// Declare your global variables here
;unsigned long t=0, T1=0, T2=0;
;eeprom float I1=10.5, I2= 113.3;
;bit mode = 0;
;
;void LCDcom(unsigned char com) //выполняет пол команды отправляет старший полубайт
; 0000 0032 {

	.CSEG
_LCDcom:
; .FSTART _LCDcom
; 0000 0033     com |= 0x08;                // Р3 в единицу, дабы горела подсветка
	ST   -Y,R26
;	com -> Y+0
	LD   R30,Y
	ORI  R30,8
	RCALL SUBOPT_0x0
; 0000 0034     spi(com);    // Вывод данных
; 0000 0035     SETBIT(PORTB,2);
; 0000 0036     //delay_us(1);
; 0000 0037     CLRBIT(PORTB,2);
; 0000 0038     //delay_us(200);
; 0000 0039     com |= 0x04;                // Е в единицу
	ORI  R30,4
	RCALL SUBOPT_0x0
; 0000 003A     spi(com);    // Вывод данных
; 0000 003B     SETBIT(PORTB,2);
; 0000 003C     //delay_us(1);
; 0000 003D     CLRBIT(PORTB,2);
; 0000 003E     //delay_us(200);
; 0000 003F     com &= 0xFB;                // Е в ноль
	ANDI R30,0xFB
	ST   Y,R30
; 0000 0040     spi(com);    // Вывод данных
	LD   R26,Y
	RCALL SUBOPT_0x1
; 0000 0041     SETBIT(PORTB,2);
; 0000 0042     //delay_us(1);
; 0000 0043     CLRBIT(PORTB,2);
; 0000 0044     delay_ms(2);
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x2
; 0000 0045 }
	RJMP _0x20A0002
; .FEND
;
;void lcd_com(unsigned char com)
; 0000 0048     {
_lcd_com:
; .FSTART _lcd_com
; 0000 0049       LCDcom(com & 0xF0);
	ST   -Y,R26
;	com -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	RCALL _LCDcom
; 0000 004A       LCDcom((com <<4)&0xF0);
	LD   R30,Y
	SWAP R30
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	RCALL _LCDcom
; 0000 004B     }
	RJMP _0x20A0002
; .FEND
;
;void LCDinit()
; 0000 004E {
_LCDinit:
; .FSTART _LCDinit
; 0000 004F     delay_ms(40);        // Пауза после подачи питания
	LDI  R26,LOW(40)
	RCALL SUBOPT_0x2
; 0000 0050     LCDcom(0x30);        // Переход в 4-х битный режим
	RCALL SUBOPT_0x3
; 0000 0051     delay_us(40);        // Задержка для выполнения команды
; 0000 0052     LCDcom(0x30);        // Переход в 4-х битный режим
	RCALL SUBOPT_0x3
; 0000 0053     delay_us(40);        // Задержка для выполнения команды
; 0000 0054     LCDcom(0x30);        // Переход в 4-х битный режим
	RCALL SUBOPT_0x3
; 0000 0055     delay_us(40);        // Задержка для выполнения команды
; 0000 0056     LCDcom(0x20);        // Переход в 4-х битный режим
	LDI  R26,LOW(32)
	RCALL _LCDcom
; 0000 0057     delay_us(40);        // Задержка для выполнения команды
	__DELAY_USB 213
; 0000 0058     LCDcom(0x20);        // Установка параметров
	LDI  R26,LOW(32)
	RCALL SUBOPT_0x4
; 0000 0059     LCDcom(0x80);        // Установка параметров
; 0000 005A     LCDcom(0x00);        // Выключаем дисплей
	RCALL SUBOPT_0x4
; 0000 005B     LCDcom(0x80);        // Выключаем дисплей
; 0000 005C     LCDcom(0x00);        // Очищаем дисплей
	RCALL _LCDcom
; 0000 005D     LCDcom(0x10);        // Очищаем дисплей
	LDI  R26,LOW(16)
	RCALL _LCDcom
; 0000 005E     LCDcom(0x00);        // Устанавливаем режим ввода данных
	LDI  R26,LOW(0)
	RCALL _LCDcom
; 0000 005F     LCDcom(0x60);        // Устанавливаем режим ввода данных
	LDI  R26,LOW(96)
	RCALL _LCDcom
; 0000 0060     LCDcom(0x00);        // Включаем дисплей с выбранным курсором
	LDI  R26,LOW(0)
	RCALL _LCDcom
; 0000 0061     LCDcom(0xC0);        // Включаем дисплей с выбранным курсором
	LDI  R26,LOW(192)
	RCALL _LCDcom
; 0000 0062 }
	RET
; .FEND
;
;void char_out(unsigned char data)
; 0000 0065 {
_char_out:
; .FSTART _char_out
; 0000 0066     unsigned char data_h = ((data & 0xF0) + 0x09);
; 0000 0067     unsigned char data_l = ((data << 4) + 0x09);
; 0000 0068 
; 0000 0069 	spi(data_h); // Передача старших 4 бит
	ST   -Y,R26
	RCALL __SAVELOCR2
;	data -> Y+2
;	data_h -> R17
;	data_l -> R16
	LDD  R30,Y+2
	ANDI R30,LOW(0xF0)
	SUBI R30,-LOW(9)
	MOV  R17,R30
	LDD  R30,Y+2
	SWAP R30
	ANDI R30,0xF0
	SUBI R30,-LOW(9)
	MOV  R16,R30
	MOV  R26,R17
	RCALL SUBOPT_0x1
; 0000 006A     SETBIT(PORTB,2);
; 0000 006B     //delay_us(1);
; 0000 006C     CLRBIT(PORTB,2);
; 0000 006D     //delay_us(200);
; 0000 006E 	data_h |= 0x04;
	ORI  R17,LOW(4)
; 0000 006F     spi(data_h); // Передача старших 4 бит
	MOV  R26,R17
	RCALL SUBOPT_0x1
; 0000 0070     SETBIT(PORTB,2);
; 0000 0071     //delay_us(1);
; 0000 0072     CLRBIT(PORTB,2);
; 0000 0073     delay_us(200);
	__DELAY_USW 800
; 0000 0074 	data_h &= 0xF9;
	ANDI R17,LOW(249)
; 0000 0075 	spi(data_h); // Передача старших 4 бит
	MOV  R26,R17
	RCALL SUBOPT_0x1
; 0000 0076     SETBIT(PORTB,2);
; 0000 0077     //delay_us(1);
; 0000 0078     CLRBIT(PORTB,2);
; 0000 0079 	delay_us(500);
	__DELAY_USW 2000
; 0000 007A 	spi(data_l); // Передача младших 4 бит
	MOV  R26,R16
	RCALL SUBOPT_0x1
; 0000 007B     SETBIT(PORTB,2);
; 0000 007C     //delay_us(1);
; 0000 007D     CLRBIT(PORTB,2);
; 0000 007E     //delay_us(200);
; 0000 007F 	data_l |= 0x04;
	ORI  R16,LOW(4)
; 0000 0080 	spi(data_l); // Передача младших 4 бит
	MOV  R26,R16
	RCALL SUBOPT_0x1
; 0000 0081     SETBIT(PORTB,2);
; 0000 0082     //delay_us(1);
; 0000 0083     CLRBIT(PORTB,2);
; 0000 0084     //delay_us(200);
; 0000 0085 	data_l &= 0xF9;
	ANDI R16,LOW(249)
; 0000 0086 	spi(data_l); // Передача младших 4 бит
	MOV  R26,R16
	RCALL SUBOPT_0x1
; 0000 0087     SETBIT(PORTB,2);
; 0000 0088     //delay_us(1);
; 0000 0089     CLRBIT(PORTB,2);
; 0000 008A     delay_ms(2);
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x2
; 0000 008B }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
; .FEND
;
;void str_out(char *str)
; 0000 008E     {
_str_out:
; .FSTART _str_out
; 0000 008F         while (*str!='\0')
	RCALL SUBOPT_0x5
;	*str -> Y+0
_0x3:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
; 0000 0090             {
; 0000 0091               char_out(*str++);
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RCALL _char_out
; 0000 0092             }
	RJMP _0x3
_0x5:
; 0000 0093     }
	RJMP _0x20A0005
; .FEND
;
;void strf_out(flash char *str)
; 0000 0096     {
_strf_out:
; .FSTART _strf_out
; 0000 0097         while (*str!='\0')
	RCALL SUBOPT_0x5
;	*str -> Y+0
_0x6:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x8
; 0000 0098             {
; 0000 0099               char_out(*str++);
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,1
	LPM  R26,Z
	RCALL _char_out
; 0000 009A             }
	RJMP _0x6
_0x8:
; 0000 009B     }
_0x20A0005:
	ADIW R28,2
	RET
; .FEND
;
;void lcd_printf(float f, unsigned char n){
; 0000 009D void lcd_printf(float f, unsigned char n){
_lcd_printf:
; .FSTART _lcd_printf
; 0000 009E     char *str = "";
; 0000 009F     ftoa(f, n, str);
	ST   -Y,R26
	RCALL __SAVELOCR2
;	f -> Y+3
;	n -> Y+2
;	*str -> R16,R17
	__POINTWRMN 16,17,_0x9,0
	__GETD1S 3
	RCALL __PUTPARD1
	LDD  R30,Y+6
	ST   -Y,R30
	MOVW R26,R16
	RCALL _ftoa
; 0000 00A0     str_out(str);
	MOVW R26,R16
	RCALL _str_out
; 0000 00A1 }
	RCALL __LOADLOCR2
	ADIW R28,7
	RET
; .FEND

	.DSEG
_0x9:
	.BYTE 0x1
;
;void check( float C){
; 0000 00A3 void check( float C){

	.CSEG
_check:
; .FSTART _check
; 0000 00A4  CUR1 = 0;
	RCALL __PUTPARD2
;	C -> Y+0
	RCALL SUBOPT_0x6
; 0000 00A5  CUR2 = 0;
; 0000 00A6  mode = 1;
	SET
	BLD  R2,0
; 0000 00A7  LCD_CLR;
	RCALL SUBOPT_0x7
; 0000 00A8  LCD_LINE1;
; 0000 00A9  strf_out("CHECK");
	__POINTW2FN _0x0,1
	RCALL _strf_out
; 0000 00AA  SETBIT(SFIOR, ACME);
	IN   R30,0x30
	ORI  R30,8
	OUT  0x30,R30
; 0000 00AB  SETBIT(TCCR1B,CS11);
	RCALL SUBOPT_0x8
; 0000 00AC  #asm("sei")
	sei
; 0000 00AD  SETBIT(PORTD, PORTD0);
	SBI  0x12,0
; 0000 00AE  DISCH=1;
	RCALL SUBOPT_0x9
; 0000 00AF  delay_ms(1000);
; 0000 00B0  CUR2=1;
	SBI  0x12,7
; 0000 00B1  DISCH=0;
	RCALL SUBOPT_0xA
; 0000 00B2  TCNT1=0;
; 0000 00B3  CLRBIT(TIMSK, TICIE1);
; 0000 00B4  ADMUX &= ~((1 << MUX3) | (1 << MUX2) | (1 << MUX1) | (1 << MUX0));
; 0000 00B5  SETBIT(TIFR,ICF1);
; 0000 00B6  SETBIT(TIMSK, TICIE1);
; 0000 00B7  T1=0;
; 0000 00B8  T2=0;
; 0000 00B9  t=0;
; 0000 00BA  while(!T2);
_0x14:
	RCALL SUBOPT_0xB
	RCALL __CPD10
	BREQ _0x14
; 0000 00BB  CUR2=0;
	CBI  0x12,7
; 0000 00BC  I2 = (1265)/((float)T2/(CLK/CLK_PSL))*C;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL __EEPROMWRD
; 0000 00BD 
; 0000 00BE 
; 0000 00BF 
; 0000 00C0 
; 0000 00C1  DISCH=1;
	RCALL SUBOPT_0x9
; 0000 00C2  delay_ms(1000);
; 0000 00C3  CUR1=1;
	SBI  0x18,0
; 0000 00C4  DISCH=0;
	RCALL SUBOPT_0xA
; 0000 00C5  TCNT1=0;
; 0000 00C6  CLRBIT(TIMSK, TICIE1);
; 0000 00C7  ADMUX &= ~((1 << MUX3) | (1 << MUX2) | (1 << MUX1) | (1 << MUX0));
; 0000 00C8  SETBIT(TIFR,ICF1);
; 0000 00C9  SETBIT(TIMSK, TICIE1);
; 0000 00CA  T1=0;
; 0000 00CB  T2=0;
; 0000 00CC  t=0;
; 0000 00CD  while(!T2);
_0x1F:
	RCALL SUBOPT_0xB
	RCALL __CPD10
	BREQ _0x1F
; 0000 00CE  CUR1=0;
	CBI  0x18,0
; 0000 00CF  I1 = (1265)/((float)T2/(CLK/CLK_PSL))*C;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xE
	RCALL __EEPROMWRD
; 0000 00D0 
; 0000 00D1 
; 0000 00D2  DISCH=1;
	SBI  0x18,1
; 0000 00D3  LCD_CLR;
	RCALL SUBOPT_0x7
; 0000 00D4  LCD_LINE1;
; 0000 00D5  lcd_printf(I1,1 );
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
; 0000 00D6  strf_out("mA");
; 0000 00D7  LCD_LINE2;
	RCALL SUBOPT_0x10
; 0000 00D8  lcd_printf(I2,1);
; 0000 00D9  strf_out("mA");
; 0000 00DA  CLRBIT(PORTD, PORTD0);
	CBI  0x12,0
; 0000 00DB 
; 0000 00DC  mode = 0;
	CLT
	BLD  R2,0
; 0000 00DD  CLRBIT(TCCR1B,CS11);
	IN   R30,0x2E
	ANDI R30,0xFD
	OUT  0x2E,R30
; 0000 00DE 
; 0000 00DF 
; 0000 00E0 }
	RJMP _0x20A0001
; .FEND
;
;float testC(){
; 0000 00E2 float testC(){
_testC:
; .FSTART _testC
; 0000 00E3 float C = 0;
; 0000 00E4 #asm("cli")
	RCALL SUBOPT_0x11
;	C -> Y+0
	cli
; 0000 00E5 CUR1 = 0;
	RCALL SUBOPT_0x6
; 0000 00E6 CUR2 = 0;
; 0000 00E7 DISCH=1;
	RCALL SUBOPT_0x9
; 0000 00E8 delay_ms(1000);
; 0000 00E9 SETBIT(TCCR1B,CS11);
	RCALL SUBOPT_0x8
; 0000 00EA CLRBIT(ADMUX,MUX0);
	RCALL SUBOPT_0x12
; 0000 00EB SETBIT(TIFR,ICF1);
; 0000 00EC #asm("sei")
	sei
; 0000 00ED CUR1=1;
	SBI  0x18,0
; 0000 00EE t = 0;
	RCALL SUBOPT_0x13
; 0000 00EF TCNT1 = 0;
; 0000 00F0 T1 = 0;
; 0000 00F1 T2 = 0;
; 0000 00F2 DISCH = 0;
; 0000 00F3 while (!T1);
_0x30:
	RCALL SUBOPT_0x14
	BREQ _0x30
; 0000 00F4 if (t > 4) {  //~>1000uF
	RCALL SUBOPT_0x15
	__CPD2N 0x5
	BRLO _0x33
; 0000 00F5     #asm("cli")
	cli
; 0000 00F6     CUR1 = 0;
	CBI  0x18,0
; 0000 00F7     DISCH = 1;
	SBI  0x18,1
; 0000 00F8     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 00F9     CLRBIT(ADMUX,MUX0);
	RCALL SUBOPT_0x12
; 0000 00FA     SETBIT(TIFR,ICF1);
; 0000 00FB     #asm("sei")
	sei
; 0000 00FC     CUR2 = 1;
	SBI  0x12,7
; 0000 00FD     t = 0;
	RCALL SUBOPT_0x13
; 0000 00FE     TCNT1 = 0;
; 0000 00FF     T1 = 0;
; 0000 0100     T2 = 0;
; 0000 0101     DISCH = 0;
; 0000 0102     while (!T1);
_0x3C:
	RCALL SUBOPT_0x14
	BREQ _0x3C
; 0000 0103     while ((T2<T1/2) | (!T2));
_0x3F:
	RCALL SUBOPT_0x16
	BRNE _0x3F
; 0000 0104     CUR2 = 0;
	CBI  0x12,7
; 0000 0105     C =  (I2*((float)T2/(CLK/CLK_PSL)))/(1265);
	RCALL SUBOPT_0xD
	RCALL __EEPROMRDD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x17
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RJMP _0x6C
; 0000 0106 }
; 0000 0107 else {
_0x33:
; 0000 0108     while ((T2<T1/2) | (!T2));
_0x45:
	RCALL SUBOPT_0x16
	BRNE _0x45
; 0000 0109     CUR1 = 0;
	CBI  0x18,0
; 0000 010A     C =  (I1*((float)T2/(CLK/CLK_PSL)))/(1265);
	RCALL SUBOPT_0xE
	RCALL __EEPROMRDD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x17
	POP  R26
	POP  R27
	POP  R24
	POP  R25
_0x6C:
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x449E2000
	RCALL __DIVF21
	RCALL SUBOPT_0x18
; 0000 010B }
; 0000 010C return C;
	RCALL SUBOPT_0x19
	RJMP _0x20A0001
; 0000 010D }
; .FEND
;
;
;float esr(float C){
; 0000 0110 float esr(float C){
_esr:
; .FSTART _esr
; 0000 0111     float R = 0;
; 0000 0112     #asm("cli")
	RCALL __PUTPARD2
	RCALL SUBOPT_0x11
;	C -> Y+4
;	R -> Y+0
	cli
; 0000 0113     CUR1 = 0;
	RCALL SUBOPT_0x6
; 0000 0114     CUR2 = 0;
; 0000 0115     DISCH = 1;
	SBI  0x18,1
; 0000 0116     delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 0117     SETBIT(TCCR1B,CS11);
	RCALL SUBOPT_0x8
; 0000 0118     //CLRBIT(ADMUX,MUX0);
; 0000 0119     ADMUX |= (0 << MUX3) | (0 << MUX2) | (1 << MUX1) | (0 << MUX0);
	SBI  0x7,1
; 0000 011A     SETBIT(TIFR,ICF1);
	RCALL SUBOPT_0x1A
; 0000 011B     #asm("sei")
	sei
; 0000 011C     DISCH = 0;
	CBI  0x18,1
; 0000 011D     CUR2 = 1;
	SBI  0x12,7
; 0000 011E     TCNT1 = 0;
	RCALL SUBOPT_0x1B
; 0000 011F                 //пока оставить такой порядок, наиболее точно и быстро
; 0000 0120     t = 0;
	RCALL SUBOPT_0x1C
; 0000 0121     T1 = 0;
	LDI  R30,LOW(0)
	STS  _T1,R30
	STS  _T1+1,R30
	STS  _T1+2,R30
	STS  _T1+3,R30
; 0000 0122     while(!T1);
_0x54:
	RCALL SUBOPT_0x14
	BREQ _0x54
; 0000 0123     R = (1235)/I2 - ((float)T1/(CLK/CLK_PSL))/C;
	RCALL SUBOPT_0xD
	RCALL __EEPROMRDD
	__GETD2N 0x449A6000
	RCALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_T1
	LDS  R31,_T1+1
	LDS  R22,_T1+2
	LDS  R23,_T1+3
	RCALL __CDF1U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40000000
	RCALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x1D
	RCALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x18
; 0000 0124     CUR1 = 0;
	RCALL SUBOPT_0x6
; 0000 0125     CUR2 = 0;
; 0000 0126     DISCH = 1;
	SBI  0x18,1
; 0000 0127     return R;
	RCALL SUBOPT_0x19
	ADIW R28,8
	RET
; 0000 0128 }
; .FEND
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 012D {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x1E
; 0000 012E     delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x2
; 0000 012F     SETBIT(TIFR,ICF1);
	RCALL SUBOPT_0x1A
; 0000 0130     #asm("sei")
	sei
; 0000 0131     check(6.89);
	__GETD2N 0x40DC7AE1
	RCALL _check
; 0000 0132 }
	RJMP _0x6F
; .FEND
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0138 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	RCALL SUBOPT_0x1E
; 0000 0139         t++;
	LDI  R26,LOW(_t)
	LDI  R27,HIGH(_t)
	RCALL __GETD1P_INC
	__SUBD1N -1
	RCALL __PUTDP1_DEC
; 0000 013A         if((t > (CLK/CLK_PSL)*30) & (!mode)){
	RCALL SUBOPT_0x15
	__GETD1N 0x3C
	RCALL __GTD12U
	MOV  R26,R30
	LDI  R30,0
	SBRS R2,0
	LDI  R30,1
	AND  R30,R26
	BREQ _0x5D
; 0000 013B             LCD_CLR;
	RCALL SUBOPT_0x1F
; 0000 013C             strf_out("ERROR");
	__POINTW2FN _0x0,10
	RCALL _strf_out
; 0000 013D         }
; 0000 013E 
; 0000 013F }
_0x5D:
_0x6F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;interrupt [TIM1_CAPT] void timer1_capt_isr(void)
; 0000 0143 {
_timer1_capt_isr:
; .FSTART _timer1_capt_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0144         if (TSTBIT(ADMUX, MUX1)) {
	SBIS 0x7,1
	RJMP _0x5E
; 0000 0145             TCNT1 = 0;                                //мултиплексор на 0
	RCALL SUBOPT_0x1B
; 0000 0146             //PORTD.0 = 1;
; 0000 0147             ADMUX &= ~((1 << MUX3) | (1 << MUX2) | (1 << MUX1) | (1 << MUX0));
	IN   R30,0x7
	ANDI R30,LOW(0xF0)
	OUT  0x7,R30
; 0000 0148             }
; 0000 0149         else if (TSTBIT(ADMUX, MUX0)==0){
	RJMP _0x5F
_0x5E:
	SBIC 0x7,0
	RJMP _0x60
; 0000 014A             TCNT1=0;
	RCALL SUBOPT_0x1B
; 0000 014B             //PORTD.1 = 1;
; 0000 014C             SETBIT(ADMUX, MUX0);
	SBI  0x7,0
; 0000 014D             T1 = t*0xFFFF + ICR1;
	RCALL SUBOPT_0x20
	STS  _T1,R30
	STS  _T1+1,R31
	STS  _T1+2,R22
	STS  _T1+3,R23
; 0000 014E             T2=0;
	LDI  R30,LOW(0)
	STS  _T2,R30
	STS  _T2+1,R30
	STS  _T2+2,R30
	STS  _T2+3,R30
; 0000 014F             t=0;
	RCALL SUBOPT_0x1C
; 0000 0150 
; 0000 0151 
; 0000 0152         }
; 0000 0153         else{
	RJMP _0x61
_0x60:
; 0000 0154             //PORTD.3 = 1;
; 0000 0155             T2 = t*0xFFFF + ICR1;
	RCALL SUBOPT_0x20
	STS  _T2,R30
	STS  _T2+1,R31
	STS  _T2+2,R22
	STS  _T2+3,R23
; 0000 0156         }
_0x61:
_0x5F:
; 0000 0157          SETBIT(TIFR,ICF1);
	RCALL SUBOPT_0x1A
; 0000 0158 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;void main(void)
; 0000 015D {
_main:
; .FSTART _main
; 0000 015E // Declare your local variables here
; 0000 015F float C = 0, R=0;
; 0000 0160 
; 0000 0161 
; 0000 0162 // Input/Output Ports initialization
; 0000 0163 // Port B initialization
; 0000 0164 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0165 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	SBIW R28,8
	RCALL SUBOPT_0x21
	LDI  R30,LOW(0)
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
;	C -> Y+4
;	R -> Y+0
	LDI  R30,LOW(47)
	OUT  0x17,R30
; 0000 0166 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0167 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0168 
; 0000 0169 // Port C initialization
; 0000 016A // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 016B DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 016C // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 016D PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 016E 
; 0000 016F // Port D initialization
; 0000 0170 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0171 DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(129)
	OUT  0x11,R30
; 0000 0172 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0173 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 0174 
; 0000 0175 // Timer/Counter 0 initialization
; 0000 0176 // Clock source: System Clock
; 0000 0177 // Clock value: 1000,000 kHz
; 0000 0178 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0179 TCNT0=0x00;
	OUT  0x32,R30
; 0000 017A 
; 0000 017B // Timer/Counter 1 initialization
; 0000 017C // Clock source: System Clock
; 0000 017D // Clock value: 1000,000 kHz
; 0000 017E // Mode: Normal top=0xFFFF
; 0000 017F // OC1A output: Disconnected
; 0000 0180 // OC1B output: Disconnected
; 0000 0181 // Noise Canceler: Off
; 0000 0182 // Input Capture on Rising Edge
; 0000 0183 // Timer Period: 65,536 ms
; 0000 0184 // Timer1 Overflow Interrupt: On
; 0000 0185 // Input Capture Interrupt: On
; 0000 0186 // Compare A Match Interrupt: Off
; 0000 0187 // Compare B Match Interrupt: Off
; 0000 0188 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0189 TCCR1B=(0<<ICNC1) | (1<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(66)
	OUT  0x2E,R30
; 0000 018A TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 018B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 018C ICR1H=0x00;
	OUT  0x27,R30
; 0000 018D ICR1L=0x00;
	OUT  0x26,R30
; 0000 018E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 018F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0190 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0191 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0192 
; 0000 0193 // Timer/Counter 2 initialization
; 0000 0194 // Clock source: System Clock
; 0000 0195 // Clock value: Timer2 Stopped
; 0000 0196 // Mode: Normal top=0xFF
; 0000 0197 // OC2 output: Disconnected
; 0000 0198 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0199 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 019A TCNT2=0x00;
	OUT  0x24,R30
; 0000 019B OCR2=0x00;
	OUT  0x23,R30
; 0000 019C 
; 0000 019D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 019E TIMSK=(0<<OCIE2) | (0<<TOIE2) | (1<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(36)
	OUT  0x39,R30
; 0000 019F 
; 0000 01A0 // External Interrupt(s) initialization
; 0000 01A1 // INT0: On
; 0000 01A2 // INT0 Mode: Any change
; 0000 01A3 // INT1: Off
; 0000 01A4 GICR|=(0<<INT1) | (1<<INT0);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 01A5 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (1<<ISC00);
	LDI  R30,LOW(1)
	OUT  0x35,R30
; 0000 01A6 GIFR=(0<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 01A7 
; 0000 01A8 // USART initialization
; 0000 01A9 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01AA // USART Receiver: Off
; 0000 01AB // USART Transmitter: On
; 0000 01AC // USART Mode: Asynchronous
; 0000 01AD // USART Baud Rate: 9600
; 0000 01AE UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01AF UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 01B0 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01B1 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01B2 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01B3 
; 0000 01B4 // Analog Comparator initialization
; 0000 01B5 // Analog Comparator: On
; 0000 01B6 // The Analog Comparator's positive input is
; 0000 01B7 // connected to the AIN0 pin
; 0000 01B8 // The Analog Comparator's negative input is
; 0000 01B9 // connected to the ADC multiplexer
; 0000 01BA // Interrupt on Rising Output Edge
; 0000 01BB // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01BC ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (1<<ACI) | (0<<ACIE) | (1<<ACIC) | (1<<ACIS1) | (1<<ACIS0);
	LDI  R30,LOW(23)
	OUT  0x8,R30
; 0000 01BD SFIOR=(1<<ACME);
	LDI  R30,LOW(8)
	OUT  0x30,R30
; 0000 01BE 
; 0000 01BF // ADC initialization
; 0000 01C0 // ADC disabled
; 0000 01C1 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(7)
	OUT  0x6,R30
; 0000 01C2 ADMUX = 0;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 01C3 
; 0000 01C4 // SPI initialization
; 0000 01C5 // SPI Type: Master
; 0000 01C6 // SPI Clock Rate: 500,000 kHz
; 0000 01C7 // SPI Clock Phase: Cycle Start
; 0000 01C8 // SPI Clock Polarity: Low
; 0000 01C9 // SPI Data Order: MSB First
; 0000 01CA if (CLK <= 16) SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (1<<SPR0);
	LDI  R30,LOW(81)
; 0000 01CB else   SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (1<<SPR1) | (1<<SPR0);
_0x6D:
	OUT  0xD,R30
; 0000 01CC SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 01CD 
; 0000 01CE // TWI initialization
; 0000 01CF // TWI disabled
; 0000 01D0 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 01D1 
; 0000 01D2 // Global enable interrupts
; 0000 01D3 DISCH=1;
	SBI  0x18,1
; 0000 01D4 SETBIT(TIFR,ICF1);
	RCALL SUBOPT_0x1A
; 0000 01D5 #asm("cli")
	cli
; 0000 01D6 LCDinit();
	RCALL _LCDinit
; 0000 01D7 delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x2
; 0000 01D8 lcd_printf(I1, 1);
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
; 0000 01D9 strf_out("mA");
; 0000 01DA LCD_LINE2;
	RCALL SUBOPT_0x10
; 0000 01DB lcd_printf(I2,1);
; 0000 01DC strf_out("mA");
; 0000 01DD delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 01DE 
; 0000 01DF LCD_CLR;
	RCALL SUBOPT_0x1F
; 0000 01E0 strf_out("TESTING");
	__POINTW2FN _0x0,16
	RCALL _strf_out
; 0000 01E1 
; 0000 01E2 C = testC();
	RCALL _testC
	__PUTD1S 4
; 0000 01E3 R = esr(C);
	RCALL SUBOPT_0x22
	RCALL _esr
	RCALL SUBOPT_0x18
; 0000 01E4 CLRBIT(TCCR1B,CS11);
	IN   R30,0x2E
	ANDI R30,0xFD
	OUT  0x2E,R30
; 0000 01E5 
; 0000 01E6 
; 0000 01E7 
; 0000 01E8 while (1)
_0x66:
; 0000 01E9       {
; 0000 01EA         LCD_CLR;
	RCALL SUBOPT_0x1F
; 0000 01EB         if ( C > 1000){
	RCALL SUBOPT_0x22
	__GETD1N 0x447A0000
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x69
; 0000 01EC             lcd_printf( C, 0);
	RCALL SUBOPT_0x1D
	RCALL __PUTPARD1
	LDI  R26,LOW(0)
	RJMP _0x6E
; 0000 01ED         }
; 0000 01EE         else{
_0x69:
; 0000 01EF             lcd_printf(C, 2);
	RCALL SUBOPT_0x1D
	RCALL __PUTPARD1
	LDI  R26,LOW(2)
_0x6E:
	RCALL _lcd_printf
; 0000 01F0         }
; 0000 01F1         LCD_LINE2;
	LDI  R26,LOW(192)
	RCALL _lcd_com
; 0000 01F2         strf_out("    uf");
	__POINTW2FN _0x0,24
	RCALL SUBOPT_0x23
; 0000 01F3         delay_ms(1000);
; 0000 01F4         LCD_CLR;
	RCALL SUBOPT_0x1F
; 0000 01F5         lcd_printf(R, 3); //!!!!!!!!!!!!!
	RCALL SUBOPT_0x19
	RCALL __PUTPARD1
	LDI  R26,LOW(3)
	RCALL _lcd_printf
; 0000 01F6         LCD_LINE2;
	LDI  R26,LOW(192)
	RCALL _lcd_com
; 0000 01F7         strf_out("    ohm");
	__POINTW2FN _0x0,31
	RCALL SUBOPT_0x23
; 0000 01F8         delay_ms(1000);
; 0000 01F9       }
	RJMP _0x66
; 0000 01FA }
_0x6B:
	RJMP _0x6B
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x5
	SBIW R28,4
	RCALL SUBOPT_0x21
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR2
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200000D
	RCALL SUBOPT_0x24
	__POINTW2FN _0x2000000,0
	RCALL _strcpyf
	RJMP _0x20A0004
_0x200000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200000C
	RCALL SUBOPT_0x24
	__POINTW2FN _0x2000000,1
	RCALL _strcpyf
	RJMP _0x20A0004
_0x200000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x200000F
	RCALL SUBOPT_0x25
	RCALL __ANEGF1
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x27
	LDI  R30,LOW(45)
	ST   X,R30
_0x200000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2000010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2000010:
	LDD  R17,Y+8
_0x2000011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000013
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	RJMP _0x2000011
_0x2000013:
	RCALL SUBOPT_0x2B
	RCALL __ADDF12
	RCALL SUBOPT_0x26
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x2A
_0x2000014:
	RCALL SUBOPT_0x2B
	RCALL __CMPF12
	BRLO _0x2000016
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2A
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2000017
	RCALL SUBOPT_0x24
	__POINTW2FN _0x2000000,5
	RCALL _strcpyf
	RJMP _0x20A0004
_0x2000017:
	RJMP _0x2000014
_0x2000016:
	CPI  R17,0
	BRNE _0x2000018
	RCALL SUBOPT_0x27
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2000019
_0x2000018:
_0x200001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001C
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	__GETD2N 0x3F000000
	RCALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x28
	RCALL __CWD1
	RCALL __CDF1
	RCALL __MULF12
	RCALL SUBOPT_0x2E
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x26
	RJMP _0x200001A
_0x200001C:
_0x2000019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0003
	RCALL SUBOPT_0x27
	LDI  R30,LOW(46)
	ST   X,R30
_0x200001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2000020
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x25
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2E
	RCALL __CWD1
	RCALL __CDF1
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x26
	RJMP _0x200001E
_0x2000020:
_0x20A0003:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0004:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_spi:
; .FSTART _spi
	ST   -Y,R26
	LD   R30,Y
	OUT  0xF,R30
_0x2020003:
	SBIS 0xE,7
	RJMP _0x2020003
	IN   R30,0xF
_0x20A0002:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL SUBOPT_0x18
    brne __floor1
__floor0:
	RCALL SUBOPT_0x19
	RJMP _0x20A0001
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x19
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20A0001:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	RCALL SUBOPT_0x5
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND

	.DSEG
_t:
	.BYTE 0x4
_T1:
	.BYTE 0x4
_T2:
	.BYTE 0x4

	.ESEG
_I1:
	.DB  0x0,0x0,0x28,0x41
_I2:
	.DB  0x9A,0x99,0xE2,0x42

	.DSEG
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   Y,R30
	LD   R26,Y
	RCALL _spi
	SBI  0x18,2
	CBI  0x18,2
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	RCALL _spi
	SBI  0x18,2
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(48)
	RCALL _LCDcom
	__DELAY_USB 213
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL _LCDcom
	LDI  R26,LOW(128)
	RCALL _LCDcom
	LDI  R26,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CBI  0x18,0
	CBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(1)
	RCALL _lcd_com
	LDI  R26,LOW(128)
	RJMP _lcd_com

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	IN   R30,0x2E
	ORI  R30,2
	OUT  0x2E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	SBI  0x18,1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xA:
	CBI  0x18,1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	IN   R30,0x39
	ANDI R30,0xDF
	OUT  0x39,R30
	IN   R30,0x7
	ANDI R30,LOW(0xF0)
	OUT  0x7,R30
	IN   R30,0x38
	ORI  R30,0x20
	OUT  0x38,R30
	IN   R30,0x39
	ORI  R30,0x20
	OUT  0x39,R30
	LDI  R30,LOW(0)
	STS  _T1,R30
	STS  _T1+1,R30
	STS  _T1+2,R30
	STS  _T1+3,R30
	STS  _T2,R30
	STS  _T2+1,R30
	STS  _T2+2,R30
	STS  _T2+3,R30
	STS  _t,R30
	STS  _t+1,R30
	STS  _t+2,R30
	STS  _t+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0xB:
	LDS  R30,_T2
	LDS  R31,_T2+1
	LDS  R22,_T2+2
	LDS  R23,_T2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0xB
	RCALL __CDF1U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40000000
	RCALL __DIVF21
	__GETD2N 0x449E2000
	RCALL __DIVF21
	RCALL __GETD2S0
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_I2)
	LDI  R27,HIGH(_I2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_I1)
	LDI  R27,HIGH(_I1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xF:
	RCALL __EEPROMRDD
	RCALL __PUTPARD1
	LDI  R26,LOW(1)
	RCALL _lcd_printf
	__POINTW2FN _0x0,7
	RJMP _strf_out

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(192)
	RCALL _lcd_com
	RCALL SUBOPT_0xD
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CBI  0x7,0
	IN   R30,0x38
	ORI  R30,0x20
	OUT  0x38,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	STS  _t,R30
	STS  _t+1,R30
	STS  _t+2,R30
	STS  _t+3,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	STS  _T1,R30
	STS  _T1+1,R30
	STS  _T1+2,R30
	STS  _T1+3,R30
	STS  _T2,R30
	STS  _T2+1,R30
	STS  _T2+2,R30
	STS  _T2+3,R30
	CBI  0x18,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x14:
	LDS  R30,_T1
	LDS  R31,_T1+1
	LDS  R22,_T1+2
	LDS  R23,_T1+3
	RCALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDS  R26,_t
	LDS  R27,_t+1
	LDS  R24,_t+2
	LDS  R25,_t+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x16:
	LDS  R30,_T1
	LDS  R31,_T1+1
	LDS  R22,_T1+2
	LDS  R23,_T1+3
	RCALL __LSRD1
	LDS  R26,_T2
	LDS  R27,_T2+1
	LDS  R24,_T2+2
	LDS  R25,_T2+3
	RCALL __LTD12U
	MOV  R26,R30
	RCALL SUBOPT_0xB
	RCALL __LNEGD1
	OR   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	RCALL SUBOPT_0xB
	RCALL __CDF1U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40000000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x19:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	IN   R30,0x38
	ORI  R30,0x20
	OUT  0x38,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	STS  _t,R30
	STS  _t+1,R30
	STS  _t+2,R30
	STS  _t+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1E:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(1)
	RJMP _lcd_com

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x20:
	LDS  R30,_t
	LDS  R31,_t+1
	LDS  R22,_t+2
	LDS  R23,_t+3
	__GETD2N 0xFFFF
	RCALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	IN   R30,0x26
	IN   R31,0x26+1
	CLR  R22
	CLR  R23
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	RCALL _strf_out
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x24:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x26:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x27:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2A:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2B:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2D:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2E:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSRD1:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LTD12U:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	LDI  R30,1
	BRLO __LTD12UT
	CLR  R30
__LTD12UT:
	RET

__GTD12U:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	LDI  R30,1
	BRLO __GTD12UT
	CLR  R30
__GTD12UT:
	RET

__LNEGD1:
	OR   R30,R31
	OR   R30,R22
	OR   R30,R23
	LDI  R30,1
	BREQ __LNEGD1F
	LDI  R30,0
__LNEGD1F:
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
