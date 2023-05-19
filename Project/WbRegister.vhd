LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY WbRegister IS
	PORT (
		wb,M2R,OutEn : IN STD_LOGIC;
		MemSt2,MemSt1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		Rsrc1,Rsrc2,Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                       WbEn : out STD_LOGIC;
                 Data,outputport : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
                   Rsrc1out,Rsrc2out,Rdstout : out STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END WbRegister;

Architecture WbRegister_arch OF WbRegister is

	component MUX_2X1 is
		Generic(N : Integer := 16);
		port (
			A , B : IN std_logic_vector(N - 1 downto 0);
			Sel   : IN std_logic;
			Output: OUT std_logic_vector(N - 1 downto 0)
		);
	end component MUX_2X1;

signal Data_Signal : std_logic_vector(15 downto 0);
----------------------------------------------

---------------------------------------------
Begin 

Mux2Dataout : MUX_2X1 generic map(16) port map(memst1,memst2,M2R,Data_Signal);
Data<=Data_signal;
Mux2outport :MUX_2X1 generic map(16) port map((others => '0'),Data_signal,outen,outputport);
Wben<=Wb;
Rsrc1out<=Rsrc1;
Rsrc2out<=Rsrc2;
Rdstout<=Rdst;

End WbRegister_arch;