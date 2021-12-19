//`timescale 1ns

module tb_mul ();

   wire CLK_i;
   wire RST_n_i;
   wire [31:0] FP_AB_i;

   wire [31:0] FP_Z_i;
   wire END_SIM_i;

   clk_gen CG(.CLK(CLK_i));

   data_maker SM(.CLK(CLK_i),
		 		 .DATA(FP_AB_i));

   FPmul UUT(.CLK(CLK_i),
	     	 .FP_A(FP_AB_i),
			 .FP_B(FP_AB_i),
			 .FP_Z(FP_Z_i));

   data_sink DS(.CLK(CLK_i),
				.DATA(FP_Z_i));   

endmodule

		   
