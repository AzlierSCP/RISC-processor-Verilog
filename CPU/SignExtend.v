`timescale 1ns / 1ps

module SignExtend(
	input [7:0] SignImm8,
	output [15:0] SignImm16
    );

	assign SignImm16 = {{8{SignImm8[7]}}, SignImm8};

endmodule
