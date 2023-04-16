library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port (
        clk , rst , enable , sel : IN std_logic;
        address            : OUT std_logic_vector(15 downto 0) := (others => '0')
    );
end PC;

architecture PC_arch of PC is

Signal temp_address : std_logic_vector(15 downto 0) := (others => '0');
Signal PC_Plus1     : std_logic_vector(15 downto 0) := (others => '0');
Signal PC_Plus2     : std_logic_vector(15 downto 0) := (others => '0');
Signal mux_output   : std_logic_vector(15 downto 0);

Component MUX_2X1 is
    Generic(N : Integer := 16);
    port (
        A , B : IN std_logic_vector(N - 1 downto 0);
        Sel   : IN std_logic;
        Output: OUT std_logic_vector(N - 1 downto 0)
    );
end Component;
begin

MUX_BOX : MUX_2X1 generic map(16) port map( PC_Plus1 ,  PC_Plus2 , sel , mux_output);

Process(clk , rst , enable) is
begin
    PC_Plus1 <= std_logic_vector(unsigned(temp_address) + 1);
    PC_Plus2 <= std_logic_vector(unsigned(temp_address) + 2);
    IF rst = '1' THEN
        temp_address <= (others => '0');
    Elsif rising_edge(clk) AND enable = '1' THEN
	temp_address <= mux_output;
    End IF;
end Process;
address <= temp_address;
end architecture;