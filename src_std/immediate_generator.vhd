Library ieee;
USE ieee.std_logic_1164.all;

ENTITY immediate_generator IS
	PORT( immediate_in	:	IN	STD_LOGIC_VECTOR(31 DOWNTO 0);	--20 bits it's the max immediate lenght
			immediate_out	:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE behavioural OF immediate_generator IS
	TYPE format_type IS (I, S, SB, U, UJ);
	SIGNAL format	: format_type;
	
	BEGIN
		WITH immediate_in(6 DOWNTO 0) SELECT	--devono essere cambiati con i giusti opcode
			format <=	 I  when "0000011",
						 I  when "0010011",
						 S	when "0100011",
						 SB when "1100011",
						 U	when "0110111",
						 U	when "0010111",
						 UJ when "1101111",
						 I when OTHERS;
		WITH format SELECT
			immediate_out <= immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31 DOWNTO 20) when I,
							  immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31 DOWNTO 25) & immediate_in(11 DOWNTO 7) when S,
							  immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(7) & immediate_in(30 DOWNTO 25) & immediate_in(11 DOWNTO 8) when SB,
							  immediate_in(31 DOWNTO 12) & "000000000000" when U,
							  immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(31) & immediate_in(19 DOWNTO 12) & immediate_in(20) & immediate_in(30 DOWNTO 21) when UJ;
END ARCHITECTURE;