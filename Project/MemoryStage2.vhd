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
Rsrc1_Out,Rsrc2_Out,Rdst_Out:out std_logic_vector(2 DOWNTO 0);
------------------------------Additional part Forwarding----------------------------------------------------
Forwarding_Out_MemoryStage2 : OUT std_logic_vector(15 DOWNTO 0);

-----------------------------------FOR BRANCHING-----------------------------------------------------------
RET_FLAG_IN : IN STD_LOGIC;
RET_FLAG_OUT : OUT STD_LOGIC;
MEM_READ_VALUE : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
 );
END MemoryStage2;








ARCHITECTURE MemoryStage2_arch OF MemoryStage2 IS

component RegisterBufferOneBit is
    port
    (
	CLK , RST     : IN std_logic;
        D             : IN std_logic;
        Q             : OUT std_logic
    );
    End component;










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
-----------------------------------Mux2----------------------------------------------------------------
component Mux2 IS 
	Generic ( n : Integer:=10);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : in std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END Component Mux2;


signal WbBufferin : std_logic_vector(43 downto 0):=(others => '0');
signal WbBufferout : std_logic_vector(43 downto 0):=(others => '0');
signal memBuffer : std_logic_vector(15 downto 0):=(others => '0');
SIGNAL NOT_CLK : STD_LOGIC;
--signal BRANCH_BUFF_IN : std_logic:=(others => '0');
--signal BRANCH_BUFF_OUT : std_logic:=(others => '0');

---------------------- FOR BRANCHING---------------------------------------------------------------------
signal RET_FLAG_INTERMEDIATE : STD_LOGIC;
begin
NOT_CLK <= NOT CLK;
The_Memory: Memory generic map(1024,10) port map( clk,MemW,'0',Read_Add_Data(9 downto 0),Write_Data,memBuffer);
WbBufferin<=wb&M2r&OutEn&memBuffer&Read_Add_Data&Rsrc1&Rsrc2&Rdst;
Writeback_Buffer  : RegisterBuffer generic map(44) port map( NOT_CLK , RST , WbBufferin ,WbBufferout);

MUX_2X1_BOX : MUX2 GENERIC MAP(16) PORT MAP(Read_Add_Data,memBuffer,M2r,Forwarding_Out_MemoryStage2);


---------------------------------------------------------------------------------
BRANCH_DELAY_BUFFER : RegisterBufferOneBit PORT MAP(CLK, RST, RET_FLAG_IN, RET_FLAG_OUT);
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




wbout<=WbBufferout(43);
M2ROut<=WbBufferout(42);
OutenOut<=WbBufferout(41);
Sp_IncOut<=Sp_inc;
Sp_DecOut<=Sp_dec;
CallSignalOut<=CallSignal;
pc_out<=Pc_Plus_one;
Memory_out_data<=WbBufferout(40 downto 25);
read_add_data_out<=WbBufferout(24 downto 9);
Rsrc1_out<=WbBufferout(8 downto 6);
Rsrc2_out<=WbBufferout(5 downto 3);
Rdst_out<=WbBufferout(2 downto 0);

---------------------- FOR BRANCHING---------------------------------------------------------------------
--RET_FLAG_INTERMEDIATE <= RET_FLAG_IN;
--RET_FLAG_OUT <= RET_FLAG_INTERMEDIATE;
MEM_READ_VALUE <=memBuffer ;

--BRANCH_BUFF_IN <=  RET_FLAG_IN;

END MemoryStage2_arch;