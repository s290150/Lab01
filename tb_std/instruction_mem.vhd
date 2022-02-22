Library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY instruction_mem IS
	PORT( PC_address 		  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		  instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;


ARCHITECTURE BEHAV OF instruction_mem IS

--signal definition

	TYPE INSTRUCTION_MEM IS ARRAY(0 TO 16383) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Inst_Mem_Block : INSTRUCTION_MEM := (OTHERS => (OTHERS => '0'));
	
	BEGIN
	--Instructions
	
	-- addi addi x16,x0,7		0x00700813
	Inst_Mem_Block(0) <= x"13";
	Inst_Mem_Block(1) <= x"08";
	Inst_Mem_Block(2) <= x"70";
	Inst_Mem_Block(3) <= x"00";

	-- auipc x4,0x00000002		0x00002217
	Inst_Mem_Block(4) <= x"17";
	Inst_Mem_Block(5) <= x"22";
	Inst_Mem_Block(6) <= x"00";
	Inst_Mem_Block(7) <= x"00";
	
	-- addi x4,x4,0xfffffffc	0xffc20213
	Inst_Mem_Block(8) <= x"13";
	Inst_Mem_Block(9) <= x"02";
	Inst_Mem_Block(10) <= x"c2";
	Inst_Mem_Block(11) <= x"ff";
	
	-- auipc x5,0x00000002 		0x00002297
	Inst_Mem_Block(12) <= x"97";
	Inst_Mem_Block(13) <= x"22";
	Inst_Mem_Block(14) <= x"00";
	Inst_Mem_Block(15) <= x"00";
	
	-- addi x5,x5,0x00000010 	0x01028293
	Inst_Mem_Block(16) <= x"93";
	Inst_Mem_Block(17) <= x"82";
	Inst_Mem_Block(18) <= x"02";
	Inst_Mem_Block(19) <= x"01";
	
	-- lui x13,0x00040000    	0x400006b7
	Inst_Mem_Block(20) <= x"b7";
	Inst_Mem_Block(21) <= x"06";
	Inst_Mem_Block(22) <= x"00";
	Inst_Mem_Block(23) <= x"40";
	
	-- addi x13,x13,0xffffffff 0xfff68693
	Inst_Mem_Block(24) <= x"93";
	Inst_Mem_Block(25) <= x"86";
	Inst_Mem_Block(26) <= x"f6";
	Inst_Mem_Block(27) <= x"ff";
	
	-- beq x16,x0,0x00000018 	0x02080863
	Inst_Mem_Block(28) <= x"63";
	Inst_Mem_Block(29) <= x"08";
	Inst_Mem_Block(30) <= x"08";
	Inst_Mem_Block(31) <= x"02";
	
	-- lw x8,0x00000000(x4) 	0x00022403
	Inst_Mem_Block(32) <= x"03";
	Inst_Mem_Block(33) <= x"24";
	Inst_Mem_Block(34) <= x"02";
	Inst_Mem_Block(35) <= x"00";
	
	-- srai x9,x8,0x0000001f 	0x41f45493
	Inst_Mem_Block(36) <= x"93";
	Inst_Mem_Block(37) <= x"54";
	Inst_Mem_Block(38) <= x"f4";
	Inst_Mem_Block(39) <= x"41";
	
	-- xor x10,x8,x9 		0x00944533
	Inst_Mem_Block(40) <= x"33";
	Inst_Mem_Block(41) <= x"45";
	Inst_Mem_Block(42) <= x"94";
	Inst_Mem_Block(43) <= x"00";
	
	-- andi x9,x9,0x00000001 	0x0014f493
	Inst_Mem_Block(44) <= x"93";
	Inst_Mem_Block(45) <= x"f4";
	Inst_Mem_Block(46) <= x"14";
	Inst_Mem_Block(47) <= x"00";
	
	-- add x10,x10,x9 		0x00950533
	Inst_Mem_Block(48) <= x"33";
	Inst_Mem_Block(49) <= x"05";
	Inst_Mem_Block(50) <= x"95";
	Inst_Mem_Block(51) <= x"00";
	
	-- addi x4,x4,0x00000004 	0x00420213
	Inst_Mem_Block(52) <= x"13";
	Inst_Mem_Block(53) <= x"02";
	Inst_Mem_Block(54) <= x"42";
	Inst_Mem_Block(55) <= x"00";
	
	-- addi x16,x16,0xffffffff 	0xfff80813
	Inst_Mem_Block(56) <= x"13";
	Inst_Mem_Block(57) <= x"08";
	Inst_Mem_Block(58) <= x"f8";
	Inst_Mem_Block(59) <= x"ff";
	
	-- slt x11,x10,x13 		0x00d525b3
	Inst_Mem_Block(60) <= x"b3";
	Inst_Mem_Block(61) <= x"25";
	Inst_Mem_Block(62) <= x"d5";
	Inst_Mem_Block(63) <= x"00";
	
	-- beq x11x0,0xffffffee 	0xfc058ee3
	Inst_Mem_Block(64) <= x"e3";
	Inst_Mem_Block(65) <= x"8e";
	Inst_Mem_Block(66) <= x"05";
	Inst_Mem_Block(67) <= x"fc";
	
	-- add x13,x10,x0 		0x000506b3
	Inst_Mem_Block(68) <= x"b3";
	Inst_Mem_Block(69) <= x"06";
	Inst_Mem_Block(70) <= x"05";
	Inst_Mem_Block(71) <= x"00";
	
	-- jal x1,0xffffffea 		0xfd5ff0ef
	Inst_Mem_Block(72) <= x"ef";
	Inst_Mem_Block(73) <= x"f0";
	Inst_Mem_Block(74) <= x"5f";
	Inst_Mem_Block(75) <= x"fd";
	
	-- sw x13,0x00000000(x5) 	0x00d2a023
	Inst_Mem_Block(76) <= x"23";
	Inst_Mem_Block(77) <= x"a0";
	Inst_Mem_Block(78) <= x"d2";
	Inst_Mem_Block(79) <= x"00";
	
	-- jal x1,0x00000000 		0x000000ef
	Inst_Mem_Block(80) <= x"ef";
	Inst_Mem_Block(81) <= x"00";
	Inst_Mem_Block(82) <= x"00";
	Inst_Mem_Block(83) <= x"00";
	
	-- addi x0,x0,0x00000000 	0x00000013
	Inst_Mem_Block(84) <= x"13";
	Inst_Mem_Block(85) <= x"00";
	Inst_Mem_Block(86) <= x"00";
	Inst_Mem_Block(87) <= x"00";
			
	instruction(7 DOWNTO 0) <= Inst_Mem_Block(TO_INTEGER(UNSIGNED(PC_address(13 DOWNTO 0))));
	instruction(15 DOWNTO 8) <= Inst_Mem_Block(TO_INTEGER(UNSIGNED(PC_address(13 DOWNTO 0)))+1);
	instruction(23 DOWNTO 16) <= Inst_Mem_Block(TO_INTEGER(UNSIGNED(PC_address(13 DOWNTO 0)))+2);
	instruction(31 DOWNTO 24) <= Inst_Mem_Block(TO_INTEGER(UNSIGNED(PC_address(13 DOWNTO 0)))+3);
	
END ARCHITECTURE;