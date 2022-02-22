Library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY reg_file IS
	PORT( RD_REG1	:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
			RD_REG2	:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
			WR_REG	:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
			WR_DATA	:	IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
			RegWrite	:	IN		STD_LOGIC;
			clock		:	IN		STD_LOGIC;
			reset		:	IN		STD_LOGIC;
			RD_DATA1	:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
			RD_DATA2	:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE behavioural OF reg_file IS
	
	TYPE REG IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL X	:	REG;
	
	
BEGIN
	PROCESS (clock, reset)
	BEGIN
		IF reset = '1' THEN
			X <= (OTHERS => (OTHERS => '0'));
		ELSIF clock = '0' AND clock'EVENT THEN
			IF RegWrite = '1' THEN
				X <= X;
				X(TO_INTEGER(UNSIGNED(WR_REG))) <= WR_DATA;
			ELSE
				X <= X;
			END IF;
		END IF;
	END PROCESS;
	
		RD_DATA1 <= X(TO_INTEGER(UNSIGNED(RD_REG1)));
		RD_DATA2 <= X(TO_INTEGER(UNSIGNED(RD_REG2)));
END ARCHITECTURE;