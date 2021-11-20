library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

ENTITY REG_8 IS
	PORT(
		DIN : IN SIGNED(Nb DOWNTO 0);
		CLK : IN STD_LOGIC;
		RST_N : IN STD_LOGIC;
		EN : IN STD_LOGIC;
		DOUT : OUT SIGNED(Nb DOWNTO 0));
END REG_8;

ARCHITECTURE BEHAV OF REG_8 IS
	BEGIN
		PROCESS (RST_N,CLK)
		BEGIN
			 IF RST_N = '0' THEN
				 DOUT <= (OTHERS=>'0');
			 ELSIF RISING_EDGE(CLK) THEN
					IF (EN = '1') THEN
						DOUT <= DIN;
					--ELSE
					--	DOUT <= DOUT;
					END IF;
			 END IF;
		END PROCESS;
END BEHAV;