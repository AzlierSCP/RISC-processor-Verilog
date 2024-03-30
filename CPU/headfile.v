`ifndef HEADFILE_H_

//State for CPU
`define	idle		1'b0
`define	exec		1'b1

//Data transfer & Arithmetic


`define  ADD		4'b0000
`define	SUB		4'b0001
`define	AND		4'b0010
`define	OR		   4'b0011 
`define	XOR		4'b0100 
`define	NOT		4'b0101   //new Rd = ~Rs 
`define	SLA		4'b0110
`define	SRA		4'b0110 

`define	LI		   4'b1000   //new
`define	LW	   	4'b1001   //new
`define	SW		   4'b1010   //new

`define	BZ		   4'b1011   //BIZ? not sure
`define	BNZ		4'b1100

`define	JAL		4'b1101   //new
`define	JUMP		4'b1110   //JMP? 
`define	JR		   4'b1111   //new  Rd == 0000 
`define  HALT		4'b1111   //EOE? Rd == 1111
`define  EOE		4'b1111   //new  Rd == 1111


//not used, Need to be removed
`define  NOP		4'b00000
`define  LOAD		4'b00010
`define  STORE		4'b00011
`define  LDIH		4'b10000
`define	ADDI		4'b01001
`define	ADDC		4'b10001
`define	CMP		4'b01100
`define	SLL		4'b00100
`define	JMPR		4'b11001
`define	BN			4'b11100
`define	BC			4'b11110
`define 	SUBI  	4'b01011
`define 	SUBC  	4'b10010
`define 	SRL   	4'b00110
`define 	BNN   	4'b11101
`define 	BNC   	4'b11111

//gr general register?    3->4  !!!!!
`define gr0 4'b0000
`define gr1 4'b0001
`define gr2 4'b0010
`define gr3 4'b0011

`endif
