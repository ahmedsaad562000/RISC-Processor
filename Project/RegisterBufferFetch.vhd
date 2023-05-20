library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity RegisterBufferFetch is
    Generic(N : Integer := 16);
    port
    (
	CLK , RST,WE     : IN std_logic;
        D             : IN std_logic_vector(N - 1 downto 0);
        Q             : OUT std_logic_vector(N - 1 downto 0)
    );
End RegisterBufferFetch;

Architecture RegisterBufferFetch_arch OF RegisterBufferFetch is
Signal TEMP_Q : std_logic_vector(N - 1 downto 0);
Begin 
    Process(CLK , RST)
        Begin 
            IF RST = '1' THEN 
            TEMP_Q <= (others => '0');
            elsif Rising_edge(CLK) and WE= '0' THEN 
            TEMP_Q <= D;
            End IF; 
    End Process;
    Q <= TEMP_Q;
End RegisterBufferFetch_arch;