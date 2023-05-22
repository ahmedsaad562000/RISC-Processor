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
        RDST_ADD_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

  ---------------------------------- Additional part of forwarding unit---------------------------------------------------------
        ALUData_Ex_Mem1,ALUData_Mem1_Mem2,ALUData_Mem2_Wb:IN STD_LOGIC_VECTOR(15 DOWNTO 0);  
        
        
        RegDst_Ex_Mem1,RegDst_Mem1_Mem2,RegDst_Mem2_Wb: IN STD_LOGIC_VECTOR(2 DOWNTO 0); 
        
        
        RegWr_Ex_Mem1,RegWr_Mem1_Mem2,RegWr_Mem2_Wb:IN STD_LOGIC ;
      
    -------------------------------------Additional part of Branching ---------------------------------------------------------
        Branch_Signal : IN STD_LOGIC;
        Branch_Value_OUT : OUT STD_LOGIC_VECTOR(15 downto 0);
        Branch_Signal_OUT : OUT STD_LOGIC;
        RET_FLAG_IN : IN STD_LOGIC;
        RET_FLAG_OUT : OUT STD_LOGIC

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
            cin :IN std_logic;
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
    Component Mux4 IS 
	Generic ( n : Integer:=10);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
    END Component Mux4;

Component ForwardingUnit IS
 generic (n: integer := 16);

 PORT (  RegDst_Ex_Mem1,RegDst_Mem1_Mem2,RegDst_Mem2_Wb,Rs,Rt: IN std_logic_vector(2 downto 0);
        RegWr_Ex_Mem1,RegWr_Mem1_Mem2,RegWr_Mem2_Wb: IN std_logic;
        S0,S1 :OUT std_logic_vector(1 downto 0)    

        );
END component ForwardingUnit;

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
    SIGNAL EX_MEM1_REG_IN : STD_LOGIC_VECTOR(65 DOWNTO 0);
    SIGNAL EX_MEM1_REG_OUT : STD_LOGIC_VECTOR(65 DOWNTO 0);
    SIGNAL CF_WE_OR_OUT : STD_LOGIC;
    SIGNAL CF_VAL_OR_OUT : STD_LOGIC;

    signal NOT_CLK : STD_LOGIC;

    -- SIGNAL ZF_VALUE_OUT_TEMP : STD_LOGIC;
    -- SIGNAL NF_VALUE_OUT_TEMP : STD_LOGIC;
    -- SIGNAL CF_VALUE_OUT_TEMP : STD_LOGIC;
    ---------------------------------Forwarding Selectors------------------------------------------------
    
    SIGNAL Forwarding_First_Selector  : STD_LOGIC_VECTOR(1 DOWNTO 0);
    
    SIGNAL Forwarding_Second_Selector  : STD_LOGIC_VECTOR(1 DOWNTO 0);
    
    ---------------------------------------------------------------------------------

    --------------------------------------MUX_4X1_Output-----------------------------------------------
    SIGNAL MUX4X1_First_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MUX4X1_Second_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

    ---------------------------------------------------------------------------------
    --------------------------------------Branching intermediate signals-------------------------------
     SIGNAL Branch_Signal_intermediate : STD_LOGIC;
    SIGNAL BRANCH_BUFF_IN : STD_LOGIC_VECTOR(16 DOWNTO 0);
    SIGNAL BRANCH_BUFF_OUT : STD_LOGIC_VECTOR(16 DOWNTO 0);
BEGIN
    ----------------------------------------- BOXES ---------------------------------------------------------------------------------------------------------------------------------------------------
    MUX_2X1_BOX : MUX_2X1 GENERIC MAP(16) PORT MAP(MUX4X1_Second_OUTPUT, IMM_OR_IN, ALU_SRC, MUX_OUTPUT);
    MUX_4X1_BOX_ALU_Input1: Mux4 GENERIC MAP(16) PORT MAP(RSRC1_Value, ALUData_Ex_Mem1,ALUData_Mem1_Mem2 ,ALUData_Mem2_Wb,Forwarding_First_Selector,MUX4X1_First_OUTPUT);
    MUX_4X1_BOX_ALU_Input2: Mux4 GENERIC MAP(16) PORT MAP(RSRC2_Value,ALUData_Ex_Mem1,ALUData_Mem1_Mem2,ALUData_Mem2_Wb,Forwarding_Second_Selector,MUX4X1_Second_OUTPUT );
    Forwarding_Unit: ForwardingUnit GENERIC MAP(16) PORT MAP(RegDst_Ex_Mem1,RegDst_Mem1_Mem2,RegDst_Mem2_Wb,RSRC1_ADD,RSRC2_ADD,RegWr_Ex_Mem1,RegWr_Mem1_Mem2,RegWr_Mem2_Wb,Forwarding_First_Selector,Forwarding_Second_Selector);

    ALU_BOX : Alu GENERIC MAP(16) PORT MAP(ALU_Operation,MUX4X1_First_OUTPUT , MUX_OUTPUT, CIN_Signal , CF_VALUE, ZF_VALUE, NF_VALUE, CF_WE, ZF_WE, NF_WE, ALU_RESULT);
    ZF_BOX : flag_reg PORT MAP(CLK ,ZF_WE, ZF_VALUE, RST, ZF_OUT);
    CF_BOX : flag_reg PORT MAP(CLK ,CF_WE_OR_OUT, CF_VAL_OR_OUT, RST, CF_OUT);
    NF_BOX : flag_reg PORT MAP(CLK ,NF_WE, NF_VALUE, RST, NF_OUT);

    EX_MEM1_REG : RegisterBuffer GENERIC MAP(66) PORT MAP(NOT_CLK, RST, EX_MEM1_REG_IN, EX_MEM1_REG_OUT);
    
    
    
    ---------------------------------------------------------------------------------
    BRANCH_DELAY_BUFFER : RegisterBuffer GENERIC MAP(17) PORT MAP(CLK, RST, BRANCH_BUFF_IN, BRANCH_BUFF_OUT);
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    ----------------------------------------- Connections ---------------------------------------------------------------------------------------------------------------------------------------------
    NOT_CLK <= NOT CLK;
    CF_WE_OR_OUT <= CF_WE OR SET_CLEAR(0);
    CF_VAL_OR_OUT <= CF_VALUE OR SET_CLEAR(1);
    --      ZF_OUT <= ZF_VALUE_OUT_TEMP;
    --     CF_OUT <= CF_VALUE_OUT_TEMP;
    --     NF_OUT <= NF_VALUE_OUT_TEMP;   
    -- Replaced rsrc2 value with output of mux
    EX_MEM1_REG_IN <= RET_FLAG_IN & PC_PLUS_ONE & Write_back & MEM_SRC & SP_INC & SP_DEC & MEM_WRITE & Out_Signal & CALL_Signal & MEM_TO_REG & ALU_RESULT & MUX4X1_Second_OUTPUT & RSRC1_ADD & RSRC2_ADD & RDST_ADD;
    RET_FLAG_OUT <= EX_MEM1_REG_OUT(65);
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
    
    
    
    
    
    
    BRANCH_BUFF_IN <= Branch_Signal_intermediate & ALU_RESULT;
    Branch_Value_OUT <= BRANCH_BUFF_OUT(15 downto 0);
    --Branch_Value_OUT <= MUX_OUTPUT;
    Branch_Signal_OUT <= BRANCH_BUFF_OUT(16);
    Branch_Signal_intermediate <= Branch_Signal or CALL_Signal;

END ARCHITECTURE Execute_stage_arch;