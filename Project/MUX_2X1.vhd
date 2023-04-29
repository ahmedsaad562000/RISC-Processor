library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2X1 is
    Generic(N : Integer := 16);
    port (
        A , B : IN std_logic_vector(N - 1 downto 0);
        Sel   : IN std_logic;
        Output: OUT std_logic_vector(N - 1 downto 0)
    );
end MUX_2X1;

architecture MUX_2X1_arch of MUX_2X1 is
begin
Output <= A When Sel = '0'
else B;
end architecture;