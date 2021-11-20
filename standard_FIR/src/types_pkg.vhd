LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

package types_pkg IS
	constant NT: integer := 11; -- NUMBER OF COEFFICIENTS
	constant Nb: integer := 7; -- PARALLELISM OF DATA
	type data_array IS array(0 TO NT-1) of SIGNED(Nb-1 DOWNTO 0); -- DATA FOR REGISTER'S OUTPUT AND COEFFICIENT
	type mult_out_array IS array(0 TO NT-1) of SIGNED(2*Nb-1 DOWNTO 0); -- DATA FOR THE OUTPUT OF MULTIPLICATION
	type data_ff IS array(1 DOWNTO 0) of STD_LOGIC; -- DATA FOR FF'S CHAIN
	type mult_in IS array(NT-1 DOWNTO 0) of SIGNED(Nb DOWNTO 0); -- DATA FOR OUTPUT TRUNCATION
	type add_in IS array(0 to Nt-2) of SIGNED(Nb DOWNTO 0); -- DATA FOR SUM OUTPUT
end package types_pkg;