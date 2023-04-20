Library ieee;
Use ieee.std_logic_1164.all;

ENTITY is_in_inst IS
PORT (  CAT : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        OP : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        OUT_SIGNAL : OUT STD_LOGIC
);
END ENTITY is_in_inst;

ARCHITECTURE is_in_inst_arch OF is_in_inst IS
BEGIN
OUT_SIGNAL <= NOT(CAT(1)) AND CAT(0) AND OP(4) AND NOT(OP(3)) AND NOT(OP(2));
END is_in_inst_arch;