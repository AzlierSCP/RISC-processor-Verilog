`timescale 1ns / 1ps
`include"headfile.v"

module ControlUnit(
	input [15:0] Instr,
	output MemtoReg,
	output MemWrite,
	output reg Branch,
	output [3:0] ALUControl,  //changed 5->4
	output reg ALUSrc,
	output reg RegWrite,
	output Jump,
	output enable,
	output reg [3:0] rs,      //changed 3->4
	output reg [3:0] rt,
	output [3:0] rd,
	output reg [15:0] SignImm16
    );
	
	wire [3:0] Op;            //  5->4
	assign Op = Instr[15:12];  //The high 4 bits of the instruction are Op
	
	
	//Set A1(rs) Set the value position of A1 according to the truth table
	always@(*)
	begin
		if((Op == `BZ)				
		 ||(Op == `BN)				
		 ||(Op == `JMPR)			
		 ||(Op == `BC)				
		 ||(Op == `BNZ)			
		 ||(Op == `BNN)			
		 ||(Op == `BNC)			
		 ||(Op == `ADDI)			
		 ||(Op == `SUBI)			
		 ||(Op == `LDIH))			
			rs <= Instr[10:8];
		else							
			rs <= Instr[6:4];
	end
	
	//Set A2(rt) 根据真值表设置A2的取值位置   Set the value position of A2 according to the truth table
	always@(*)
	begin
		if(Op == `STORE)
			rt <= Instr[10:8];
		else
			rt <= Instr[2:0];
	end
	
	//Set A3(rd) 根据真值表设置A3的取值位置    Set the value position of A3 according to the truth table
	assign rd = Instr[10:8];

	//Set SignImm16 根据真值表设置立即数的取值位置        Set the position of the immediate number according to the truth table
	always@(*)	//只要立即数存在，ALUSrc的选择即为立即数1  As long as the immediate number exists, the selection of ALUSrc is the immediate number 1
	begin
		if((Op == `LOAD)
		 ||(Op == `STORE)
		 ||(Op == `SLL)
		 ||(Op == `SRL)
		 ||(Op == `SLA)
		 ||(Op == `SRA))
			begin
				SignImm16 <= { {12{1'b0}}, Instr[3:0]};
				ALUSrc <= 1'b1;
			end
		else if((Op == `ADDI)
		      ||(Op == `SUBI)
				||(Op == `JUMP)
				||(Op == `JMPR)
				||(Op == `BZ)
				||(Op == `BNZ)
				||(Op == `BN)
				||(Op == `BNN)
				||(Op == `BC)
				||(Op == `BNC))
			begin
				SignImm16 <= { {8{1'b0}}, Instr[7:0]};
				ALUSrc <= 1'b1;
			end
		else if(Op == `LDIH)
			begin
				SignImm16 <= {Instr[7:0], {8{1'b0}}};
				ALUSrc <= 1'b1;
			end
		else//其余情况，立即数为空值x，ALUSrc选择不为立即数   In the rest of the cases, the immediate number is the null value x and ALUSrc chooses not to be the immediate number
			begin
				SignImm16 <= { {16{1'bx}} }; 
				ALUSrc <= 1'b0;
			end
	end
	//ALUControl与Op一致  ALUControl is consistent with Op
	assign ALUControl = Op;
	//MemtoReg当且仅当LOAD指令时为1  MemtoReg is 1 when and only when LOAD command
	assign MemtoReg = (Op == `LOAD);
	//MemWrite当且仅当STORE指令时为1  MemWrite is 1 when and only when the STORE instruction
	assign MemWrite = (Op == `STORE);
	//Jump当指令为跳转类型时为1   Jump is 1 when the instruction is a jump type
	assign Jump = ( (Op == `JUMP) || (Op == `JMPR));
	
	//Set Branch 仅当分支指令时为1  1 only when branch instruction
	always@(*)
	begin
		if((Op == `BZ)
		 ||(Op == `BNZ)
		 ||(Op == `BN)
		 ||(Op == `BNN)
		 ||(Op == `BC)
		 ||(Op == `BNC))
			Branch <= 1'b1;
		else
			Branch <= 1'b0;
	end
	
	//Set RegWrite 根据真值表设置RegWrite的取值  Set the value of RegWrite according to the truth table
	always@(*)
	begin
		if((Op == `LOAD)
		 ||(Op == `LDIH)
		 ||(Op == `ADD)
		 ||(Op == `SUB)
		 ||(Op == `ADDI)
		 ||(Op == `SUBI)
		 ||(Op == `ADDC)
		 ||(Op == `SUBC)
		 ||(Op == `AND)
		 ||(Op == `OR)
		 ||(Op == `XOR)
		 ||(Op == `SLL)
		 ||(Op == `SRL)
		 ||(Op == `SLA)
		 ||(Op == `SRA))
			RegWrite <= 1'b1;
		else
			RegWrite <= 1'b0;
	end
	//遇到终止指令时，关闭CPU   Shut down the CPU when an abort instruction is encountered
	assign enable = ~(Op == `HALT);
	
endmodule

