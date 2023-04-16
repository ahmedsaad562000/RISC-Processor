library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity RegisterBuffer is
    Generic(N : Integer := 16);
    port
    (
	CLK , RST     : IN std_logic;
        D             : IN std_logic_vector(N - 1 downto 0);
        Q             : OUT std_logic_vector(N - 1 downto 0)
    );
End RegisterBuffer;

Architecture RegisterBuffer_arch OF RegisterBuffer is
Begin 
    Process(CLK , RST)
        Begin 
            IF RST = '1' THEN 
                Q <= (others => '0');
            elsif Rising_edge(CLK) THEN 
                Q <= D;
            End IF; 
    End Process;
End RegisterBuffer_arch;