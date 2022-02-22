Library ieee;
USE ieee.std_logic_1164.all;

ENTITY pipe_register_EX_MEM IS
	PORT(	input	:	IN	STD_LOGIC_VECTOR(107 DOWNTO 0); --unconstrained array
			clock	:	IN	STD_LOGIC;
			reset	:	IN	STD_LOGIC;
			en 		:   IN STD_LOGIC;
			output	:	BUFFER	STD_LOGIC_VECTOR(107 DOWNTO 0)); --unconstrained array
END ENTITY;

ARCHITECTURE behavioural OF pipe_register_EX_MEM IS
BEGIN
	PROCESS (reset, clock)
	BEGIN
		IF reset = '1' THEN
			output <= (OTHERS => '0');
		ELSIF clock = '1' AND clock'EVENT THEN
			IF EN = '1' THEN
				output <= input;
			ELSE
				output <= output;
			END IF;
		ELSE
			output <= output;
		END IF;
	END PROCESS;
END ARCHITECTURE;