

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Mux4 IS 
	Generic ( n : Integer:=10);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END Mux4;


ARCHITECTURE mux OF Mux4 is
	BEGIN
		
  out1 <= 	in0 when sel = "00"
	else	in1 when sel = "01"
	else	in2 when sel = "10"
	else 	in3; 
END mux;
