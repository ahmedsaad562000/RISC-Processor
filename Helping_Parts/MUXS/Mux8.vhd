


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Mux8 IS 
	Generic ( n : Integer:=10);
	PORT ( in0,in1,in2,in3,in4,in5,in6,in7 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (2 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END Mux8;


ARCHITECTURE mux OF Mux8 is
	BEGIN
		
  out1 <= 	in0 when sel = "000"
	else	in1 when sel = "001"
	else	in2 when sel = "010"
	else    in3 when sel = "011"
	else	in4 when sel = "100"
	else	in5 when sel = "101"	
	else	in6 when sel = "110"
	else 	in7 when sel = "111"
	else (others => '0'); 
END mux;