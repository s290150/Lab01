LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FA IS
PORT (a, b						: IN STD_LOGIC;
		cin						: IN STD_LOGIC;
		cout						: OUT STD_LOGIC;
		s							: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE STRUCT OF FA IS
BEGIN
	s <= a XOR b XOR cin;
	cout <= (a AND b) OR (cin AND (a XOR b));
END STRUCT;
