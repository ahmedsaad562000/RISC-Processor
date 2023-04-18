library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

ENTITY MemoryStage2 IS
PORT (
clk,rst,Wb,M2R,Sp_inc,Sp_dec,MemW,OutEn,CallSignal: IN std_logic;
Pc_Plus_one,Read_Add_Data,Write_Data : IN std_logic_vector(15 DOWNTO 0);
Rsrc1,Rsrc2,Rdst:IN std_logic_vector(2 DOWNTO 0);
WbOut,M2ROut,Sp_IncOut,Sp_decOut,OutEnOut,CallSignalOut:out std_logic;
Pc_Out,Memory_Out_data,Read_add_Data_out : OUT std_logic_vector(15 DOWNTO 0);
Rsrc1_Out,Rsrc2_Out,Rdst_Out:out std_logic_vector(2 DOWNTO 0)
 );
END MemoryStage2;


ARCHITECTURE MemoryStage2_arch OF MemoryStage2 IS
component RegisterBuffer is
    Generic(N : Integer := 16);
    port
    (
	CLK , RST     : IN std_logic;
        D             : IN std_logic_vector(N - 1 downto 0);
        Q             : OUT std_logic_vector(N - 1 downto 0)
    );
End component;
component Memory IS
Generic(N : Integer := 1024; M:Integer :=10 );
PORT (
clk,we,rst: IN std_logic;
raddress : IN std_logic_vector(M-1 DOWNTO 0);
datain : IN std_logic_vector(15 DOWNTO 0);
dataout : OUT std_logic_vector(15 DOWNTO 0) );
END component;
signal Mem2WbBufferin : std_logic_vector(63 downto 0):=(others => '0');
signal Mem2WbBufferout : std_logic_vector(63 downto 0):=(others => '0');
begin
Mem2WbBufferin<=pc_plus_one&wb&M2r&Sp_inc&Sp_dec&Memw&OutEn&CallSignal&Read_Add_Data&Write_data&Rsrc1&Rsrc2&Rdst;
The_Buffer: RegisterBuffer generic map(64) port map(CLK , RST , Mem2WbBufferin , Mem2WbBufferout);
The_Memory: Memory generic map(1024,10) port map(clk,Mem2WbBufferout(43),rst,Mem2WbBufferout(34 downto 25),Mem2WbBufferout(24 downto 9),Memory_out_data);
wbout<=Mem2WbBufferout(47);
M2ROut<=Mem2WbBufferout(46);
Sp_IncOut<=Mem2WbBufferout(45);
Sp_DecOut<=Mem2WbBufferout(44);
OutenOut<=Mem2WbBufferout(42);
CallSignalOut<=Mem2WbBufferout(41);
pc_out<=Mem2WbBufferout(63 downto 48);
read_add_data_out<=Mem2WbBufferout(40 downto 25);
Rsrc1_out<=Mem2WbBufferout(8 downto 6);
Rsrc2_out<=Mem2WbBufferout(5 downto 3);
Rdst_out<=Mem2WbBufferout(2 downto 0);
END MemoryStage2_arch;