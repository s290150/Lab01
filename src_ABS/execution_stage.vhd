LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY execution_stage IS
	PORT( 	EX				: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			forwardA		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);	
			forwardB		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			PC_ADDR			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			RD_DATA1		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			RD_DATA2		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			IMMEDIATE		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			MEM_ALU_IMM		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			WB_WR_DATA		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			funct			: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			JMP_ADDR		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Z_flag			: OUT STD_LOGIC;
			ALU_IMM			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE behavioural OF execution_stage IS
--Components declaration
COMPONENT ALU IS
	PORT( OPERAND1	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);	--20 bits it's the max immediate lenght
			OPERAND2: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
			OP_SEL	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			RES		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
			Z_flag	: OUT	STD_LOGIC);
END COMPONENT;

--Signals declaration
SIGNAL OP1_NOF	:	STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL OP2_NOF	:	STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL OPERAND1	:	STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL OPERAND2	:	STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ALU_CTRL	:	STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL ALU_OUT	:	STD_LOGIC_VECTOR(31 DOWNTO 0);	--it's used to connect the ALU's result to a mux that chooses this value or the immediate (bypass required for the LUI)
	
BEGIN
	JMP_ADDR <= STD_LOGIC_VECTOR(SIGNED(PC_ADDR) + SIGNED(IMMEDIATE(30 DOWNTO 0) & '0'));
	
	WITH EX(0) SELECT	--mux for operand selection
		OP2_NOF <=	RD_DATA2 WHEN '0',
					IMMEDIATE WHEN OTHERS;
	WITH EX(1) SELECT	--this mux is required for the AUIPC instruction
		OP1_NOF <= RD_DATA1 WHEN '0',
				   PC_ADDR WHEN OTHERS;
	WITH forwardA SELECT
		OPERAND1 <= OP1_NOF WHEN "00",
					MEM_ALU_IMM WHEN "01",
					WB_WR_DATA WHEN "10",
					OP1_NOF WHEN OTHERS;
	WITH forwardB SELECT
		OPERAND2 <= OP2_NOF WHEN "00",
					MEM_ALU_IMM WHEN "01",
					WB_WR_DATA WHEN "10",
					OP2_NOF WHEN OTHERS;
					
	WITH EX(2) SELECT	--this mux is required for the LUI, to bypass the immediate on the ALU exit
		ALU_IMM <= ALU_OUT WHEN '0',
				   IMMEDIATE WHEN OTHERS;
	
					
	ALU_Control_process:	PROCESS(funct, EX(5 DOWNTO 3))
								BEGIN
									CASE EX(5 DOWNTO 3) IS
										--R-type (ADD, SLT, XOR)
										WHEN "000" =>	IF funct(2 DOWNTO 0) = "000" THEN	
															ALU_CTRL <= "000";	--ADD
														ELSIF funct(2 DOWNTO 0) = "010" THEN
															ALU_CTRL <= "001";	--SLT	temporarily
														ELSIF funct(2 DOWNTO 0) = "100" THEN
															ALU_CTRL <= "100"; --XOR
														ELSIF funct(2 DOWNTO 0) = "101" THEN
															ALU_CTRL <= "110";
														ELSE
															ALU_CTRL <= "000";
														END IF;
										--I-type (ADDI, ANDI, SRAI, LW)
										WHEN "001" =>	IF funct(2 DOWNTO 0) = "000" THEN	
															ALU_CTRL <= "000";	--ADDI
														ELSIF funct(2 DOWNTO 0) = "010" THEN	
															ALU_CTRL <= "000";	--LW
														ELSIF funct(2 DOWNTO 0) = "111" THEN
															ALU_CTRL <= "011";	--ANDI
														ELSIF funct(3 DOWNTO 0) = "1101" THEN
															ALU_CTRL <= "010";	--SRAI
														ELSE
															ALU_CTRL <= "000";
														END IF;
										--S-type (SW)
										WHEN "010" =>	IF funct(2 DOWNTO 0) = "010" THEN	
															ALU_CTRL <= "000";	--SW
														ELSE
															ALU_CTRL <= "000";
														END IF;
										--B-type (BEQ)				
										WHEN "011" =>	IF funct(2 DOWNTO 0) = "000" THEN	
															ALU_CTRL <= "101";	--BEQ
														ELSE
															ALU_CTRL <= "000";
														END IF;
										--J-type (LUI, AUIPC, JAL)
										WHEN "100" =>	ALU_CTRL <= "000";
										WHEN OTHERS =>  ALU_CTRL <= "000";
									END CASE;
								END PROCESS;
	
	ALU_COMP:	ALU PORT MAP(OPERAND1, OPERAND2, ALU_CTRL, ALU_OUT, Z_flag);
END ARCHITECTURE;