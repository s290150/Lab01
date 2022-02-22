Library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY data_mem IS
	PORT(	data_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			MemRead : IN STD_LOGIC;
			MemWrite : IN STD_LOGIC;
			clock	: IN STD_LOGIC;
			ReadData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;


ARCHITECTURE BEHAV OF data_mem IS

--signal definition
	TYPE DATA_MEM IS ARRAY(0 TO 16383) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Data_Mem_Block : DATA_MEM := (	--v content => 10, -47, 22, -3, 15, 27, -4
														-- 10
														8192 => "00001010",
														8193 => "00000000",
														8194 => "00000000",
														8195 => "00000000",
														-- -47
														8196 => "11010001",
														8197 => "11111111",
														8198 => "11111111",
														8199 => "11111111",
														-- 22
														8200 => "00010110",
														8201 => "00000000",
														8202 => "00000000",
														8203 => "00000000",
														-- -3
														8204 => "11111101",
														8205 => "11111111",
														8206 => "11111111",
														8207 => "11111111",
														-- 15
														8208 => "00001111",
														8209 => "00000000",
														8210 => "00000000",
														8211 => "00000000",
														-- 27 00011011
														8212 => "00011011",
														8213 => "00000000",
														8214 => "00000000",
														8215 => "00000000",
														-- -4 11111100
														8216 => "11111100",
														8217 => "11111111",
														8218 => "11111111",
														8219 => "11111111",
														OTHERS => (OTHERS => '0'));
	
	BEGIN	
	
	DATA_MEMORY : PROCESS (clock, MemRead, MemWrite, data_address, WriteData)
	BEGIN

		IF (MemRead = '1') THEN
				ReadData(7 DOWNTO 0) <= Data_Mem_Block(TO_INTEGER(UNSIGNED(data_address(13 DOWNTO 0))));
				ReadData(15 DOWNTO 8) <= Data_Mem_Block(TO_INTEGER(UNSIGNED(data_address(13 DOWNTO 0)))+1);
				ReadData(23 DOWNTO 16) <= Data_Mem_Block(TO_INTEGER(UNSIGNED(data_address(13 DOWNTO 0)))+2);
				ReadData(31 DOWNTO 24) <= Data_Mem_Block(TO_INTEGER(UNSIGNED(data_address(13 DOWNTO 0)))+3);
		ELSE
			ReadData <= (OTHERS => '0');
		END IF;
		
		IF falling_edge(clock) THEN
			IF (MemWrite = '1') THEN
			
				Data_Mem_Block(TO_INTEGER(UNSIGNED(data_address(13 DOWNTO 0)))) <= WriteData(7 DOWNTO 0); 
				Data_Mem_Block(TO_INTEGER(UNSIGNED(data_address(13 DOWNTO 0)))+1) <= WriteData(15 DOWNTO 8); 
				Data_Mem_Block(TO_INTEGER(UNSIGNED(data_address(13 DOWNTO 0)))+2) <= WriteData(23 DOWNTO 16); 
				Data_Mem_Block(TO_INTEGER(UNSIGNED(data_address(13 DOWNTO 0)))+3) <= WriteData(31 DOWNTO 24);
			ELSE
				Data_Mem_Block <= Data_Mem_Block;
			END IF;
		ELSE
			Data_Mem_Block <= Data_Mem_Block;
		END IF;
	END PROCESS;
	
END ARCHITECTURE;