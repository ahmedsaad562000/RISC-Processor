Library ieee;
Use ieee.std_logic_1164.all;

ENTITY LoadDetection IS

PORT (  Dec_Exec_MemRead,Exec_Mem1_MemRead: IN std_logic;
        Dec_Exec_Rt,Exec_Mem1_Rt,Fet_Dec_Rs,Fet_Dec_Rt: IN std_logic_vector(2 downto 0);   
        OUT1 : OUT std_logic
);
END ENTITY LoadDetection;

ARCHITECTURE LoadDetection_arch OF LoadDetection IS
BEGIN
 --OUT1 <= '0' when (Fet_Dec_Rs = "UUU" OR Fet_Dec_Rt ="UUU" ) 
 --ELSE 
 OUT1 <= '1' WHEN ((Dec_Exec_MemRead='1'and((Dec_Exec_Rt=Fet_Dec_Rs) or (Dec_Exec_Rt=Fet_Dec_Rt))))
 ELSE '1' wHEN ((Exec_Mem1_MemRead='1'and((Exec_Mem1_Rt=Fet_Dec_Rs) or (Exec_Mem1_Rt=Fet_Dec_Rt))))
 Else '0';
END LoadDetection_arch;
-- if out =0 no change if out=1 all output of controller =0 , PC nochange same value , Fetch register disable Writeenable
