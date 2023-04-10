
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_nDFF IS 
GENERIC( n : integer := 10);
	PORT ( clk, rst, en: IN std_logic;
D : in std_logic_vector(n-1 downto 0);
Q : out std_logic_vector(n-1 downto 0)
);
END my_nDFF;


ARCHITECTURE dff OF my_nDFF is
BEGIN
	Process(clk,rst)
	Begin	
if (rst = '1') then
	Q <= (others =>'0');
elsif (rising_edge(clk) and (en = '1') ) then
	
		Q <= D;
	
end if;


end process;


	


	
END dff;