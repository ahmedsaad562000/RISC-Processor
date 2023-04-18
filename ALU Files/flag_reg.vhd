LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY flag_reg IS
    PORT (
        CLK , WE, W_VAL, RST : IN STD_LOGIC;
        OUT_VAL : OUT STD_LOGIC
    );
END ENTITY flag_reg;

ARCHITECTURE flag_reg_arch OF flag_reg IS
    SIGNAL flag : STD_LOGIC := '0';

BEGIN
    
    PROCESS (CLK , RST) IS
    BEGIN
    IF (rising_edge(clk)) then
        IF rst = '1' THEN
            flag <= '0';
        ELSIF WE = '1' THEN
            flag <= W_VAL;
        END IF;
    END IF;
    END PROCESS;

    OUT_VAL <= flag ;
END flag_reg_arch;