`timescale 1ns / 1ps
`include"headfile.v"

                              //Function Unit
module ALU(
	input CLK,
	input [3:0] ALUControl, //5->4
	input [15:0] SrcA,
	input [15:0] SrcB,
	output reg [15:0] ALUResult,
	output reg Flag
    );
	
	reg CF_temp;
	wire ZF_temp, NF_temp;
	reg ZF, CF, NF;
	
	always@(*)//����ָ�����ݣ��Բ��������в�ͬ������    Perform different operations on operands according to the instruction content
	begin
		case(ALUControl)
			`NOP:		ALUResult <= ALUResult;
			//`HALT:	ALUResult <= ALUResult;
			//`AND:		ALUResult <= ( SrcA & SrcB );
			//`OR:		ALUResult <= ( SrcA | SrcB );
			//`XOR:		ALUResult <= ( SrcA ^ SrcB );
			`SLL:		ALUResult <= ( SrcA << SrcB );    
			`SRL:		ALUResult <= ( SrcA >> SrcB );
			//`SLA:		ALUResult <= ( SrcA <<< SrcB );
			//`SRA:		ALUResult <= ( SrcA >>> SrcB );
			//`JUMP:	ALUResult <= SrcB;      //����һλ�����Ƿ��������CF        Add a bit to handle whether the overflow setting CF
			`LDIH:	{CF_temp, ALUResult} <= {1'b0, SrcA} + {1'b0, SrcB};
			//`ADD:		{CF_temp, ALUResult} <= {1'b0, SrcA} + {1'b0, SrcB};
			`ADDI:	{CF_temp, ALUResult} <= {1'b0, SrcA} + {1'b0, SrcB};
			`ADDC:	ALUResult <= ( SrcA + SrcB + CF_temp);
			//`SUB:		ALUResult <= ( SrcA - SrcB );
			`SUBI:	ALUResult <= ( SrcA - SrcB );
			`SUBC:	ALUResult <= ( SrcA - SrcB - CF_temp);
			`CMP:		ALUResult <= ( SrcA - SrcB );
			`LOAD:	ALUResult <= ( SrcA + SrcB );
			`STORE:	ALUResult <= ( SrcA + SrcB );
			`JMPR:	ALUResult <= ( SrcA + SrcB );
			//`BZ:		ALUResult <= ( SrcA + SrcB );
			//`BNZ:		ALUResult <= ( SrcA + SrcB );
			`BN:		ALUResult <= ( SrcA + SrcB );
			`BNN:		ALUResult <= ( SrcA + SrcB );
			`BC:		ALUResult <= ( SrcA + SrcB );
			`BNC:		ALUResult <= ( SrcA + SrcB );
			
			
			
			`ADD:		{CF_temp, ALUResult} <= {1'b0, SrcA} + {1'b0, SrcB};
			`SUB:		ALUResult <= ( SrcA - SrcB );
			`AND:		ALUResult <= ( SrcA & SrcB );
			`OR:		ALUResult <= ( SrcA | SrcB );
			`XOR:		ALUResult <= ( SrcA ^ SrcB );
			`NOT:    ALUResult <= ( ~SrcA );       //new
			`SLA:		ALUResult <= ( SrcA <<< SrcB );
			`SRA:		ALUResult <= ( SrcA >>> SrcB );
			
			`LI:
			`LW:
			`SW:
			
			`BZ:		ALUResult <= ( SrcA + SrcB );
			`BNZ:		ALUResult <= ( SrcA + SrcB );
			
			`JAL:    ALUResult <= SrcB;  //new
			`JUMP:	ALUResult <= SrcB;
			`JR:     ALUResult <= SrcA;  //new
			`HALT:	ALUResult <= ALUResult;
			`EOE:	   ALUResult <= ALUResult;  //new
			
			
			default:	ALUResult <= ALUResult;
		endcase
	end
	
	//���Ϊ0ʱZF��־λΪ1
	// The ZeroFlag flag is 1 when the result is 0
	assign ZF_temp = (ALUResult == 0);
	
	//�����λΪ1ʱNF��־λΪ1
	// The NF flag bit is 1 when the result high bit is 1   (overflow?)
	assign NF_temp = (ALUResult[15] == 1'b1);
	
	//CF has been processed during computing
	//assign CF_temp = CF_temp;
	//����һ�����棬ΪCMP����һ������ʹ�� Add a level 1 cache for the next cycle of CMP
	
	always@(posedge CLK)
	begin
		ZF <= ZF_temp;
		CF <= CF_temp;
		NF <= NF_temp;
	end
	
	//Set Flag, Set according to the truth table
	always@(*)
	begin
		case(ALUControl)
			`JUMP:	Flag <= 1'b1;//��תָ���Ϊ1
			`JMPR:	Flag <= 1'b1;
			`BZ:		Flag <= ZF;//����ZF��־λ
			`BNZ:		Flag <= ~ZF;
			`BN:		Flag <= NF;//����NF��־λ
			`BNN:		Flag <= ~NF;
			`BC:		Flag <= CF;//����CF��־λ
			`BNC:		Flag <= ~CF;
			default:	Flag <= 1'b0;//����Ϊ0
		endcase
	end

endmodule

