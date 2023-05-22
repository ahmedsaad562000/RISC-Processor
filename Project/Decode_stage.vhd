library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decode_stage is
    port 
    (
        ALL_RST             : IN std_logic;
        BUFFER_RST           : IN std_logic;
        CLK             : IN std_logic;
        RSRC1_ADD       : IN std_logic_vector(2 downto 0);
        RSRC2_ADD       : IN std_logic_vector(2 downto 0);
        RDST_ADD        : IN std_logic_vector(2 downto 0);
        PC_PLUS_ONE_IN  : IN std_logic_vector(15 downto 0);
        OP_CODE         : IN std_logic_vector(4 downto 0);
        CAT_IN          : IN std_logic_vector(1 downto 0);
        IMM_OR_INPUT    : IN std_logic_vector(15 downto 0);
        Write_back_Enable: IN std_logic;
        Write_back_value: IN std_logic_vector(15 downto 0);
        Write_back_ADD  : IN std_logic_vector(2 downto 0);
        FLAGS           : IN std_logic_vector(2 downto 0);
        SET_CLEAR       : OUT std_logic_vector(1 downto 0);
        PC_PLUS_ONE_OUT : OUT std_logic_vector(15 downto 0);
        Write_back      : OUT std_logic;
        MEM_SRC         : OUT std_logic;
        SP_INC          : OUT std_logic;
        SP_DEC          : OUT std_logic;
        MEM_WRITE       : OUT std_logic;
        Out_Signal      : OUT std_logic;
        CALL_Signal     : OUT std_logic;
        ALU_Operation   : OUT std_logic_vector(2 downto 0);
        CIN_Signal      : OUT std_logic;
        MEM_TO_REG      : OUT std_logic;
        RSRC1_Value     : OUT std_logic_vector(15 downto 0);
        RSRC2_Value     : OUT std_logic_vector(15 downto 0);
        ALU_SRC         : OUT std_logic;
        RSRC1_ADD_OUT   : OUT std_logic_vector(2 downto 0);
        RSRC2_ADD_OUT   : OUT std_logic_vector(2 downto 0);
        RDST_ADD_OUT    : OUT std_logic_vector(2 downto 0);
        IMM_OR_IN_OUT   : OUT std_logic_vector(15 downto 0);
        JMP_FLAG        : OUT STD_LOGIC;
        --FOR FETCH--------------------
        OP_CODE_OUT    : OUT std_logic_vector(4 downto 0);
        CAT_OUT        : OUT std_logic_vector(1 downto 0);
        -------------------------------
   ----------------------------Load Additional--------------------------------------------------------------------
    Exec_Mem1_Mem_to_Register: IN std_logic;
    Exec_Memory1_Rt: IN std_logic_vector(2 downto 0);
    Load_Out: Out std_logic;
    
    ----------------------------Memory Additional--------------------------------------------------------------------
    Execute_Call,Execute_MemW,Execute_MemSrc,Execute_Mem_to_Reg: IN std_logic;

    ---------------------------------------------------------------------------------------------------------------
    ---------------------------Branch Additional--------------------------------------------------------------------

    DEC_EXEC_RET_OUT : OUT std_logic;

    ----------------------------Memory Additional2--------------------------------------------------------------------
    Decode_Call,Decode_MemW,Decode_MemSrc,Decode_Mem_to_Reg: out std_logic;
    IS_TWO_MEMORY: in std_logic

    );
end Decode_stage;

architecture Decode_stage_arch of Decode_stage is
------------------------------------- Components --------------------------------
Component Controlller IS
    PORT (
        CAT : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        OP : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        FLAGS : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        rst : IN STD_LOGIC;
        OUT_SIGNALS : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
    );
END Component;
Component RegisterBuffer is
    Generic(N : Integer := 16);
    port
    (
	CLK , RST     : IN std_logic;
        D             : IN std_logic_vector(N - 1 downto 0);
        Q             : OUT std_logic_vector(N - 1 downto 0)
    );
End Component;
Component RAM IS
    GENERIC (N : INTEGER := 64; M : INTEGER := 6);
    PORT (
        clk, we, rst : IN STD_LOGIC;
        w_address, r_address_1 , r_address_2 : IN STD_LOGIC_VECTOR(M - 1 DOWNTO 0);
        Write_back_value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        READ_DATA_ONE : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        READ_DATA_TWO : OUT std_logic_vector(15 downto 0)
        );
END Component;
---------------------------------------------LoadUseUnit-------------------------------------------------------------------

component LoadDetection IS

PORT (  Dec_Exec_MemRead,Exec_Mem1_MemRead: IN std_logic;
        Dec_Exec_Rt,Exec_Mem1_Rt,Fet_Dec_Rs,Fet_Dec_Rt: IN std_logic_vector(2 downto 0);   
        OUT1 : OUT std_logic;
        Decode_Call,Decode_MemW,Decode_MemSrc,Decode_Mem_to_Reg,Execute_Call,Execute_MemW,Execute_MemSrc,Execute_Mem_to_Reg: IN std_logic

);
END component LoadDetection;
---------------------------------------------------------------------------------
------------------------------------- Signals -----------------------------------
Signal RSRC1_Value_Signal     : std_logic_vector(15 downto 0);
Signal RSRC2_Value_Signal     : std_logic_vector(15 downto 0);
Signal Controller_Out_Signal  : std_logic_vector(19 downto 0);
Signal Decode_Buffer_IN       : std_logic_vector(89 downto 0);
Signal Decode_Buffer_OUT      : std_logic_vector(89 downto 0);
Signal NOT_CLK                : std_logic;
Signal Load_Out_Signal        : std_logic;
Signal result:                  std_logic;



------------------FOR RESET LOGIC------------------------------------------------
SIGNAL RESET_DECODE_EXECUTE_BUFFER : STD_LOGIC;





---------------------------------------------------------------------------------







begin
 result<=Load_Out_Signal or IS_TWO_MEMORY;   
Decode_Buffer_IN <= Controller_Out_Signal(16) & Controller_Out_Signal(13) & Controller_Out_Signal(15 downto 14) & Controller_Out_Signal(12 downto 0) & PC_PLUS_ONE_IN & RSRC1_ADD & RSRC2_ADD & RDST_ADD & RSRC1_Value_Signal & RSRC2_Value_Signal & IMM_OR_INPUT;
----------------------------------------- BOXES ---------------------------------------------------------------------------------------------------------------------------------------------------
REG_FILE       : RAM generic map(8 , 3) port map(CLK , Write_back_Enable, ALL_RST, Write_back_ADD , RSRC1_ADD , RSRC2_ADD , Write_back_value , RSRC1_Value_Signal , RSRC2_Value_Signal);
Controller_BOX : Controlller port map(CAT_IN , OP_CODE , FLAGS,result , Controller_Out_Signal); 
Decode_Buffer  : RegisterBuffer generic map(90) port map(NOT_CLK , RESET_DECODE_EXECUTE_BUFFER , Decode_Buffer_IN , Decode_Buffer_OUT);
--mmkn nrg3 in
Load_Unit:       LoadDetection port map(Decode_Buffer_OUT(73),Exec_Mem1_Mem_to_Register,Decode_Buffer_OUT(50 downto 48), Exec_Memory1_Rt,RSRC1_ADD ,RSRC2_ADD,Load_Out_Signal,Decode_Buffer_OUT(74),Decode_Buffer_OUT(81),Decode_Buffer_OUT(84),Decode_Buffer_OUT(73),Execute_Call,Execute_MemW,Execute_MemSrc,Execute_Mem_to_Reg);
-- Load_Unit:       LoadDetection port map(Decode_Buffer_OUT(73),Exec_Mem1_Mem_to_Register,Decode_Buffer_OUT(50 downto 48), Exec_Memory1_Rt,RSRC1_ADD ,RSRC2_ADD,Load_Out_Signal,Decode_Buffer_IN(74),Decode_Buffer_IN(81),Decode_Buffer_IN(84),Decode_Buffer_IN(73),Decode_Buffer_OUT(74),Decode_Buffer_OUT(81),Decode_Buffer_OUT(84),Decode_Buffer_OUT(73));

Decode_Call<=Decode_Buffer_IN(74);
Decode_MemW<=Decode_Buffer_IN(81);
Decode_MemSrc<=Decode_Buffer_IN(84);
Decode_Mem_to_Reg<=Decode_Buffer_IN(73);

----------------------------------OUTPUTS----------------------------------------------------------------------------------------------------------------------------------------------------------
Load_Out<=Load_Out_Signal;
---------------------for branching---------------------
DEC_EXEC_RET_OUT <= Decode_Buffer_OUT(89);
JMP_Flag <= Decode_Buffer_OUT(88);
-------------------------------------------------------
SET_CLEAR       <= Decode_Buffer_OUT(87 downto 86);
Write_back      <= Decode_Buffer_OUT(85);
MEM_SRC         <= Decode_Buffer_OUT(84);
SP_INC          <= Decode_Buffer_OUT(83);
SP_DEC          <= Decode_Buffer_OUT(82);
MEM_WRITE       <= Decode_Buffer_OUT(81);
Out_Signal      <= Decode_Buffer_OUT(80);
ALU_SRC         <= Decode_Buffer_OUT(79);
ALU_Operation   <= Decode_Buffer_OUT(78 downto 76);
CIN_Signal      <= Decode_Buffer_OUT(75);
CALL_Signal     <= Decode_Buffer_OUT(74);
MEM_TO_REG      <= Decode_Buffer_OUT(73);
PC_PLUS_ONE_OUT <= Decode_Buffer_OUT(72 downto 57);
RSRC1_ADD_OUT   <= Decode_Buffer_OUT(56 downto 54);
RSRC2_ADD_OUT   <= Decode_Buffer_OUT(53 downto 51);
RDST_ADD_OUT    <= Decode_Buffer_OUT(50 downto 48);
RSRC1_Value     <= Decode_Buffer_OUT(47 downto 32);
RSRC2_Value     <= Decode_Buffer_OUT(31 downto 16);
IMM_OR_IN_OUT   <= Decode_Buffer_OUT(15 downto 0);
NOT_CLK         <= not CLK;
----------------------------------FOR FETCH----------------------------------------------------------------------------------------------------------------------------------------------------------

OP_CODE_OUT    <= OP_CODE;
CAT_OUT        <= CAT_IN;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------FOR RESET--------------------------------------------------------------------------------------------------------------------------------------------------------
RESET_DECODE_EXECUTE_BUFFER <= ALL_RST or BUFFER_RST;
end architecture;