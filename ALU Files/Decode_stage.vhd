library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decode_stage is
    port 
    (
        RST             : IN std_logic;
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
        JMP_FLAG        : OUT STD_LOGIC
    );
end Decode_stage;

architecture Decode_stage_arch of Decode_stage is
------------------------------------- Components --------------------------------
Component Controlller IS
    PORT (
        CAT : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        OP : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        FLAGS : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
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
---------------------------------------------------------------------------------
------------------------------------- Signals -----------------------------------
Signal RSRC1_Value_Signal     : std_logic_vector(15 downto 0);
Signal RSRC2_Value_Signal     : std_logic_vector(15 downto 0);
Signal Controller_Out_Signal  : std_logic_vector(19 downto 0);
Signal Decode_Buffer_IN       : std_logic_vector(87 downto 0);
Signal Decode_Buffer_OUT      : std_logic_vector(87 downto 0);
---------------------------------------------------------------------------------
begin
Decode_Buffer_IN <= Controller_Out_Signal(15 downto 14) & Controller_Out_Signal(12 downto 0) & PC_PLUS_ONE_IN & RSRC1_ADD & RSRC2_ADD & RDST_ADD & RSRC1_Value_Signal & RSRC2_Value_Signal & IMM_OR_INPUT;
----------------------------------------- BOXES ---------------------------------------------------------------------------------------------------------------------------------------------------
REG_FILE       : RAM generic map(8 , 3) port map(CLK , RST , Write_back_Enable , Write_back_ADD , RSRC1_ADD , RSRC2_ADD , Write_back_value , RSRC1_Value_Signal , RSRC2_Value_Signal);
Controller_BOX : Controlller port map(CAT_IN , OP_CODE , FLAGS , Controller_Out_Signal); 
Decode_Buffer  : RegisterBuffer generic map(88) port map(CLK , RST , Decode_Buffer_IN , Decode_Buffer_OUT);
----------------------------------OUTPUTS----------------------------------------------------------------------------------------------------------------------------------------------------------
JMP_FLAG        <= Controller_Out_Signal(13);
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
end architecture;