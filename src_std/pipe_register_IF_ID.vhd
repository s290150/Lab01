Library ieee;
USE ieee.std_logic_1164.all;

ENTITY pipe_register_IF_ID IS
	PORT(	input	:	IN	STD_LOGIC_VECTOR(63 DOWNTO 0); --unconstrained array
			clock	:	IN	STD_LOGIC;
			reset	:	IN	STD_LOGIC;
			en_BD 		:   IN STD_LOGIC;
			en_HD			: 	 IN STD_LOGIC;
			output	:	BUFFER	STD_LOGIC_VECTOR(63 DOWNTO 0)); --unconstrained array
END ENTITY;

ARCHITECTURE behavioural OF pipe_register_IF_ID IS
BEGIN
	PROCESS (reset, clock)
	BEGIN
		IF reset = '1' THEN
			output <= (OTHERS => '0');
		ELSIF clock = '1' AND clock'EVENT THEN
			IF ( (en_BD = '1') AND (en_HD = '1') ) THEN
				output <= input;
			ELSIF ( (en_BD = '1') AND (en_HD = '0') ) THEN
				output <= output;
			ELSIF ( (en_BD = '0') AND (en_HD = '1') ) THEN
				output <= (OTHERS => '0');
			ELSIF ( (en_BD = '0') AND (en_HD = '0') ) THEN
				output <= (OTHERS => '0');
			END IF;
		ELSE
			output <= output;
		END IF;
	END PROCESS;
END ARCHITECTURE;