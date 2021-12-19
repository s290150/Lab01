LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.types_pkg.all;


ENTITY DADDA_TREE IS
PORT (PARTIAL_PROD			: PP;
		PROD_SIGN				: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		S, C						: OUT STD_LOGIC_VECTOR(63 DOWNTO 0));
END ENTITY;

ARCHITECTURE BEHAVIOR OF DADDA_TREE IS
-- COMPONENTS DECLARATION
COMPONENT HA IS
PORT (a, b	: in std_logic;
		cout	: out std_logic;
		s		: out std_logic);
END COMPONENT;

COMPONENT FA IS
PORT (a, b	: in std_logic;
		cin	: in std_logic;
		cout	: out std_logic;
		s		: out std_logic);
END COMPONENT;

-- SIGNALS DECLARATION
SIGNAL PARTIAL_PROD_extd_L7_std		: TABLE_L7	:= (OTHERS => (OTHERS => '0')); --Set all bits to 0
SIGNAL PARTIAL_PROD_extd_L7			: TABLE_L7	:= (OTHERS => (OTHERS => '0')); --upward shifted PPs
SIGNAL PARTIAL_PROD_extd_L6			: TABLE_L6	:= (OTHERS => (OTHERS => '0'));
SIGNAL PARTIAL_PROD_extd_L5			: TABLE_L5	:= (OTHERS => (OTHERS => '0'));
SIGNAL PARTIAL_PROD_extd_L4			: TABLE_L4	:= (OTHERS => (OTHERS => '0'));
SIGNAL PARTIAL_PROD_extd_L3			: TABLE_L3	:= (OTHERS => (OTHERS => '0'));
SIGNAL PARTIAL_PROD_extd_L2			: TABLE_L2	:= (OTHERS => (OTHERS => '0'));
SIGNAL S_L7, C_L7 						: S_C_L7		:= (OTHERS => (OTHERS => '0'));
SIGNAL S_L6, C_L6 						: S_C_L6		:= (OTHERS => (OTHERS => '0'));
SIGNAL S_L5, C_L5 						: S_C_L5		:= (OTHERS => (OTHERS => '0'));
SIGNAL S_L4, C_L4 						: S_C_L4		:= (OTHERS => (OTHERS => '0'));
SIGNAL S_L3, C_L3 						: STD_LOGIC_VECTOR(NUM_HA_FA_L3 DOWNTO 0)	:= (OTHERS => '0');
SIGNAL S_L2, C_L2 						: STD_LOGIC_VECTOR(NUM_HA_FA_L2 DOWNTO 0)	:= (OTHERS => '0');


BEGIN
----------------------------------Partial products extension and piramid scaling
	PPs_L7:	FOR I IN 0 TO 16 GENERATE
	PP0_L7:		 	IF I = 0 GENERATE
							PARTIAL_PROD_extd_L7_std(I)(35 DOWNTO 0) <= NOT(PROD_SIGN(0)) & PROD_SIGN(0) & PROD_SIGN(0) & PARTIAL_PROD(0);
						END GENERATE;
				
	PP1_14_L7:		IF (I <= 14) AND (I >= 1) GENERATE
							PARTIAL_PROD_extd_L7_std(I)((34+2*I) DOWNTO (2*I-2)) <= '1' & NOT(PROD_SIGN(I)) & PARTIAL_PROD(I) & '0' & PROD_SIGN(I-1);
						END GENERATE;
				
	PP15_L7:			IF I = 15 GENERATE
							PARTIAL_PROD_extd_L7_std(I)(63 DOWNTO (2*I-2)) <= NOT(PROD_SIGN(I)) & PARTIAL_PROD(I) & '0' & PROD_SIGN(I-1);
						END GENERATE;
				
	PP16_L7:			IF I = 16 GENERATE
							PARTIAL_PROD_extd_L7_std(I)(63 DOWNTO (2*I-2)) <= PARTIAL_PROD(I)(PARALLELISM-1 DOWNTO 0) & '0' & PROD_SIGN(I-1);
						END GENERATE;
				END GENERATE;
			
	COPY_UNSHFT_PART_L7:	FOR I IN 0 TO 16 GENERATE	--unshifted part of the table is copied into the new one
									PARTIAL_PROD_extd_L7(I)(35 DOWNTO 0) <= PARTIAL_PROD_extd_L7_std(I)(35 DOWNTO 0);
								END GENERATE;
					
	UPSHFT_L7:				FOR J IN 36 TO 49 GENERATE
	ROW0_15_L7:				FOR I IN 0 TO 15-(J-36) GENERATE
	ROW0_14_L7:					IF I < (15-(J-36)) GENERATE
											PARTIAL_PROD_extd_L7(I)(J + (J-36)) 	 <= PARTIAL_PROD_extd_L7_std(I + 1 + (J-36))(J + (J-36));
											PARTIAL_PROD_extd_L7(I)(J + (J-36) + 1) <= PARTIAL_PROD_extd_L7_std(I + 2 + (J-36))(J + (J-36) + 1);
										END GENERATE;
	ROW15_L7:					IF I = (15-(J-36)) GENERATE
											PARTIAL_PROD_extd_L7(I)(J + (J-36)) 	 <= PARTIAL_PROD_extd_L7_std(I + 1 + (J-36))(J + (J-36));
										END GENERATE;
									END GENERATE;
								END GENERATE;
					
	
-----------------------------------7th layer
	--ROW and COL ARE REFERRED TO FA AND HA section
	ROW7:					FOR I IN 0 TO 3 GENERATE	--max layer height
	COL7:						FOR J IN 24+2*I TO 42-2*I GENERATE	--max layer lenght
	COL7_FIRST_HAS:			IF J <= 1+24+2*I GENERATE		--first two columns summed
										HA_L7: HA PORT MAP (PARTIAL_PROD_extd_L7(3*I)(J), PARTIAL_PROD_extd_L7(3*I+1)(J), C_L7(I)(J-24), S_L7(I)(J-24));
									END GENERATE;
	--						
	COL7_MIDDLE_FA:			IF (J <= 41-2*I) AND (J >= 2+24+2*I) GENERATE --si può riscrivere in maniera più pulita la condizione?
										FA_L7: FA PORT MAP (PARTIAL_PROD_extd_L7(3*I)(J), PARTIAL_PROD_extd_L7(3*I+1)(J), PARTIAL_PROD_extd_L7(3*I+2)(J), C_L7(I)(J-24), S_L7(I)(J-24));
									END GENERATE;
							
	COL7_LAST_HA:				IF J = 42-2*I GENERATE
										HA_L7: HA PORT MAP (PARTIAL_PROD_extd_L7(3*I)(J), PARTIAL_PROD_extd_L7(3*I+1)(J), C_L7(I)(J-24), S_L7(I)(J-24));
									END GENERATE;
								END GENERATE;
							END GENERATE;
				
--------------------------------------------------------------------------------------------------------------------------------------------				
-----------------------------------L6 partial products organizzation
	COPY_L6:		FOR I IN 0 TO 12 GENERATE	--unshifted part of the table is copied into the new one
						PARTIAL_PROD_extd_L6(I)(23 DOWNTO 0) <= PARTIAL_PROD_extd_L7(I)(23 DOWNTO 0);
						PARTIAL_PROD_extd_L6(I)(63 DOWNTO 44) <= PARTIAL_PROD_extd_L7(I)(63 DOWNTO 44);
					END GENERATE;
	
	S_C_L7_L6:	FOR I IN 0 TO 3 GENERATE
						PARTIAL_PROD_extd_L6(2*I)((43-2*I) DOWNTO (24+2*I)) <= C_L7(I)(42-24-2*I) & S_L7(I)((42-24-2*I) DOWNTO 2*I);
						PARTIAL_PROD_extd_L6(2*I+1)((43-(2*I+1)) DOWNTO (24+(2*I+1))) <= C_L7(I)((42-24-(2*I+1)) DOWNTO (2*I));
					END GENERATE;
					
	UPSHIFT_right_L6:	FOR J IN 24 TO 27 GENERATE	--covers until column 31, two at a times
	COL_RIGHT_L6:			FOR I IN 1+2*(J-24) TO 12 GENERATE
	SINGLE_COL_DWN_L6:		IF I = 1+2*(J-24)  GENERATE
										PARTIAL_PROD_extd_L6(I)(J + (J-24)) <= PARTIAL_PROD_extd_L7(I+1+(J-STRT_COL_L7))(J + (J-24));
									END GENERATE;
	TWO_COL_DWN_L6:			IF I > 1+2*(J-24)  GENERATE
										PARTIAL_PROD_extd_L6(I)(J + (J-24)) <= PARTIAL_PROD_extd_L7(I+1+(J-STRT_COL_L7))(J + (J-24));
										PARTIAL_PROD_extd_L6(I)(J + (J-24) + 1) <= PARTIAL_PROD_extd_L7(I+(J-STRT_COL_L7))(J + (J-24) + 1);
									END GENERATE;
								END GENERATE;
							END GENERATE;
					
	SAME_LVL_COL_L6:	FOR J IN 32 TO 35 GENERATE
	SAME_LVL_ROW_L6:		FOR I IN 8 TO 12 GENERATE
									PARTIAL_PROD_extd_L6(I)(J) <= PARTIAL_PROD_extd_L7(I+4)(J);
								END GENERATE;
							END GENERATE;
				
	UPSHIFT_LEFT_L6:	FOR J IN 36 TO 39 GENERATE	--covers until column 43, two at a times
	COL_LEFT_L6:			FOR I IN 8-2*(J-36)-1 TO 12 GENERATE
	SINGLE_COL_DWN_L6:		IF I = 8-2*(J-36)-1  GENERATE
										PARTIAL_PROD_extd_L6(I)(J + (J-36) + 1) <= PARTIAL_PROD_extd_L7(I+2-(J-36))(J + (J-36) + 1);
									END GENERATE;
	TWO_COL_DWN_L6:			IF I > 8-2*(J-36)-1  GENERATE
										PARTIAL_PROD_extd_L6(I)(J + (J-36)) <= PARTIAL_PROD_extd_L7(I+3-(J-36))(J + (J-36));
										PARTIAL_PROD_extd_L6(I)(J + (J-36) + 1) <= PARTIAL_PROD_extd_L7(I+2-(J-36))(J + (J-36) + 1);
									END GENERATE;
								END GENERATE;
							END GENERATE;

							
-----------------------------------6th layer
	ROW6:					FOR I IN 0 TO 3 GENERATE	--max layer height
	COL6:						FOR J IN 16+2*I TO 50-2*I GENERATE	--max layer lenght
	COL6_FIRST_HAS:			IF J <= 1+16+2*I GENERATE		--first two columns summed
										HA_L6: HA PORT MAP (PARTIAL_PROD_extd_L6(3*I)(J), PARTIAL_PROD_extd_L6(3*I+1)(J), C_L6(I)(J-16), S_L6(I)(J-16));
									END GENERATE;
	--						
	COL6_MIDDLE_FA:			IF (J <= 49-2*I) AND (J >= 2+16+2*I) GENERATE --si può riscrivere in maniera più pulita la condizione?
										FA_L6: FA PORT MAP (PARTIAL_PROD_extd_L6(3*I)(J), PARTIAL_PROD_extd_L6(3*I+1)(J), PARTIAL_PROD_extd_L6(3*I+2)(J), C_L6(I)(J-16), S_L6(I)(J-16));
									END GENERATE;
							
	COL6_LAST_HA:				IF J = 50-2*I GENERATE
										HA_L6: HA PORT MAP (PARTIAL_PROD_extd_L6(3*I)(J), PARTIAL_PROD_extd_L6(3*I+1)(J), C_L6(I)(J-16), S_L6(I)(J-16));
									END GENERATE;
								END GENERATE;
							END GENERATE;

--------------------------------------------------------------------------------------------------------------------------------------------							
-----------------------------------L5 partial products organizzation
	COPY_L5:		FOR I IN 0 TO 8 GENERATE	--unshifted part of the table is copied into the new one
						PARTIAL_PROD_extd_L5(I)(15 DOWNTO 0) <= PARTIAL_PROD_extd_L6(I)(15 DOWNTO 0);
						PARTIAL_PROD_extd_L5(I)(63 DOWNTO 52) <= PARTIAL_PROD_extd_L6(I)(63 DOWNTO 52);
					END GENERATE;
	
	S_C_L6_L5:	FOR I IN 0 TO 3 GENERATE
						PARTIAL_PROD_extd_L5(2*I)((END_COL_L6+1-2*I) DOWNTO (STRT_COL_L6+2*I)) <= C_L6(I)(NUM_HA_FA_L6-2*I) & S_L6(I)(NUM_HA_FA_L6-2*I DOWNTO 2*I);
						PARTIAL_PROD_extd_L5(2*I+1)((END_COL_L6-2*I) DOWNTO (STRT_COL_L6+(2*I+1))) <= C_L6(I)((NUM_HA_FA_L6-(2*I+1)) DOWNTO ((2*I)));
					END GENERATE;
					
	UPSHIFT_right_L5:	FOR J IN 16 TO 19 GENERATE	--covers until column 23, two at a times
	COL_RIGHT_L5:			FOR I IN 1+2*(J-16) TO 8 GENERATE
	SINGLE_COL_DWN_L5:		IF I = 1+2*(J-16)  GENERATE
										PARTIAL_PROD_extd_L5(I)(J + (J-16)) <= PARTIAL_PROD_extd_L6(I+1+(J-STRT_COL_L6))(J + (J-16));
									END GENERATE;
	TWO_COL_DWN_L5:			IF I > 1+2*(J-16)  GENERATE
										PARTIAL_PROD_extd_L5(I)(J + (J-16)) <= PARTIAL_PROD_extd_L6(I+1+(J-STRT_COL_L6))(J + (J-16));
										PARTIAL_PROD_extd_L5(I)(J + (J-16) + 1) <= PARTIAL_PROD_extd_L6(I+(J-STRT_COL_L6))(J + (J-16) + 1);
									END GENERATE;
								END GENERATE;
							END GENERATE;
					
	SAME_LVL_COL_L5:	FOR J IN 24 TO 43 GENERATE
								PARTIAL_PROD_extd_L5(8)(J) <= PARTIAL_PROD_extd_L6(8+4)(J);
							END GENERATE;
				
	UPSHIFT_LEFT_L5:	FOR J IN 44 TO 47 GENERATE	--covers until column 51, two at a times
	COL_LEFT_L5:			FOR I IN 8-2*(J-44)-1 TO 8 GENERATE
	SINGLE_COL_DWN_L5:		IF I = 8-2*(J-44)-1  GENERATE
										PARTIAL_PROD_extd_L5(I)(J + (J-44) + 1) <= PARTIAL_PROD_extd_L6(I+2-(J-44))(J + (J-44) + 1);
									END GENERATE;
	TWO_COL_DWN_L5:			IF I > 8-2*(J-44)-1  GENERATE
										PARTIAL_PROD_extd_L5(I)(J + (J-44)) <= PARTIAL_PROD_extd_L6(I+3-(J-44))(J + (J-44));
										PARTIAL_PROD_extd_L5(I)(J + (J-44) + 1) <= PARTIAL_PROD_extd_L6(I+2-(J-44))(J + (J-44) + 1);
									END GENERATE;
								END GENERATE;
							END GENERATE;

							
-----------------------------------5th layer
	ROW5:					FOR I IN 0 TO 2 GENERATE	--max layer height
	COL5:						FOR J IN STRT_COL_L5+2*I TO END_COL_L5-2*I GENERATE	--max layer lenght
	COL5_FIRST_HAS:			IF J <= 1+STRT_COL_L5+2*I GENERATE		--first two columns summed
										HA_L5: HA PORT MAP (PARTIAL_PROD_extd_L5(3*I)(J), PARTIAL_PROD_extd_L5(3*I+1)(J), C_L5(I)(J-STRT_COL_L5), S_L5(I)(J-STRT_COL_L5));
									END GENERATE;
	--						
	COL5_MIDDLE_FA:			IF (J <= END_COL_L5-(2*I+1)) AND (J >= 2+STRT_COL_L5+2*I) GENERATE --si può riscrivere in maniera più pulita la condizione?
										FA_L5: FA PORT MAP (PARTIAL_PROD_extd_L5(3*I)(J), PARTIAL_PROD_extd_L5(3*I+1)(J), PARTIAL_PROD_extd_L5(3*I+2)(J), C_L5(I)(J-STRT_COL_L5), S_L5(I)(J-STRT_COL_L5));
									END GENERATE;
							
	COL5_LAST_HA:				IF J = END_COL_L5-2*I GENERATE
										HA_L5: HA PORT MAP (PARTIAL_PROD_extd_L5(3*I)(J), PARTIAL_PROD_extd_L5(3*I+1)(J), C_L5(I)(J-STRT_COL_L5), S_L5(I)(J-STRT_COL_L5));
									END GENERATE;
								END GENERATE;
							END GENERATE;
							
--------------------------------------------------------------------------------------------------------------------------------------------							
-----------------------------------L4 partial products organizzation
	COPY_L4:		FOR I IN 0 TO 5 GENERATE	--unshifted part of the table is copied into the new one
						PARTIAL_PROD_extd_L4(I)(9 DOWNTO 0) <= PARTIAL_PROD_extd_L5(I)(9 DOWNTO 0);
						PARTIAL_PROD_extd_L4(I)(63 DOWNTO 58) <= PARTIAL_PROD_extd_L5(I)(63 DOWNTO 58);
					END GENERATE;
	
	S_C_L5_L4:	FOR I IN 0 TO 2 GENERATE
						PARTIAL_PROD_extd_L4(2*I)((END_COL_L5+1-2*I) DOWNTO (STRT_COL_L5+2*I)) <= C_L5(I)(NUM_HA_FA_L5-2*I) & S_L5(I)(NUM_HA_FA_L5-2*I DOWNTO 2*I);
						PARTIAL_PROD_extd_L4(2*I+1)((END_COL_L5-(2*I)) DOWNTO (STRT_COL_L5+(2*I+1))) <= C_L5(I)((NUM_HA_FA_L5-(2*I+1)) DOWNTO ((2*I)));
					END GENERATE;
					
	UPSHIFT_right_L4:	FOR J IN STRT_COL_L5 TO STRT_COL_L5+2 GENERATE	--covers until column 23, two at a times
	COL_RIGHT_L4:			FOR I IN 1+2*(J-STRT_COL_L5) TO 5 GENERATE
	SINGLE_COL_DWN_L4:		IF I = 1+2*(J-STRT_COL_L5) GENERATE
										PARTIAL_PROD_extd_L4(I)(J + (J-STRT_COL_L5)) <= PARTIAL_PROD_extd_L5(I+1+(J-STRT_COL_L5))(J + (J-STRT_COL_L5));
									END GENERATE;
	TWO_COL_DWN_L4:			IF I > 1+2*(J-STRT_COL_L5)  GENERATE
										PARTIAL_PROD_extd_L4(I)(J + (J-STRT_COL_L5)) <= PARTIAL_PROD_extd_L5(I+1+(J-STRT_COL_L5))(J + (J-STRT_COL_L5));
										PARTIAL_PROD_extd_L4(I)(J + (J-STRT_COL_L5) + 1) <= PARTIAL_PROD_extd_L5(I+(J-STRT_COL_L5))(J + (J-STRT_COL_L5) + 1);
									END GENERATE;
								END GENERATE;
							END GENERATE;
				
	UPSHIFT_LEFT_L4:	FOR J IN END_COL_L5-4 TO END_COL_L5-2 GENERATE	--covers until column 57, two at a times
	COL_LEFT_L4:			FOR I IN NUM_OP_L4-2*(J-(END_COL_L5-4)) TO NUM_OP_L4 GENERATE		--special case: just one dot is in column 52, row 5 doesn't exist
	SINGLE_COL_DWN_L4:		IF I = NUM_OP_L4-2*(J-(END_COL_L5-4))  GENERATE
										PARTIAL_PROD_extd_L4(I)(J + (J-(END_COL_L5-4)) + 1) <= PARTIAL_PROD_extd_L5(I+1-(J-(END_COL_L5-4)))(J + (J-(END_COL_L5-4)) + 1);
									END GENERATE;
	TWO_COL_DWN_L4:			IF (I <= NUM_OP_L4) AND (I > NUM_OP_L4-2*(J-(END_COL_L5-4))-1)  GENERATE
										PARTIAL_PROD_extd_L4(I)(J + (J-(END_COL_L5-4))) <= PARTIAL_PROD_extd_L5(I+2-(J-(END_COL_L5-4)))(J + (J-(END_COL_L5-4)));
										PARTIAL_PROD_extd_L4(I)(J + (J-(END_COL_L5-4)) + 1) <= PARTIAL_PROD_extd_L5(I+1-(J-(END_COL_L5-4)))(J + (J-(END_COL_L5-4)) + 1);
									END GENERATE;
								END GENERATE;
							END GENERATE;

							
-----------------------------------4th layer
	ROW4:					FOR I IN 0 TO DEPTH_L4 GENERATE	--max layer height
	COL4:						FOR J IN STRT_COL_L4+2*I TO END_COL_L4-2*I GENERATE	--max layer lenght
	COL4_FIRST_HAS:			IF J <= 1+STRT_COL_L4+2*I GENERATE		--first two columns
										HA_L4: HA PORT MAP (PARTIAL_PROD_extd_L4(3*I)(J), PARTIAL_PROD_extd_L4(3*I+1)(J), C_L4(I)(J-STRT_COL_L4), S_L4(I)(J-STRT_COL_L4));
									END GENERATE;
	--						
	COL4_MIDDLE_FA:			IF (J <= END_COL_L4-1-2*I) AND (J >= 2+STRT_COL_L4+2*I) GENERATE --si può riscrivere in maniera più pulita la condizione?
										FA_L4: FA PORT MAP (PARTIAL_PROD_extd_L4(3*I)(J), PARTIAL_PROD_extd_L4(3*I+1)(J), PARTIAL_PROD_extd_L4(3*I+2)(J), C_L4(I)(J-STRT_COL_L4), S_L4(I)(J-STRT_COL_L4));
									END GENERATE;
							
	COL4_LAST_HA:				IF J = END_COL_L4-2*I GENERATE
										HA_L4: HA PORT MAP (PARTIAL_PROD_extd_L4(3*I)(J), PARTIAL_PROD_extd_L4(3*I+1)(J), C_L4(I)(J-STRT_COL_L4), S_L4(I)(J-STRT_COL_L4));
									END GENERATE;
								END GENERATE;
							END GENERATE;
							
--------------------------------------------------------------------------------------------------------------------------------------------							
-----------------------------------L3 partial products organizzation
	COPY_L3:		FOR I IN 0 TO 3 GENERATE	--unshifted part of the table is copied into the new one
						PARTIAL_PROD_extd_L3(I)(5 DOWNTO 0) <= PARTIAL_PROD_extd_L4(I)(5 DOWNTO 0);
						PARTIAL_PROD_extd_L3(I)(63 DOWNTO 62) <= PARTIAL_PROD_extd_L4(I)(63 DOWNTO 62);
					END GENERATE;
	
	S_C_L4_L3:	FOR I IN 0 TO 1 GENERATE
						PARTIAL_PROD_extd_L3(2*I)((END_COL_L4+1-2*I) DOWNTO (STRT_COL_L4+2*I)) <= C_L4(I)(NUM_HA_FA_L4-2*I) & S_L4(I)(NUM_HA_FA_L4-2*I DOWNTO 2*I);
						PARTIAL_PROD_extd_L3(2*I+1)((END_COL_L4-2*I) DOWNTO (STRT_COL_L4+(2*I+1))) <= C_L4(I)((NUM_HA_FA_L4-(2*I+1)) DOWNTO ((2*I)));
					END GENERATE;
					
	UPSHIFT_right_L3:	FOR J IN STRT_COL_L4 TO STRT_COL_L4+1 GENERATE	--covers until column 23, two at a times
	COL_RIGHT_L3:			FOR I IN 1+2*(J-STRT_COL_L4) TO NUM_OP_L3 GENERATE
	SINGLE_COL_DWN_L3:		IF I = 1+2*(J-STRT_COL_L4) GENERATE
										PARTIAL_PROD_extd_L3(I)(J + (J-STRT_COL_L4)) <= PARTIAL_PROD_extd_L4(I+1+(J-STRT_COL_L4))(J + (J-STRT_COL_L4));
									END GENERATE;
	TWO_COL_DWN_L3:			IF I > 1+2*(J-STRT_COL_L4)  GENERATE
										PARTIAL_PROD_extd_L3(I)(J + (J-STRT_COL_L4)) <= PARTIAL_PROD_extd_L4(I+1+(J-STRT_COL_L4))(J + (J-STRT_COL_L4));
										PARTIAL_PROD_extd_L3(I)(J + (J-STRT_COL_L4) + 1) <= PARTIAL_PROD_extd_L4(I+(J-STRT_COL_L4))(J + (J-STRT_COL_L4) + 1);
									END GENERATE;
								END GENERATE;
							END GENERATE;
				
	UPSHIFT_LEFT_L3:	FOR J IN END_COL_L4-2 TO END_COL_L4-1 GENERATE	--covers until column 61, two at a times
	COL_LEFT_L3:			FOR I IN NUM_OP_L3-2*(J-(END_COL_L4-2)) TO NUM_OP_L3 GENERATE		--just one dot is in column 59, row 3 doesn't exist
	SINGLE_COL_DWN_L3:		IF I = NUM_OP_L3-2*(J-(END_COL_L4-2))  GENERATE
										PARTIAL_PROD_extd_L3(I)(J + (J-(END_COL_L4-2)) + 1) <= PARTIAL_PROD_extd_L4(I-(J-(END_COL_L4-2)))(J + (J-(END_COL_L4-2)) + 1);
									END GENERATE;
	TWO_COL_DWN_L3:			IF (I > NUM_OP_L3-2*(J-(END_COL_L4-2)))  GENERATE
										PARTIAL_PROD_extd_L3(I)(J + (J-(END_COL_L4-2))) <= PARTIAL_PROD_extd_L4(I+1-(J-(END_COL_L4-2)))(J + (J-(END_COL_L4-2)));
										PARTIAL_PROD_extd_L3(I)(J + (J-(END_COL_L4-2)) + 1) <= PARTIAL_PROD_extd_L4(I-(J-(END_COL_L4-2)))(J + (J-(END_COL_L4-2)) + 1);
									END GENERATE;
								END GENERATE;
							END GENERATE;

							
-----------------------------------3th layer
	COL3:						FOR J IN 4 TO 62 GENERATE	--max layer lenght
	COL3_FIRST_HAS:			IF J <= (1+STRT_COL_L3) GENERATE		--first two columns summed
										HA_L3: HA PORT MAP (PARTIAL_PROD_extd_L3(0)(J), PARTIAL_PROD_extd_L3(1)(J), C_L3(J-4), S_L3(J-4));
									END GENERATE;
	--						
	COL3_MIDDLE_FA:			IF (J <= END_COL_L3-1) AND (J >= 2+STRT_COL_L3) GENERATE --si può riscrivere in maniera più pulita la condizione?
										FA_L3: FA PORT MAP (PARTIAL_PROD_extd_L3(0)(J), PARTIAL_PROD_extd_L3(1)(J), PARTIAL_PROD_extd_L3(2)(J), C_L3(J-STRT_COL_L3), S_L3(J-STRT_COL_L3));
									END GENERATE;
							
	COL3_LAST_HA:				IF J = END_COL_L3 GENERATE
										HA_L3: HA PORT MAP (PARTIAL_PROD_extd_L3(0)(J), PARTIAL_PROD_extd_L3(1)(J), C_L3(J-STRT_COL_L3), S_L3(J-STRT_COL_L3));
									END GENERATE;
								END GENERATE;
							
--------------------------------------------------------------------------------------------------------------------------------------------							
-----------------------------------L2 partial products organizzation
	COPY_L2:		FOR I IN 0 TO NUM_OP_L2 GENERATE	--unshifted part of the table is copied into the new one
						PARTIAL_PROD_extd_L2(I)(STRT_COL_L3-1 DOWNTO 0) <= PARTIAL_PROD_extd_L3(I)(STRT_COL_L3-1 DOWNTO 0);
					END GENERATE;
	
					PARTIAL_PROD_extd_L2(0)((END_COL_L3+1) DOWNTO (STRT_COL_L3)) <= C_L3(NUM_HA_FA_L3) & S_L3(NUM_HA_FA_L3 DOWNTO 0);
					PARTIAL_PROD_extd_L2(1)((END_COL_L3) DOWNTO (STRT_COL_L3+1)) <= C_L3((NUM_HA_FA_L3-1) DOWNTO 0);
					
	UPSHIFT_right_L2:	FOR J IN STRT_COL_L3 TO STRT_COL_L3+1 GENERATE	--covers until column 23, two at a times
	COL_RIGHT_L2:			FOR I IN 1+1*(J-STRT_COL_L3) TO NUM_OP_L2 GENERATE		--special case: 
	SINGLE_COL_DWN_L2:		IF I = 1+1*(J-STRT_COL_L3) GENERATE
										PARTIAL_PROD_extd_L2(I)(J + (J-STRT_COL_L3)) <= PARTIAL_PROD_extd_L3(I+1)(J + (J-STRT_COL_L3));
									END GENERATE;
	TWO_COL_DWN_L2:			IF I > 1+1*(J-STRT_COL_L3)  GENERATE
										PARTIAL_PROD_extd_L2(I)(J + (J-STRT_COL_L3)) <= PARTIAL_PROD_extd_L3(I+1+(J-STRT_COL_L3))(J + (J-STRT_COL_L3));
										PARTIAL_PROD_extd_L2(I)(J + (J-STRT_COL_L3) + 1) <= PARTIAL_PROD_extd_L3(I+(J-STRT_COL_L3))(J + (J-STRT_COL_L3) + 1);
									END GENERATE;
								END GENERATE;
							END GENERATE;
							
	SAME_LVL_COL_L2:	FOR J IN STRT_COL_L3+3 TO END_COL_L3-1 GENERATE
								PARTIAL_PROD_extd_L2(NUM_OP_L2)(J) <= PARTIAL_PROD_extd_L3(NUM_OP_L3)(J);
							END GENERATE;
							
					PARTIAL_PROD_extd_L2(2)(END_COL_L3) 	<= PARTIAL_PROD_extd_L3(2)(END_COL_L3);
					PARTIAL_PROD_extd_L2(2)(END_COL_L3+1)	<= PARTIAL_PROD_extd_L3(1)(END_COL_L3+1);
					PARTIAL_PROD_extd_L2(1)(END_COL_L3+1)	<= PARTIAL_PROD_extd_L3(0)(END_COL_L3+1);
					

							
-----------------------------------2th layer
	COL2:						FOR J IN STRT_COL_L2 TO END_COL_L2 GENERATE	--max layer lenght
	COL2_FIRST_HAS:			IF J <= 1+STRT_COL_L2 GENERATE		--first two columns summed
										HA_L2: HA PORT MAP (PARTIAL_PROD_extd_L2(0)(J), PARTIAL_PROD_extd_L2(1)(J), C_L2(J-2), S_L2(J-2));
									END GENERATE;
	--						
	COL2_FA:						IF J >= 2+STRT_COL_L2 GENERATE --si può riscrivere in maniera più pulita la condizione?
										FA_L2: FA PORT MAP (PARTIAL_PROD_extd_L2(0)(J), PARTIAL_PROD_extd_L2(1)(J), PARTIAL_PROD_extd_L2(2)(J), C_L2(J-2), S_L2(J-2));
									END GENERATE;
								END GENERATE;
								
	S <= S_L2 & PARTIAL_PROD_extd_L2(0)(1 DOWNTO 0);
	C <= C_L2(NUM_HA_FA_L2-1 DOWNTO 0) & PARTIAL_PROD_extd_L2(2)(2) & '0' & PARTIAL_PROD_extd_L2(1)(0);
END ARCHITECTURE;
