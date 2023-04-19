LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY WbRegister IS
	PORT (
		clk, rst,wb,M2R,OutEn : IN STD_LOGIC;
		MemSt2,MemSt1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		Rsrc1,Rsrc2,Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                       WbEn : out STD_LOGIC;
                 Data,outputport : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
                   Rsrc1out,Rsrc2out,Rdstout : out STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END WbRegister;

Architecture WbRegister_arch OF WbRegister is
component RegisterBuffer is
    Generic(N : Integer := 16);
    port
    (
	CLK , RST     : IN std_logic;
        D             : IN std_logic_vector(N - 1 downto 0);
        Q             : OUT std_logic_vector(N - 1 downto 0)
    );
End component;
component Mux2 IS 
	Generic ( n : Integer:=10);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : in std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END component;
signal WbBufferin : std_logic_vector(43 downto 0);
signal WbBufferout : std_logic_vector(43 downto 0);
signal Data_Signal : std_logic_vector(15 downto 0);
----------------------------------------------
signal NOT_CLK : std_logic;
---------------------------------------------
Begin 
WbBufferin<=wb&M2r&outEn&MemSt2&MemSt1&Rsrc1&Rsrc2&Rdst;
Writeback_Buffer  : RegisterBuffer generic map(44) port map(NOT_CLK , RST , WbBufferin , WbBufferout);
Mux2Dataout :Mux2 generic map(16) port map(Wbbufferout(24 downto 9),Wbbufferout(40 downto 25),wbbufferout(42),Data_Signal);
Data<=Data_signal;
Mux2outport :Mux2 generic map(16) port map((others => '0'),Data_signal,wbbufferout(41),outputport);
Wben<=WbBufferout(43);
Rsrc1out<=WbBufferout(8 downto 6);
Rsrc2out<=WbBufferout(5 downto 3);
Rdstout<=WbBufferout(2 downto 0);
NOT_CLK <= not clk;
End WbRegister_arch;