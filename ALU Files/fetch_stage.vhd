LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fetch_stage IS
    PORT (
        CLK : IN STD_LOGIC;
        JMP_FLAG : IN STD_LOGIC;
        JMP_VALUE : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OP_CODE_DECODE_OUT : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        CAT_DECODE_OUT : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_PLUS_ONE_FETCH_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        OP_CODE_OUT : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        CAT_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        IMM_OR_IN : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        RDST_ADD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        RSRC1_ADD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        RSRC2_ADD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END fetch_stage;

ARCHITECTURE fetch_stage_arch OF fetch_stage IS
    ------------------------------------PC_LOGIC---------------------------------------
    COMPONENT PC IS
        PORT (
            clk, rst, enable, sel1, sel2, sel3 : IN STD_LOGIC;
            jmp_value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            pc_val : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
            pc_plus_one : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
        );
    END COMPONENT;

    ------------------------------------IS_MEM---------------------------------------
    COMPONENT is_mem IS
        PORT (
            CAT : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            OP : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
            OUT_SIGNAL : OUT STD_LOGIC
        );
    END COMPONENT is_mem;

    ------------------------------------USES_MEM---------------------------------------

    COMPONENT uses_imm IS
        PORT (
            CAT : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            OP : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
            OUT_SIGNAL : OUT STD_LOGIC
        );
    END COMPONENT uses_imm;

    ------------------------------------IS_IN---------------------------------------

    COMPONENT is_in_inst IS
        PORT (
            CAT : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            OP : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
            OUT_SIGNAL : OUT STD_LOGIC
        );
    END COMPONENT is_in_inst;

    ------------------------------------INST_CACHE---------------------------------------

    COMPONENT inst_cache IS
        PORT (
            address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            M0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            M1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT inst_cache;
    ------------------------------------MUX_2X1---------------------------------------

    COMPONENT MUX_2X1 IS
        GENERIC (N : INTEGER := 16);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Sel : IN STD_LOGIC;
            Output : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT MUX_2X1;

    ---------------------------------------------------------------------------------

    COMPONENT RegisterBuffer IS
        GENERIC (N : INTEGER := 16);
        PORT (
            CLK, RST : IN STD_LOGIC;
            D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT RegisterBuffer;

    --------------------------------SIGNALS------------------------------------------
    SIGNAL PC_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL PC_PLUS_ONE : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL INST_CACHE_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL M0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL M1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL IS_MEM1_OUT : STD_LOGIC;
    SIGNAL IS_MEM2_OUT : STD_LOGIC;
    SIGNAL USE_IMM_OUT : STD_LOGIC;
    SIGNAL AND_OUT : STD_LOGIC;
    SIGNAL OR_OUT : STD_LOGIC;
    SIGNAL IS_IN_OUT : STD_LOGIC;
    SIGNAL MUX1_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL NOT_CLK : STD_LOGIC;
    SIGNAL FETCH_REG_IN : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL FETCH_REG_OUT : STD_LOGIC_VECTOR(47 DOWNTO 0);

    ---------------------------------------------------------------------------------

BEGIN
    PC_BOX : PC PORT MAP(CLK, '0', '1', USE_IMM_OUT, JMP_FLAG, OR_OUT, JMP_VALUE, PC_OUT, PC_PLUS_ONE);
    INST_CACHE_BOX : inst_cache PORT MAP(PC_OUT, INST_CACHE_OUT, M0, M1);
    IS_MEM1_BOX : is_mem PORT MAP(CAT_DECODE_OUT, OP_CODE_DECODE_OUT, IS_MEM1_OUT);
    IS_MEM2_BOX : is_mem PORT MAP(INST_CACHE_OUT(31 DOWNTO 30), INST_CACHE_OUT(20 DOWNTO 16), IS_MEM2_OUT);
    USE_IMM_BOX : uses_imm PORT MAP(INST_CACHE_OUT(31 DOWNTO 30), INST_CACHE_OUT(20 DOWNTO 16), USE_IMM_OUT);
    IS_IN_BOX : is_in_inst PORT MAP(INST_CACHE_OUT(31 DOWNTO 30), INST_CACHE_OUT(20 DOWNTO 16), IS_IN_OUT);
    MUX1 : MUX_2X1 GENERIC MAP(16) PORT MAP(INST_CACHE_OUT(15 DOWNTO 0), IN_PORT, IS_IN_OUT, MUX1_OUTPUT);
    FETCH_REG : RegisterBuffer GENERIC MAP(49) PORT MAP(NOT_CLK, OR_OUT, FETCH_REG_IN, FETCH_REG_OUT);
    ---------------------------------------OUTPUTS------------------------------------
    PC_PLUS_ONE_FETCH_OUT <= FETCH_REG_OUT(47 DOWNTO 32);
    CAT_OUT <= FETCH_REG_OUT(31 DOWNTO 30);
    RDST_ADD <= FETCH_REG_OUT(29 DOWNTO 27);
    RSRC1_ADD <= FETCH_REG_OUT(26 DOWNTO 24);
    RSRC2_ADD <= FETCH_REG_OUT(23 DOWNTO 21);
    OP_CODE_OUT <= FETCH_REG_OUT(20 DOWNTO 16);
    IMM_OR_IN <= FETCH_REG_OUT(15 DOWNTO 0);
    ---------------------------------------LOGIC--------------------------------------
    AND_OUT <= IS_MEM1_OUT AND IS_MEM2_OUT;
    OR_OUT <= JMP_FLAG OR AND_OUT;
    FETCH_REG_IN <= PC_PLUS_ONE & INST_CACHE_OUT(31 DOWNTO 16) & MUX1_OUTPUT;
    NOT_CLK <= NOT CLK;

END ARCHITECTURE fetch_stage_arch;