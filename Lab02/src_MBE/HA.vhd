LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY HA IS
PORT (a, b						: IN STD_LOGIC;
		cout						: OUT STD_LOGIC;
		s							: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE STRUCT OF HA IS
BEGIN
	s <= a XOR b;
	cout <= a AND b;
END STRUCT;
