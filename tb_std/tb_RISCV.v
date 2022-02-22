//`timescale 1ns

module tb_RISCV ();

   wire CLK_i;
   wire RST_i;
   wire [31:0] instruction;
   wire [31:0] ReadData;
   wire [31:0] PC_address;
   wire [31:0] data_address;
   wire [31:0] WriteData;
   wire MemWrite;
   wire MemRead;

   clk_gen CG(
  	      .CLK(CLK_i),
	      .RST(RST_i));

   instruction_mem IM(.PC_address(PC_address),
		 		 .instruction(instruction));

   data_mem DM( .data_address(data_address),
		 	.WriteData(WriteData),
			.MemRead(MemRead),
			.MemWrite(MemWrite),
			.clock(CLK_i),
			.ReadData(ReadData));
			
   RISCV_lite UUT(.instruction(instruction),
			  .ReadData(ReadData),
			  .clock(CLK_i),
			  .reset(RST_i),
			  .PC_address(PC_address),
			  .data_address(data_address),
			  .WriteData(WriteData),
			  .MemWrite(MemWrite),
			  .MemRead(MemRead));
endmodule

		   
