LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Controlller IS
    PORT (
        CAT : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        OP : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        FLAGS : IN STD_LOGIC_VECTOR (2 DOWNTO 0);

        OUT_SIGNALS : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
    );
END Controlller;


ARCHITECTURE Controlller_arch of Controlller is 
BEGIN
--ISMEM

OUT_SIGNALS (19) <= (not(CAT(1)) and CAT(0) and not(OP(3)) and OP(2)) or (CAT(1) and not(CAT(0)) and OP(3) and OP(2) and not(OP(1))) or (not(CAT(1)) and not(CAT(0)) and OP(3) and not(OP(2))) or (not(CAT(1)) and CAT(0) and OP(3) and OP(2));

--------------------------------------
--USE_IMM

OUT_SIGNALS (18) <= CAT(1) and OP(1);

--------------------------------------
--IS_IN

OUT_SIGNALS (17) <= not(CAT(1)) and CAT(0) and OP(4) and OP(2);

--------------------------------------
--IS_RET/RTI

OUT_SIGNALS (16) <= not(CAT(1)) and not(CAT(0)) and OP(3);

--------------------------------------
--SET

OUT_SIGNALS (15) <= not(CAT(1)) and not(CAT(0)) and not(OP(3)) and OP(2) and not(OP(4)) ;

--------------------------------------
--CLEAR

OUT_SIGNALS (14) <= not(CAT(1)) and not(CAT(0)) and not(OP(3)) and OP(2) and OP(4);

--------------------------------------
--JMP_FLAG

OUT_SIGNALS (13) <= (not(CAT(1)) and CAT(0) and OP(3) and not(OP(2))) and  (( OP(1) or FLAGS(1)) and (OP(0) or FLAGS(2))) ;

--------------------------------------
--WB

OUT_SIGNALS (12) <= (CAT(1) and CAT(0)) or (CAT(1) and not(CAT(0)) and not(OP(4)) and OP(3) and OP(2)) or (OP(3) nand OP(2)) or (not(CAT(1)) and CAT(0) and OP(4) and OP(2));

--------------------------------------
--MEM_SRC

OUT_SIGNALS (11) <= (not(CAT(1)) and CAT(0) and not(OP(3)) and OP(2)) or (not(CAT(1)) and not(CAT(0)) and OP(3) and not(OP(2)))or (not(CAT(1)) and CAT(0) and OP(3) and OP(2));

--------------------------------------
--SP_INC

OUT_SIGNALS (10) <= (not(CAT(1)) and not(CAT(0)) and OP(3)) or (not(CAT(1)) and CAT(0) and OP(4) and OP(2));

--------------------------------------
--SP_DEC

OUT_SIGNALS (9) <= not(CAT(1)) and CAT(0) and not(OP(4)) and OP(2) and not(OP(3));

--------------------------------------
--MEM_WRITE

OUT_SIGNALS (8) <= (not(CAT(1)) and CAT(0) and OP(3) and OP(2)) or (CAT(1) and not(CAT(0)) and OP(3) and OP(2) and not(OP(1)) and OP(4)) or (not(CAT(1)) and CAT(0) and not(OP(4)) and OP(2) and not(OP(3)));

--------------------------------------
--OUT_SIGNAL

OUT_SIGNALS (7) <= not(CAT(1)) and CAT(0) and not(OP(4)) and not(OP(2)) and not(OP(3));

--------------------------------------
--ALU_SRC

OUT_SIGNALS (6) <= CAT(1) and OP(1) and  not(CAT(1)) and CAT(0) and OP(4) and not(OP(2));

--------------------------------------
--ALU_OP
OUT_SIGNALS (5 DOWNTO 3) <= "000" when CAT(1)= '1' and CAT(0)= '1' and not(OP(3))= '1' and not(OP(2))= '1'  --ADD
else "001" when CAT(1)= '1' and not(CAT(0))= '1' and not(OP(4))= '1' and OP(3)= '1' and not(OP(2)) = '1' --INC
else "010" when CAT(1)= '1' and not(CAT(0))= '1' and OP(4)= '1' and OP(3)= '1' and not(OP(2)) = '1' --DEC
else "011" when CAT(1)= '1' and CAT(0)= '1' and not(OP(3))= '1' and OP(2) = '1' --SUB
else "100" when CAT(1)= '1' and not(CAT(0))= '1' and not(OP(3))= '1' and not(OP(2)) = '1' --MOV
else "101" when CAT(1)= '1' and not(CAT(0))= '1' and not(OP(3))= '1' and OP(2)= '1' --NOT
else "110" when CAT(1)= '1' and CAT(0)= '1' and OP(3)= '1' and not(OP(2))= '1'  --AND
else "111"; --OR
--------------------------------------
--CIN

OUT_SIGNALS (2) <= CAT(1) and not(CAT(0)) and OP(1);

--------------------------------------
--CALL

OUT_SIGNALS (1) <= (not(CAT(1)) and CAT(0) and OP(3) and OP(2));

--------------------------------------
--MEM_TO_REG

OUT_SIGNALS (0) <= (not(CAT(1)) and CAT(0) and OP(4) and OP(2)) or (CAT(1) and not(CAT(0)) and OP(3) and OP(2) and not(OP(1)) and not(OP(4)));


END Controlller_arch ;