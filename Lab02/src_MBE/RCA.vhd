LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.types_pkg.all;

ENTITY RCA IS
	PORT(
			A : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			B : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			S : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
		 );
END ENTITY;

ARCHITECTURE BEHAV OF RCA IS

-- COMPONENTS DECLARATION

COMPONENT FA IS
PORT (
		a, b	: in std_logic;
		cin	: in std_logic;
		cout	: out std_logic;
		s		: out std_logic
		);
END COMPONENT;

-- SIGNALS DECLARATION

SIGNAL COUT : STD_LOGIC_VECTOR(63 DOWNTO 0);

BEGIN

	FA_0 : FA PORT MAP (A(0), B(0), '0', COUT(0), S(0));

	RCA_IMPL : FOR I IN 1 TO 63 GENERATE
	
					FA_I : FA PORT MAP (A(I), B(I), COUT(I-1), COUT(I), S(I));
				
				  END GENERATE;
				  
END BEHAV;
