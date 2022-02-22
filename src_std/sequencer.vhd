LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY sequencer IS
PORT (JUMP_ADDR: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PCSrc		: IN STD_LOGIC;
		PCWrite	: IN STD_LOGIC;
		clock		: IN STD_LOGIC;
		reset		: IN STD_LOGIC;
		I_ADDR	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE BEHAV OF sequencer IS
--COMPONENT DECLARATION

--SIGNALS DECLARATION
SIGNAL SEQ_ADDR: STD_LOGIC_VECTOR(31 DOWNTO 0); --USCITA ADDER 
SIGNAL PC_in, PC_out: STD_LOGIC_VECTOR(31 DOWNTO 0); --USCITA MUX


BEGIN

--MUX (OUT_MUX COINCIDE CON ADDR_IN DEL PC)
	WITH PCSrc SELECT
			PC_in <= SEQ_ADDR when '0', --VADO IN SEQUENZA
						JUMP_ADDR when OTHERS; --SALTO
						
	SEQ_ADDR <= STD_LOGIC_VECTOR((UNSIGNED(PC_out) + 4));
	
	
	PC:	PROCESS(clock, reset)
			BEGIN
				IF reset = '1' THEN
					PC_out <= (OTHERS => '0');
				ELSIF clock = '0' AND clock'EVENT THEN
					IF PCWrite = '1' THEN
						PC_out <= PC_in;
					ELSE
						PC_out <= PC_out;
					END IF;
				ELSE
					PC_out <= PC_out;	--Maybe the inner IF doesn't require this same instruction as else condition
				END IF;
			END PROCESS;
	
	I_ADDR <= PC_out;

END ARCHITECTURE;