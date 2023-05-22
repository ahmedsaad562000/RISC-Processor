library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port (
        clk , rst , enable , sel1 , sel2 , sel3 : IN std_logic;
        jmp_value : IN std_logic_vector(15 downto 0);
        pc_val            : OUT std_logic_vector(15 downto 0) := (others => '0');
        pc_plus_one            : OUT std_logic_vector(15 downto 0) := (others => '0');
        rst_value : IN std_logic_vector(15 downto 0) := (others => '0')
    );
end PC;

architecture PC_arch of PC is

Signal temp_address : std_logic_vector(15 downto 0) := (others => '0');
Signal PC_Plus1     : std_logic_vector(15 downto 0) := (others => '0');
Signal PC_Plus2     : std_logic_vector(15 downto 0) := (others => '0');
Signal mux1_output   : std_logic_vector(15 downto 0);
Signal mux2_output   : std_logic_vector(15 downto 0);
Signal mux3_output   : std_logic_vector(15 downto 0);

Component MUX_2X1 is
    Generic(N : Integer := 16);
    port (
        A , B : IN std_logic_vector(N - 1 downto 0);
        Sel   : IN std_logic;
        Output: OUT std_logic_vector(N - 1 downto 0)
    );
end Component;
begin

MUX1_BOX : MUX_2X1 generic map(16) port map( PC_Plus1 ,  PC_Plus2 , sel1 , mux1_output);
MUX2_BOX : MUX_2X1 generic map(16) port map( temp_address ,  jmp_value , sel2 , mux2_output);
MUX3_BOX : MUX_2X1 generic map(16) port map( mux1_output ,  mux2_output , sel3 , mux3_output);

PC_Plus1 <= std_logic_vector(unsigned(temp_address) + 1);
PC_Plus2 <= std_logic_vector(unsigned(temp_address) + 2);

Process(clk , rst , enable) is
begin

    
    IF rst = '1' THEN
        temp_address <= rst_value;
    Elsif rising_edge(clk) AND enable = '1' THEN
	temp_address <= mux3_output;
    End IF;
end Process;
pc_val <= temp_address;
pc_plus_one <= PC_Plus1;
end PC_arch;