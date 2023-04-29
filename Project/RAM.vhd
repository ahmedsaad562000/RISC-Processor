LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY RAM IS
    GENERIC (
        N : INTEGER := 64;
        M : INTEGER := 6);
    PORT (
        clk, we, rst : IN STD_LOGIC;
        w_address, r_address_1 , r_address_2 : IN STD_LOGIC_VECTOR(M - 1 DOWNTO 0);
        Write_back_value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        READ_DATA_ONE : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        READ_DATA_TWO : OUT std_logic_vector(15 downto 0)
        );
END RAM;
ARCHITECTURE RAM_arch OF RAM IS
    TYPE ram_type IS ARRAY(0 TO N - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type;
BEGIN
    PROCESS (clk, rst, we) IS
    BEGIN
        IF (rst = '1') THEN
            ram(0 TO N - 1) <= (OTHERS => (OTHERS => '0'));
        ELSIF (rising_edge(clk) AND we = '1') THEN
            ram(to_integer(unsigned(w_address))) <= Write_back_value;
        END IF;
    END PROCESS;
    READ_DATA_ONE <= ram(to_integer(unsigned(r_address_1)));
    READ_DATA_TWO <= ram(to_integer(unsigned(r_address_2)));
END RAM_arch;