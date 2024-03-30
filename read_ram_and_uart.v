`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:48:46 10/28/2013 
// Design Name: 
// Module Name:    read_ram_and_uart 
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
module read_ram_and_uart(
    input clk,
    input reset,
	 input [15:0] data_from_ram,
	 output read_enable_to_ram,
	 output [5:0] address_to_ram, 
    output uart_TX
    );
	 
	 wire wr_uart_send, wr_uart_ready ;
	 wire[7:0] wr_data_byte ;
	 
	 
	 //for ram
	 //wire[31:0] wr_data_from_ram ;
	 //wire[3:0] wr_address_to_ram ; 
	 // wire wr_read_enable_to_ram ;	
	 
	 
	 
/*			// this ROM should be replaced by RAM later
	  ip_rom_in rom_input (
	  .clka(clk), // input clka
	  .ena(wr_read_enable_to_ram), // input ena
	  .addra(wr_address_to_ram), // input [3 : 0] addra
	  .douta(wr_data_from_ram) // output [31 : 0] douta
		);
*/

	 
	 
	 
	 read_from_ram read_RAM(
    .clk(clk),
	 .reset(reset),
    .data_from_ram(data_from_ram),						//32bit
    .uart_ready(wr_uart_ready),
    .address_to_ram(address_to_ram),					//4bit
    .read_enable_to_ram(read_enable_to_ram),
    .uart_send(wr_uart_send),
    .uart_data(wr_data_byte)								//8bit
    );
	 
	 
	 
	 UART_TX_CTRL UART_cont(
	  .SEND(wr_uart_send),
	  .DATA(wr_data_byte),					// 8bit
	  .CLK(clk),
	  .READY(wr_uart_ready),
	  .UART_TX(uart_TX)
	 ) ;


endmodule
