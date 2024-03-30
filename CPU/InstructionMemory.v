`timescale 1ns / 1ps
`include"headfile.v"

//This part may need to be adjusted to become external, ROM? (see ECE414_FinalProject.pdf) by Zihan


module InstructionMemory(
	input [7:0] A,       //pc
	inout [15:0] control_word,  //new
 	input inst_load,            //new
	output [15:0] RD             
    );
	
	
	reg [15:0] IMmem [29:0];
	assign RD = IMmem[A];       //Immediately retrieve the content based on the address
	
	initial begin
		IMmem[0] = 16'b0000000000000000;
		IMmem[1] = 16'b0000000000000000;
		IMmem[2] = 16'b0000000000000000;
		IMmem[3] = 16'b0000000000000000;
		IMmem[4] = 16'b0000000000000000;
		IMmem[5] = 16'b0000000000000000;
		IMmem[6] = 16'b0000000000000000;
		IMmem[7] = 16'b0000000000000000;
		IMmem[8] = 16'b0000000000000000;
		IMmem[9] = 16'b0000000000000000;
		IMmem[10] = 16'b0000000000000000;
		IMmem[11] = 16'b0000000000000000;
		IMmem[12] = 16'b0000000000000000;
		IMmem[13] = 16'b0000000000000000;
		IMmem[14] = 16'b0000000000000000;
		IMmem[15] = 16'b0000000000000000;
		IMmem[16] = 16'b0000000000000000;
		IMmem[17] = 16'b0000000000000000;
		IMmem[18] = 16'b0000000000000000;
		IMmem[19] = 16'b0000000000000000;
		IMmem[20] = 16'b0000000000000000;
		IMmem[21] = 16'b0000000000000000;
		IMmem[22] = 16'b0000000000000000;
		IMmem[23] = 16'b0000000000000000;
		IMmem[24] = 16'b0000000000000000;
		IMmem[25] = 16'b0000000000000000;
		IMmem[26] = 16'b0000000000000000;
		IMmem[27] = 16'b0000000000000000;
		IMmem[28] = 16'b0000000000000000;
		IMmem[29] = 16'b0000000000000000;
	end

endmodule
