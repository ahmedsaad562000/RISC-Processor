LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY inst_cache IS
	PORT(
		address : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0);
		M0 : OUT std_logic_vector(7 DOWNTO 0);
		M1 : OUT std_logic_vector(7 DOWNTO 0));
END ENTITY inst_cache;

ARCHITECTURE inst_cach_arch OF inst_cache IS

	TYPE inst_cache_type IS ARRAY(0 TO 2**10) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL inst_cache : inst_cache_type ;
	
	BEGIN
		M0 <= inst_cache(0);
		M1 <= inst_cache(1);
		dataout <= inst_cache(to_integer(unsigned(address))) & inst_cache(to_integer(unsigned(address))+1) ;
END inst_cach_arch;