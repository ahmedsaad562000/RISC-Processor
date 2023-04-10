
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Mux2 IS 
	Generic ( n : Integer:=10);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : in std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END Mux2;


ARCHITECTURE mux OF Mux2 is
	BEGIN
		
  out1 <= 	in0 when sel = '0'
	else	in1 when sel = '1' else in1;
END mux;