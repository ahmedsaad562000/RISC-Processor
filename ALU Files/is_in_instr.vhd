Library ieee;
Use ieee.std_logic_1164.all;

ENTITY is_in_inst IS
PORT (  CAT : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        OP : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        OUT_SIGNAL : OUT STD_LOGIC
);
END ENTITY is_in_inst;

ARCHITECTURE Logicpartimp OF uses_imm IS
BEGIN
OUT_SIGNAL <= not(CAT(1)) and CAT(0) and OP(4) and OP(2);
END Logicpartimp;