`timescale 1ns / 1ps

module DataMemory(
	input CLK,
	input WE,               //write enable to RAM
	input RE,               //NEW! read enable to RAM
	input [7:0] A,          //Address to memory(RAM
	input [15:0] WD,        //write data to memory(RAM
	output [15:0] RD        //read data from memory(RAM
    );

	reg [15:0] DMmem [29:0];
	reg reallWE; reg [7:0] reallA; reg [15:0] reallWD;
	initial begin          //Initialize with all zeros
		reallWE = 1'b0;
		DMmem[0] =  16'b0000000000000000;
		DMmem[1] =  16'b0000000000000000;
		DMmem[2] =  16'b0000000000000000;
		DMmem[3] =  16'b0000000000000000;
		DMmem[4] =  16'b0000000000000000;
		DMmem[5] =  16'b0000000000000000;
		DMmem[6] =  16'b0000000000000000;
		DMmem[7] =  16'b0000000000000000;
		DMmem[8] =  16'b0000000000000000;
		DMmem[9] =  16'b0000000000000000;
		DMmem[10] = 16'b0000000000000000;
		DMmem[11] = 16'b0000000000000000;
		DMmem[12] = 16'b0000000000000000;
		DMmem[13] = 16'b0000000000000000;
		DMmem[14] = 16'b0000000000000000;
		DMmem[15] = 16'b0000000000000000;
		DMmem[16] = 16'b0000000000000000;
		DMmem[17] = 16'b0000000000000000;
		DMmem[18] = 16'b0000000000000000;
		DMmem[19] = 16'b0000000000000000;
		DMmem[20] = 16'b0000000000000000;
		DMmem[21] = 16'b0000000000000000;
		DMmem[22] = 16'b0000000000000000;
		DMmem[23] = 16'b0000000000000000;
		DMmem[24] = 16'b0000000000000000;
		DMmem[25] = 16'b0000000000000000;
		DMmem[26] = 16'b0000000000000000;
		DMmem[27] = 16'b0000000000000000;
		DMmem[28] = 16'b0000000000000000;
		DMmem[29] = 16'b0000000000000000;
	end
	//增加一级缓存对应RegisterFile的读写处理
	//Increase the read and write processing of RegisterFile corresponding to the level 1 cache
	always@(posedge CLK)
	begin
		reallWE <= WE;
		reallA <= A;
		reallWD <= WD;
	end
	//根据写入地址直接写入 Write directly according to the write address
	always@(*)
	begin
		if(reallWE)
			DMmem[reallA] <= reallWD;
	end
	//根据地址直接读取 Read directly from the address
	assign RD = DMmem[A];

endmodule
