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

component Mux2 IS 
	Generic ( n : Integer:=10);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : in std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END component;

signal Data_Signal : std_logic_vector(15 downto 0);
----------------------------------------------

---------------------------------------------
Begin 

Mux2Dataout :Mux2 generic map(16) port map(memst1,memst2,M2R,Data_Signal);
Data<=Data_signal;
Mux2outport :Mux2 generic map(16) port map((others => '0'),Data_signal,outen,outputport);
Wben<=Wb;
Rsrc1out<=Rsrc1;
Rsrc2out<=Rsrc2;
Rdstout<=Rdst;

End WbRegister_arch;