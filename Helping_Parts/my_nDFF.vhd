
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY my_nDFF IS
	GENERIC (n : INTEGER := 10);
	PORT (
		clk, rst, en : IN STD_LOGIC;
		D : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		Q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
	);
END my_nDFF;
ARCHITECTURE dff OF my_nDFF IS
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			Q <= (OTHERS => '0');
		ELSIF (rising_edge(clk) AND (en = '1')) THEN

			Q <= D;

		END IF;
	END PROCESS;
END dff;