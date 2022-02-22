Library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY hazard_detection_unit IS
	PORT( RS1_ADDRESS : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			RS2_ADDRESS : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			EX_RD_ADDRESS : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			ID_EX_Mem_Read : IN STD_LOGIC; --LOAD INSTRUCTION
			IF_ID_Write : OUT STD_LOGIC;
			PC_Write : OUT STD_LOGIC;
			MUX_CU_HD : OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE BEHAVIOUR OF hazard_detection_unit IS

BEGIN

	HAZARD_DETECTION_PROCESS:	PROCESS(ID_EX_Mem_Read, RS1_ADDRESS, EX_RD_ADDRESS, RS2_ADDRESS)
								BEGIN
									IF ( ID_EX_Mem_Read = '1' ) THEN --SE L'ISTRUZIONE E' UNA LOAD E C'E' DATA DEPENDENCY, SI DEVE INSERIRE UNA NOP
										IF ( (EX_RD_ADDRESS = RS1_ADDRESS) OR (EX_RD_ADDRESS = RS2_ADDRESS) ) THEN
											IF_ID_Write <= '0'; --BLOCCO LA PIPE
											PC_Write <= '0'; --DISATTIVO IL PC
											MUX_CU_HD <= '1'; --INSERISCO DEGLI '0' NELLA PIPE A LIVELLO ID/EX
										ELSE --NON HO DATA DEPENDENCY
											IF_ID_Write <= '1';
											PC_WRITE <= '1';
											MUX_CU_HD <= '0';
										END IF;
									ELSE --NON E' UNA LOAD, NON POSSO AVERE DATA DEPENDENCY
										IF_ID_Write <= '1';
										PC_WRITE <= '1';
										MUX_CU_HD <= '0';
									END IF;
								END PROCESS;

END ARCHITECTURE;
	