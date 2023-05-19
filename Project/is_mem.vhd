Library ieee;
Use ieee.std_logic_1164.all;

ENTITY is_mem IS
PORT (  CAT : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        OP : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        OUT_SIGNAL : OUT STD_LOGIC
);
END ENTITY is_mem;

ARCHITECTURE is_mem_arch OF is_mem IS
BEGIN
OUT_SIGNAL <= (not(CAT(1)) and CAT(0) and not(OP(3)) and OP(2)) or (CAT(1) and not(CAT(0)) and OP(3) and OP(2) and not(OP(1))) or (not(CAT(1)) and not(CAT(0)) and OP(3) and not(OP(2))) or (not(CAT(1)) and CAT(0) and OP(3) and OP(2));
END is_mem_arch;