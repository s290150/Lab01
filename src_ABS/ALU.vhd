Library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ALU IS
	PORT( OPERAND1	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);	--20 bits it's the max immediate lenght
			OPERAND2	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
			OP_SEL	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			RES		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
			Z_flag	: OUT	STD_LOGIC);
END ENTITY;

ARCHITECTURE behavioural OF ALU IS
	TYPE OPERATION IS (add, comp, srai, logical_and, logical_xor, sub, abs_val);
	SIGNAL OP1, OP2	:	SIGNED(31 DOWNTO 0);
	SIGNAL OP_RES	:	SIGNED(31 DOWNTO 0);	--signed that will be converted to STD_LOGIC_VECTOR
	SIGNAL OP	: OPERATION;
	
	
	BEGIN
		OP1 <= SIGNED(OPERAND1);
		OP2 <= SIGNED(OPERAND2);
		RES <= STD_LOGIC_VECTOR(OP_RES);
		
		WITH OP_SEL SELECT	--devono essere cambiati con i giusti opcode
			OP <= add			when "000",
					comp			when "001",
					srai			when "010",
					logical_and	when "011",
					logical_xor when "100",
					sub 			when "101",
					abs_val		when "110",
					add			when OTHERS;	--if OP_SEL is not recognized, the add is performed as default
		PROCESS(OP, OP1, OP2)
		BEGIN
			CASE OP IS
				WHEN add => OP_RES <= OP1 + OP2;
				WHEN comp => IF ((OP1 - OP2) < 0) THEN
								OP_RES <= "0000000000000000000000000000000" & '1';
							 ELSE
								OP_RES <= (OTHERS => '0');
							 END IF;
				WHEN srai => OP_RES <= shift_right(OP1, TO_INTEGER(UNSIGNED(OP2(4 DOWNTO 0))));
				WHEN logical_and => OP_RES <= OP1 AND OP2;
				WHEN logical_xor => OP_RES <= OP1 XOR OP2;
				WHEN sub 		  => OP_RES <= OP1 - OP2;
				WHEN abs_val 	  => OP_RES <= abs(OP1+OP2);
			END CASE;
		END PROCESS;
		Z_flag <= '1' WHEN (OP_RES = "0000000000000000000000000000000") ELSE
				  '0';
						
END ARCHITECTURE;