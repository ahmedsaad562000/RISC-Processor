Library ieee;
Use ieee.std_logic_1164.all;

ENTITY ForwardingUnit IS
 generic (n: integer := 16);
PORT (  RegDst_Ex_Mem1,RegDst_Mem1_Mem2,RegDst_Mem2_Wb,Rs,Rt: IN std_logic_vector(2 downto 0);
        RegWr_Ex_Mem1,RegWr_Mem1_Mem2,RegWr_Mem2_Wb: IN std_logic;
        S0,S1 :OUT std_logic_vector(1 downto 0)    
);
END ENTITY ForwardingUnit;

ARCHITECTURE ForwardingUnitImp OF ForwardingUnit IS
BEGIN

S0<= "01" WHEN Rs=RegDst_Ex_Mem1 AND RegWr_Ex_Mem1='1'
ELSE "10" WHEN Rs=RegDst_Mem1_Mem2 AND RegWr_Mem1_Mem2='1'
ELSE "11" WHEN Rs=RegDst_Mem2_Wb AND RegWr_Mem2_Wb='1'
Else "00";

S1<= "01" WHEN Rt=RegDst_Ex_Mem1 AND RegWr_Ex_Mem1='1'
ELSE "10" WHEN Rt=RegDst_Mem1_Mem2 AND RegWr_Mem1_Mem2='1'
ELSE "11" WHEN Rt=RegDst_Mem2_Wb AND RegWr_Mem2_Wb='1'
Else "00";

END ForwardingUnitImp;

-- the code is like the design .....