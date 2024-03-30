`timescale 1ns / 1ps

module RegisterFile(
	input CLK,
	input [3:0] A1,
	input [3:0] A2,
	input [3:0] A3,     //writting address
	input [15:0] WD3,   //writting data
	input WE3,          // R/W
	output [15:0] RD1,
	output [15:0] RD2
    );
	reg [15:0] RFmem [7:0];
	reg reallWE3; reg [3:0] reallA3; reg [15:0] reallWD3;
	initial begin       //初始化16个通用寄存器为0 // Initialize 16 general purpose registers to 0
		reallWE3 = 1'b0;
		RFmem[0] = 16'h0000000000000000;
		RFmem[1] = 16'h0000000000000000;
		RFmem[2] = 16'h0000000000000000;
		RFmem[3] = 16'h0000000000000000;
		RFmem[4] = 16'h0000000000000000;
		RFmem[5] = 16'h0000000000000000;
		RFmem[6] = 16'h0000000000000000;
		RFmem[7] = 16'h0000000000000000;
		RFmem[8] = 16'h0000000000000000;
		RFmem[9] = 16'h0000000000000000;
		RFmem[10] = 16'h0000000000000000;
		RFmem[11] = 16'h0000000000000000;
		RFmem[12] = 16'h0000000000000000;
		RFmem[13] = 16'h0000000000000000;
		RFmem[14] = 16'h0000000000000000;
		RFmem[15] = 16'h0000000000000000;
	end
	//避免对一个寄存器同时读写，一级缓存处理
	// Avoid simultaneous reading and writing to a register, Level 1 cache handling
	always@(posedge CLK)
	begin
		reallWE3 <= WE3;
		reallA3 <= A3;
		reallWD3 <= WD3;
	end
	
	//有写入内容时直接写入到指定位置
	// Write directly to the specified location if there is write content
	always@(*)
	begin
		if(reallWE3)
			RFmem[reallA3] <= reallWD3;
	end
	//根据地址直接从寄存器取值
	//Fetch the value directly from the register according to the address
	
	assign RD1 = RFmem[A1];
	assign RD2 = RFmem[A2];

endmodule

