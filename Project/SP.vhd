LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SP IS
    PORT (
        clk, rst : IN STD_LOGIC;
        SP_INC : IN STD_LOGIC;
        SP_DEC : IN STD_LOGIC;
        SP_VALUE : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END SP;

ARCHITECTURE SP_ARCH OF SP IS
    SIGNAL TEMP_SP_VALUE : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            TEMP_SP_VALUE <= x"03FF";
        ELSIF rising_edge(clk) AND SP_INC = '1' THEN
            TEMP_SP_VALUE <= STD_LOGIC_VECTOR(unsigned(TEMP_SP_VALUE) + 1);
        ELSIF rising_edge(clk) AND SP_DEC = '1' THEN
            TEMP_SP_VALUE <= STD_LOGIC_VECTOR(unsigned(TEMP_SP_VALUE) - 1);
        ELSE
            TEMP_SP_VALUE <= TEMP_SP_VALUE;
        END IF;
    END PROCESS;
    SP_VALUE <= TEMP_SP_VALUE;
END SP_ARCH;