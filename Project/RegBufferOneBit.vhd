library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity RegisterBufferOneBit is
    port
    (
	CLK , RST     : IN std_logic;
        D             : IN std_logic;
        Q             : OUT std_logic
    );
End RegisterBufferOneBit;

Architecture RegisterBufferOneBit_arch OF RegisterBufferOneBit is
Begin 
    Process(CLK , RST)
        Begin 
            IF RST = '1' THEN 
                Q <= '0';
            elsif Rising_edge(CLK) THEN 
                Q <= D;
            End IF; 
    End Process;
End RegisterBufferOneBit_arch;