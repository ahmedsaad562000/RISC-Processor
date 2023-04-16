Library ieee;
Use ieee.std_logic_1164.all;

ENTITY uses_imm IS
PORT (  CAT : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        OP : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        OUT_SIGNAL : OUT STD_LOGIC
);
END ENTITY uses_imm;

ARCHITECTURE Logicpartimp OF uses_imm IS
BEGIN
OUT_SIGNAL <= CAT(1) and OP(1);
END Logicpartimp;