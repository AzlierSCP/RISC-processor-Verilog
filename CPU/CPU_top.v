`timescale 1ns / 1ps


module CPU_top(
   input CLK,
	input reset,
	output [7:0] OPT_PC
	
	
	
	
	
    );

   reg [7:0] PC;
	wire [15:0] Instr;
	wire [3:0] rs;
	wire [3:0] rt;
	wire [3:0] rd;
	wire [15:0] SignImm16;
	wire MemtoReg, MemWrite, Branch, ALUSrc, RegWrite, Jump;
	wire [3:0] ALUControl;
	wire JorB, PCSrc, Flag;
	wire [15:0] RD1_out;
	wire [15:0] RD2_out;
	wire [15:0] SrcA;
	wire [15:0] SrcB;
	wire [15:0] ALUResult;
	wire [15:0] WriteData;
	wire [15:0] ReadData;
	wire [15:0] Result;
	wire [7:0] NextPC;
	wire enable;
	
    initial begin
        PC = 8'b00000000;
    end
	 
	
	InstructionMemory IM(
		.A(PC),
		.RD(Instr)
	);
	
	ControlUnit CU(
		.Instr(Instr),
		.MemtoReg(MemtoReg),
		.MemWrite(MemWrite),
		.Branch(Branch),
		.ALUControl(ALUControl),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite),
		.Jump(Jump),
		.enable(enable),
		.rs(rs),
		.rt(rt),
		.rd(rd),
		.SignImm16(SignImm16)
   );
	 
	RegisterFile RF(
		.CLK(CLK),
		.A1(rs),
		.A2(rt),
		.A3(rd),
		.WD3(Result),
		.WE3(RegWrite),
		.RD1(RD1_out),
		.RD2(RD2_out)
   );
	
	assign SrcA = RD1_out;
	assign SrcB = (ALUSrc) ? SignImm16 : RD2_out;
	ALU alu(
		.CLK(CLK),
		.ALUControl(ALUControl),
		.SrcA(SrcA),
		.SrcB(SrcB),
		.ALUResult(ALUResult),
		.Flag(Flag)
   );
	
	assign WriteData = RD2_out;
	DataMemory DM(
		.CLK(CLK),
		.WE(MemWrite),
		.A(ALUResult),
		.WD(WriteData),
		.RD(ReadData)
   );
	assign Result = (MemtoReg) ? ReadData : ALUResult;
	
	
	//PC is here!!!!!!!!!!!!!!
	
	assign JorB = ( Jump | Branch ); //Jump or Branch, Determine if the current instruction requires a jump
	assign PCSrc = ( JorB & Flag );  // Use Flag to determine if the jump is valid/Successed
	assign NextPC = (PCSrc) ? ALUResult[7:0] : (PC + 1'b1);//NextPC is the new value if the jump is valid, otherwise add 1
	
	always@(posedge CLK)//Timing, PC value changes once per cycle
	begin
		if(reset)
			PC <= 0;
		else
		begin
			if(enable)
				PC <= NextPC;
			else
				PC <= PC;
		end
	end

	assign OPT_PC = PC;
	
endmodule