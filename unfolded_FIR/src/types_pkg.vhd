LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

package types_pkg IS
	constant N_unfolding: integer := 3; -- ORDER OF UNFOLDING
	constant NT: integer := 11; -- NUMBER OF COEFFICIENTS
	constant Nb: integer := 7; -- PARALLELISM OF DATA
	type coeff_array IS array(0 TO NT-1) of SIGNED(Nb-1 DOWNTO 0); -- NUMBER OF COEFFICIENTS
	type data_array IS array(0 TO NT+1) of SIGNED(Nb-1 DOWNTO 0); -- DATA FOR REGISTERS STAGE 3K & 3K+1
	type data_array_2 IS array(0 TO NT+2) of SIGNED(Nb-1 DOWNTO 0); -- DATA FOR REGISTERS STAGE 3K+2
	type mult_out_array IS array(0 TO NT-1) of SIGNED(2*Nb-1 DOWNTO 0); -- DATA OUT OF MULTIPLICATION
	type data_ff IS array((Nt+N_unfolding)-1 DOWNTO 0) of STD_LOGIC; -- DATA FOR FF'S CHAIN
	type mult_in IS array(NT-1 DOWNTO 0) of SIGNED(Nb DOWNTO 0); -- DATA FOR OUTPUT TRUNCATION
	type add_in_from_mult IS array(0 to Nt-2) of SIGNED(Nb DOWNTO 0); -- DATA IN FOR ADDERS FROM MULTIPLIERS
	type add_in_from_sum IS array(0 to Nt-2) of SIGNED(Nb DOWNTO 0); -- DATA IN FOR ADDERS FROM ANOTHER ADDER
end package types_pkg;
