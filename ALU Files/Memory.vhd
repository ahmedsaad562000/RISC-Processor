library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

ENTITY Memory IS
Generic(N : Integer := 1024; M:Integer :=10 );
PORT (
clk,we,rst: IN std_logic;
raddress : IN std_logic_vector(M-1 DOWNTO 0);
datain : IN std_logic_vector(15 DOWNTO 0);
dataout : OUT std_logic_vector(15 DOWNTO 0) );
END Memory;

ARCHITECTURE Memory_arch OF Memory IS
TYPE ram_type IS ARRAY(0 TO N - 1) of std_logic_vector(15 DOWNTO 0);
SIGNAL ram : ram_type ;	
BEGIN
PROCESS(clk,rst,we) IS
BEGIN
IF (rst = '1')  THEN
ram(0 to N-1) <= (others => (others => '0'));
ELSIF( rising_edge(clk) and we='1') THEN
ram(to_integer(unsigned(raddress))) <= datain;
END IF;
END PROCESS;
dataout <= ram(to_integer(unsigned(raddress)));
END Memory_arch;
