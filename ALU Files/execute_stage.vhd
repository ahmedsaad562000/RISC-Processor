LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Execute_stage IS
    PORT (
        RST : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        SET_CLEAR : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        PC_PLUS_ONE : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Write_back : IN STD_LOGIC;
        MEM_SRC : IN STD_LOGIC;
        SP_INC : IN STD_LOGIC;
        SP_DEC : IN STD_LOGIC;
        MEM_WRITE : IN STD_LOGIC;
        Out_Signal : IN STD_LOGIC;
        CALL_Signal : IN STD_LOGIC;
        ALU_Operation : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        CIN_Signal : IN STD_LOGIC;
        MEM_TO_REG : IN STD_LOGIC;
        RSRC1_Value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RSRC2_Value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALU_SRC : IN STD_LOGIC;
        RSRC1_ADD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RSRC2_ADD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RDST_ADD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        IMM_OR_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        ZF_OUT : OUT STD_LOGIC;
        CF_OUT : OUT STD_LOGIC;
        NF_OUT : OUT STD_LOGIC;
        PC_PLUS_ONE_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Write_back_OUT : OUT STD_LOGIC;
        MEM_SRC_OUT : OUT STD_LOGIC;
        SP_INC_OUT : OUT STD_LOGIC;
        SP_DEC_OUT : OUT STD_LOGIC;
        MEM_WRITE_OUT : OUT STD_LOGIC;
        Out_Signal_OUT : OUT STD_LOGIC;
        CALL_Signal_OUT : OUT STD_LOGIC;
        MEM_TO_REG_OUT : OUT STD_LOGIC;
        Result_Value_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        RSRC2_Value_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        RSRC1_ADD_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        RSRC2_ADD_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        RDST_ADD_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END Execute_stage;

ARCHITECTURE Execute_stage_arch OF Execute_stage IS
    ------------------------------------- Components --------------------------------
    COMPONENT flag_reg IS
        PORT (
            CLK, WE, W_VAL, RST : IN STD_LOGIC;
            OUT_VAL : OUT STD_LOGIC
        );
    END COMPONENT flag_reg;
    COMPONENT RegisterBuffer IS
        GENERIC (N : INTEGER := 16);
        PORT (
            CLK, RST : IN STD_LOGIC;
            D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT Alu IS
        GENERIC (n : INTEGER := 16);
        PORT (
            sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            inpA, inpB : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            --need to add cin
            cout : OUT STD_LOGIC;
            zerof : OUT STD_LOGIC;
            NegF : OUT STD_LOGIC;
            coutWE : OUT STD_LOGIC;
            zerofWe : OUT STD_LOGIC;
            NegFWe : OUT STD_LOGIC;
            OUT1 : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT Alu;

    COMPONENT MUX_2X1 IS
        GENERIC (N : INTEGER := 16);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Sel : IN STD_LOGIC;
            Output : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT MUX_2X1;
    ---------------------------------------------------------------------------------
    ------------------------------------- Signals -----------------------------------
    SIGNAL MUX_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ALU_RESULT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ZF_VALUE : STD_LOGIC;
    SIGNAL CF_VALUE : STD_LOGIC;
    SIGNAL NF_VALUE : STD_LOGIC;
    SIGNAL ZF_WE : STD_LOGIC;
    SIGNAL CF_WE : STD_LOGIC;
    SIGNAL NF_WE : STD_LOGIC;
    SIGNAL EX_MEM1_REG_IN : STD_LOGIC_VECTOR(64 DOWNTO 0);
    SIGNAL EX_MEM1_REG_OUT : STD_LOGIC_VECTOR(64 DOWNTO 0);
    SIGNAL CF_WE_OR_OUT : STD_LOGIC;
    SIGNAL CF_VAL_OR_OUT : STD_LOGIC;

    signal NOT_CLK : STD_LOGIC;



    -- SIGNAL ZF_VALUE_OUT_TEMP : STD_LOGIC;
    -- SIGNAL NF_VALUE_OUT_TEMP : STD_LOGIC;
    -- SIGNAL CF_VALUE_OUT_TEMP : STD_LOGIC;

    ---------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------
BEGIN
    ----------------------------------------- BOXES ---------------------------------------------------------------------------------------------------------------------------------------------------
    MUX_2X1_BOX : MUX_2X1 GENERIC MAP(16) PORT MAP(RSRC2_Value, IMM_OR_IN, ALU_SRC, MUX_OUTPUT);
    ALU_BOX : Alu GENERIC MAP(16) PORT MAP(ALU_Operation, RSRC1_Value, MUX_OUTPUT, CF_VALUE, ZF_VALUE, NF_VALUE, CF_WE, ZF_WE, NF_WE, ALU_RESULT);
    ZF_BOX : flag_reg PORT MAP(CLK ,ZF_WE, ZF_VALUE, RST, ZF_OUT);
    CF_BOX : flag_reg PORT MAP(CLK ,CF_WE_OR_OUT, CF_VAL_OR_OUT, RST, CF_OUT);
    NF_BOX : flag_reg PORT MAP(CLK ,NF_WE, NF_VALUE, RST, NF_OUT);

    EX_MEM1_REG : RegisterBuffer GENERIC MAP(65) PORT MAP(NOT_CLK, RST, EX_MEM1_REG_IN, EX_MEM1_REG_OUT);
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    ----------------------------------------- Connections ---------------------------------------------------------------------------------------------------------------------------------------------
    NOT_CLK <= NOT CLK;
    CF_WE_OR_OUT <= CF_WE OR SET_CLEAR(0);
    CF_VAL_OR_OUT <= CF_VALUE OR SET_CLEAR(1);
    --      ZF_OUT <= ZF_VALUE_OUT_TEMP;
    --     CF_OUT <= CF_VALUE_OUT_TEMP;
    --     NF_OUT <= NF_VALUE_OUT_TEMP;   

    EX_MEM1_REG_IN <= PC_PLUS_ONE & Write_back & MEM_SRC & SP_INC & SP_DEC & MEM_WRITE & Out_Signal & CALL_Signal & MEM_TO_REG & ALU_RESULT & RSRC2_Value & RSRC1_ADD & RSRC2_ADD & RDST_ADD;
    PC_PLUS_ONE_OUT <= EX_MEM1_REG_OUT(64 DOWNTO 49);
    Write_back_OUT <= EX_MEM1_REG_OUT(48);
    MEM_SRC_OUT <= EX_MEM1_REG_OUT(47);
    SP_INC_OUT <= EX_MEM1_REG_OUT(46);
    SP_DEC_OUT <= EX_MEM1_REG_OUT(45);
    MEM_WRITE_OUT <= EX_MEM1_REG_OUT(44);
    Out_Signal_OUT <= EX_MEM1_REG_OUT(43);
    CALL_Signal_OUT <= EX_MEM1_REG_OUT(42);
    MEM_TO_REG_OUT <= EX_MEM1_REG_OUT(41);
    Result_Value_OUT <= EX_MEM1_REG_OUT(40 DOWNTO 25);
    RSRC2_Value_OUT <= EX_MEM1_REG_OUT(24 DOWNTO 9);
    RSRC1_ADD_OUT <= EX_MEM1_REG_OUT(8 DOWNTO 6);
    RSRC2_ADD_OUT <= EX_MEM1_REG_OUT(5 DOWNTO 3);
    RDST_ADD_OUT <= EX_MEM1_REG_OUT(2 DOWNTO 0);

END ARCHITECTURE Execute_stage_arch;