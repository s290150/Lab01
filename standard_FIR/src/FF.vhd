library ieee;
use ieee.std_logic_1164.all;

ENTITY FF IS
	PORT(
		D : IN STD_LOGIC;
		CLK : IN STD_LOGIC;
		RST_N : IN STD_LOGIC;
		EN : IN STD_LOGIC;
		Q : OUT STD_LOGIC);
END FF;

ARCHITECTURE BEHAV OF FF IS
	BEGIN
		PROCESS (RST_N,CLK)
		BEGIN
			 IF RST_N = '0' THEN
				 Q <= '0';
			 ELSIF RISING_EDGE(CLK) THEN
					IF (EN = '1') THEN
						Q <= D;
					--ELSE
					--	Q <= '0';
					END IF;
			 END IF;
		END PROCESS;
END BEHAV;
