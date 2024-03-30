`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:23:25 10/27/2013 
// Design Name: 
// Module Name:    read_from_ram 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module read_from_ram(
    input clk,
	 input reset,
    input [15:0] data_from_ram,
    input uart_ready,
    output reg [5:0] address_to_ram,
    output reg read_enable_to_ram,
    output reg uart_send,
    output reg [7:0] uart_data
    );

	//reg[3:0] mem_counter ;
	reg[2:0] byte_counter ;			// 2+2=4 bytes including new line code
	reg stop ;							//stop reading the ram 
	reg uart_sec_free ; 				// sending 32bit word to uart finished
	reg read_input_from_ram ;
	//reg [7:0] byte1 ;              //byte3, byte2 ;
	reg [3:0] hex1, hex2, hex3 ;    // store [11:0] of the 16 bit ram line
	
	
	always @ (posedge clk)			//address_to_ram
	begin
		if ( reset )
			address_to_ram <= 0 ;
		else if ( read_enable_to_ram )
			address_to_ram <= address_to_ram + 4'b0001 ;
		else
			address_to_ram <= address_to_ram ;
	end

	
	always @ (posedge clk)				//stop reading ram (end reached.)
	begin
		if (reset)
			stop <= 0 ;
		else if ( ( &address_to_ram ) && ( read_enable_to_ram )	)
			stop <= 1 ;
		else
			stop <= stop ;
	end
	
	
	always @ (posedge clk)				//read_enable_to_ram  ---should be single cycle
	begin
		if (reset)
			read_enable_to_ram <= 0 ;
		else if ( ( ~stop ) && uart_sec_free && (~ read_enable_to_ram) )
			read_enable_to_ram <= 1 ;
		else 
			read_enable_to_ram <= 0 ;
	end
	
	
		
	always @ (posedge clk)				//byte_counter [ 4 data bytes and 2 new line bytes ]
	begin
		if (reset)	
			byte_counter <= 0 ;
		else if ( read_enable_to_ram )
			byte_counter <= 3'd6 ;
		else if (uart_send)
			byte_counter <= byte_counter - 3'b001 ;
		else
			byte_counter <= byte_counter ;
	end


	
	always @ (posedge clk)				//read_input_from_ram
	begin
		if (reset)
			read_input_from_ram <= 0 ;
		else
			read_input_from_ram <= read_enable_to_ram ;
	end
	
	
//	always @ ( posedge clk ) 			//store data  (second byte)
//	begin
//		if ( reset )
//		begin
//	//		byte3 <= 0 ;
//	//		byte2 <= 0 ;
//			byte1 <= 0 ;
//		end
//		else if ( read_input_from_ram )		//(read_enable_to_ram)
//		begin
//	//		byte3 <= data_from_ram[23:16] ;
//	//		byte2 <= data_from_ram[15:8] ;
//			byte1 <= data_from_ram[7:0] ;
//		end
//		else
//		begin
//	//		byte3 <= byte3 ;
//	//		byte2 <= byte2 ;
//			byte1 <= byte1 ;
//		end	
//	end


always @ ( posedge clk ) 			//store data  (second byte)
	begin
		if ( reset )
		begin
			hex3 <= 0 ;
			hex2 <= 0 ;
			hex1 <= 0 ;
		end
		else if ( read_input_from_ram )		//(read_enable_to_ram)
		begin
			hex3 <= data_from_ram[11:8] ;
			hex2 <= data_from_ram[7:4] ;
			hex1 <= data_from_ram[3:0] ;//			byte1 <= data_from_ram[7:0] ;
		end
		else
		begin
			hex3 <= hex3 ;
			hex2 <= hex2 ;
			hex1 <= hex1 ;
		end	
	end
	
	
	
	
	
	always @ (posedge clk)				//uart_send        
	begin
		if (reset)
			uart_send <= 0 ;
		else if ( read_input_from_ram )				//( read_enable_to_ram )	
			uart_send <= 1;  
		else if ( ( byte_counter != 0) && ( uart_ready ) && ( ~ uart_send ) )
			uart_send <= 1;
		else
			uart_send <= 0;
	end		


	


	always @ ( posedge clk ) 			//uart_data 8bit
	begin
		if ( reset )
			uart_data <= 8'd0 ;
		else if ( read_input_from_ram )				//(read_enable_to_ram)	
		begin
			case (data_from_ram[15:12])
			
				0	:	uart_data <= 8'h30 ;
				1	:	uart_data <= 8'h31 ;
				2	:	uart_data <= 8'h32 ;
				3	:	uart_data <= 8'h33 ;
				4	:	uart_data <= 8'h34 ;
				5	:	uart_data <= 8'h35 ;
				6	:	uart_data <= 8'h36 ;
				7	:	uart_data <= 8'h37 ;
				8	:	uart_data <= 8'h38 ;
				9	:	uart_data <= 8'h39 ;
				10	:	uart_data <= 8'h41 ;
				11	:	uart_data <= 8'h42 ;
				12	:	uart_data <= 8'h43 ;
				13	:	uart_data <= 8'h44 ;
				14	:	uart_data <= 8'h45 ;
				15	:	uart_data <= 8'h46 ;
			endcase
		end	
		else if ( uart_ready && ( byte_counter != 0 ) && ( ~ uart_send ) )
		begin
			case (byte_counter)
				7 : uart_data <= 8'hFF ;
				6 : uart_data <= 8'hFF ;
				5 : 
				begin
					case (hex3)
					
						0	:	uart_data <= 8'h30 ;
						1	:	uart_data <= 8'h31 ;
						2	:	uart_data <= 8'h32 ;
						3	:	uart_data <= 8'h33 ;
						4	:	uart_data <= 8'h34 ;
						5	:	uart_data <= 8'h35 ;
						6	:	uart_data <= 8'h36 ;
						7	:	uart_data <= 8'h37 ;
						8	:	uart_data <= 8'h38 ;
						9	:	uart_data <= 8'h39 ;
						10	:	uart_data <= 8'h41 ;
						11	:	uart_data <= 8'h42 ;
						12	:	uart_data <= 8'h43 ;
						13	:	uart_data <= 8'h44 ;
						14	:	uart_data <= 8'h45 ;
						15	:	uart_data <= 8'h46 ;
					endcase
				end
				4 : 
				begin
					case (hex2)
					
						0	:	uart_data <= 8'h30 ;
						1	:	uart_data <= 8'h31 ;
						2	:	uart_data <= 8'h32 ;
						3	:	uart_data <= 8'h33 ;
						4	:	uart_data <= 8'h34 ;
						5	:	uart_data <= 8'h35 ;
						6	:	uart_data <= 8'h36 ;
						7	:	uart_data <= 8'h37 ;
						8	:	uart_data <= 8'h38 ;
						9	:	uart_data <= 8'h39 ;
						10	:	uart_data <= 8'h41 ;
						11	:	uart_data <= 8'h42 ;
						12	:	uart_data <= 8'h43 ;
						13	:	uart_data <= 8'h44 ;
						14	:	uart_data <= 8'h45 ;
						15	:	uart_data <= 8'h46 ;
					endcase
				end
				3 : 
				begin
					case (hex1)
					
						0	:	uart_data <= 8'h30 ;
						1	:	uart_data <= 8'h31 ;
						2	:	uart_data <= 8'h32 ;
						3	:	uart_data <= 8'h33 ;
						4	:	uart_data <= 8'h34 ;
						5	:	uart_data <= 8'h35 ;
						6	:	uart_data <= 8'h36 ;
						7	:	uart_data <= 8'h37 ;
						8	:	uart_data <= 8'h38 ;
						9	:	uart_data <= 8'h39 ;
						10	:	uart_data <= 8'h41 ;
						11	:	uart_data <= 8'h42 ;
						12	:	uart_data <= 8'h43 ;
						13	:	uart_data <= 8'h44 ;
						14	:	uart_data <= 8'h45 ;
						15	:	uart_data <= 8'h46 ;
					endcase
				end
				2 : uart_data <= 8'h0d ;			// new line
				1 : uart_data <= 8'h0a ;			// new line
				0 : uart_data <= 8'hFF;
			endcase
		end
	end		
	
/*	
		always @ ( posedge clk ) 			//uart_data 8bit
	begin
		if ( reset )
			uart_data <= 8'd0 ;
		else if ( read_input_from_ram )				//(read_enable_to_ram)	
			uart_data <= data_from_ram[15:8] ;
		else if ( uart_ready && ( byte_counter != 0 ) && ( ~ uart_send ) )
		begin
			case (byte_counter)
				6 : uart_data <= 8'hFF; 			// should never happen
				5 : uart_data <= 8'hFF; 			// should never happen
				4 : uart_data <= 8'hFF; 			// should never happen
				3 : uart_data <= byte1 ;
				2 : uart_data <= 8'h0d ;			// new line
				1 : uart_data <= 8'h0a ;			// new line
				0 : uart_data <= 8'hFF;
			endcase
		end
	end		

*/




		always @ ( posedge clk )				//uart_sec_free
		begin
			if (reset)
				uart_sec_free <= 1 ;
			else if ( ( byte_counter == 0 ) && uart_ready && ( ~read_enable_to_ram ) )	
				uart_sec_free <= 1 ;
			else 
				uart_sec_free <= 0 ;
		end


endmodule
