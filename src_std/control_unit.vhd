Library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_unit IS
PORT(	OPCODE		:	IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
		WB			:	OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
		M			:	OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
		EX			:	OUT	STD_LOGIC_VECTOR(5 DOWNTO 0));
END ENTITY;

ARCHITECTURE BEHAVIOUR OF control_unit IS
	-- WB:  WB(2) select the value to write in the register file between JAL register data and WB_WR_DATA, also used for the unconditional jump (JAL) and JAL write on its register
	--		WB(1) Regwrite for the write on the register file
	--		WB(0) MemToReg selects between the ALU/Immediate output of the execution stage and the data from memory
	-- EX:  EX(5 DOWNTO 3) selects the ALU operation type,
	-- 		EX(2) selects the execution stage output between ALU result and Immediate (for the LUI instruction)
	--		EX(1) selects between RD_DATA1 and PC as ALU input, 
	--		EX(0) between RD_DATA2 and IMMEDIATE
	-- M:	M(2) for the branch evaluation
	--		M(1) MemRead
	--		M(0) MemWrite
	BEGIN
	PROCESS(OPCODE)
	BEGIN
		CASE OPCODE IS
			WHEN "0110111" => WB <= "010"; EX <= "100101"; M <= "000";	-- LUI (LOAD UPPER IMMEDIATE)
			WHEN "0010111" => WB <= "010"; EX <= "100011"; M <= "000";  -- AUIPC (ADD UPPER IMMEDIATE TO PC)
			WHEN "1101111" => WB <= "110"; EX <= "100000"; M <= "100";  -- JAL (UNCONDITIONAL BRANCH)
			WHEN "1100011" => WB <= "000"; EX <= "011000"; M <= "100";  -- BEQ (CONDITIONAL BRANCH)
			WHEN "0000011" => WB <= "011"; EX <= "001001"; M <= "010";  -- LW (LOAD)
			WHEN "0100011" => WB <= "000"; EX <= "010001"; M <= "001";  -- SW (STORE)
			WHEN "0010011" => WB <= "010"; EX <= "001001"; M <= "000";  -- ADDI, ANDI, SRAI (ADD IMMEDIATE, AND IMMEDIATE, SHIFT RIGHT ARITHMETIC IMMEDIATE)
			WHEN "0110011" => WB <= "010"; EX <= "000000"; M <= "000";  -- ADD, SLT, XOR (ADD, COMPARE, XOR)
			WHEN OTHERS    => WB <= "000"; EX <= "000000"; M <= "000"; 	-- ERROR
		END CASE;
	END PROCESS;
END ARCHITECTURE;