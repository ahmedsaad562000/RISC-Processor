LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY MEM_ONE IS
    PORT (
        RST : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        PC_PLUS_ONE : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        WB : IN STD_LOGIC;
        MEM_SRC : IN STD_LOGIC;
        SP_INC : IN STD_LOGIC;
        SP_DEC : IN STD_LOGIC;
        MEMW : IN STD_LOGIC;
        OUT_SIG : IN STD_LOGIC;
        CALL_SIG : IN STD_LOGIC;
        MEM_TO_REG : IN STD_LOGIC;
        ALU_RESULT : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        RSRC1_ADD : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        RSRC2_ADD : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        RDST_ADD : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        RSRC2_VAL : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        SP_INC_FORWARD:IN STD_LOGIC;
        SP_DEC_FORWARD:IN STD_LOGIC;

        PC_PLUS_ONE_OUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        WB_OUT : OUT STD_LOGIC;
        SP_INC_OUT : OUT STD_LOGIC;
        SP_DEC_OUT : OUT STD_LOGIC;
        MEMW_OUT : OUT STD_LOGIC;
        OUT_SIG_OUT : OUT STD_LOGIC;
        CALL_SIG_OUT : OUT STD_LOGIC;
        MEM_TO_REG_OUT : OUT STD_LOGIC;
        READ_ADD_OUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        WRITE_DATA_OUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        RSRC1_ADD_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        RSRC2_ADD_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        RDST_ADD_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        ----------------------------FOR BRANCHING--------------------------------
        RET_FLAG_IN : IN STD_LOGIC;
        RET_FLAG_OUT : OUT STD_LOGIC;
        INTERMEDIATE_RET_FLAG_OUT : OUT STD_LOGIC

    );
END MEM_ONE;

ARCHITECTURE MEM_ONE_ARCH OF MEM_ONE IS
    ----------------------------------------COMPONENTS----------------------------------------
    COMPONENT SP IS
        PORT (
            clk, rst : IN STD_LOGIC;
            SP_INC : IN STD_LOGIC;
            SP_DEC : IN STD_LOGIC;
            SP_VALUE : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT MUX_2X1 IS
        GENERIC (N : INTEGER := 16);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Sel : IN STD_LOGIC;
            Output : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT RegisterBuffer IS
        GENERIC (N : INTEGER := 16);
        PORT (
            CLK, RST : IN STD_LOGIC;
            D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT RegisterBuffer;
    ----------------------------------------SIGNALS--------------------------------------------
    SIGNAL SP_OUT : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL SP_PLUS_ONE_OUT : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL MUX_SP_OUT : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL READ_ADDRESS_IN : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL WRITE_DATA_IN : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL MEM_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL MEM_IN : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL BUFF_IN : STD_LOGIC_VECTOR (64 DOWNTO 0);
    SIGNAL BUFF_OUT : STD_LOGIC_VECTOR (64 DOWNTO 0);
    ----------------------------------------
    SIGNAL NOT_CLK : STD_LOGIC;
    ---------------------------------------
    ----------for branching----------------
    SIGNAL INTER_RET_FLAG : STD_LOGIC; 
BEGIN
--------------------------------------------BOXES----------------------------------------------
SP_BOX : SP PORT MAP(CLK,RST,SP_INC_FORWARD,SP_DEC_FORWARD,SP_OUT);
MUX_SP : MUX_2X1 GENERIC MAP(16) PORT MAP(SP_OUT,SP_PLUS_ONE_OUT,SP_INC,MUX_SP_OUT);
MUX_READ_ADD : MUX_2X1 GENERIC MAP(16) PORT MAP(ALU_RESULT,MUX_SP_OUT,MEM_SRC,READ_ADDRESS_IN);
MUX_WRITE_DATA : MUX_2X1 GENERIC MAP(16) PORT MAP(RSRC2_VAL,PC_PLUS_ONE,CALL_SIG,WRITE_DATA_IN);
REG_MEM_ONE : RegisterBuffer GENERIC MAP(32) PORT MAP (CLK,RST,MEM_IN,MEM_OUT);
MEM1_MEM2_BUFF : RegisterBuffer GENERIC MAP(65) PORT MAP (NOT_CLK,RST,BUFF_IN,BUFF_OUT);
--------------------------------------------LOGIC----------------------------------------------
--SP_PLUS_ONE_OUT <= STD_LOGIC_VECTOR(unsigned(SP_OUT) + 1);
SP_PLUS_ONE_OUT <= SP_OUT;

MEM_IN <=  READ_ADDRESS_IN & WRITE_DATA_IN;
BUFF_IN <=  RET_FLAG_IN & PC_PLUS_ONE & WB & MEM_TO_REG & SP_INC & SP_DEC & MEMW & OUT_SIG & CALL_SIG & MEM_OUT & RSRC1_ADD & RSRC2_ADD & RDST_ADD;
--------------------------------------------OUTPUTS--------------------------------------------
INTERMEDIATE_RET_FLAG_OUT <= INTER_RET_FLAG;
INTER_RET_FLAG <= RET_FLAG_IN;
RET_FLAG_OUT <= BUFF_OUT(64);
PC_PLUS_ONE_OUT <= BUFF_OUT(63 DOWNTO 48);
WB_OUT <= BUFF_OUT(47);
MEM_TO_REG_OUT <= BUFF_OUT(46);
SP_INC_OUT <= BUFF_OUT(45);     
SP_DEC_OUT <= BUFF_OUT(44);
MEMW_OUT <= BUFF_OUT(43);
OUT_SIG_OUT <= BUFF_OUT(42);
CALL_SIG_OUT <= BUFF_OUT(41);
READ_ADD_OUT <= BUFF_OUT (40 DOWNTO 25 );
WRITE_DATA_OUT <= BUFF_OUT (24 DOWNTO 9);
RSRC1_ADD_OUT <=  BUFF_OUT(8 DOWNTO 6);
RSRC2_ADD_OUT <=  BUFF_OUT(5 DOWNTO 3) ;
RDST_ADD_OUT  <=  BUFF_OUT(2 DOWNTO 0);
-------------------------------------------------------------------------------------------

NOT_CLK <= NOT CLK;
-------------------------------------------------------------------------------------------
END MEM_ONE_ARCH;