Library ieee;
Use ieee.std_logic_1164.all;

ENTITY Logicpart IS
 generic (n: integer := 16);
PORT (  sel: IN std_logic_vector(1 downto 0);
        inpA,inpB: IN std_logic_vector(n-1 downto 0);
        cout :OUT std_logic;    
        OUT1 : OUT std_logic_vector(n-1 downto 0);
        cin :IN std_logic 
);
END ENTITY Logicpart;

ARCHITECTURE Logicpartimp OF Logicpart IS
BEGIN
    OUT1 <= inpA  WHEN sel(1) = '0' AND sel(0) ='0' AND cin='0'
    Else inpB   WHEN sel(1)='0' AND sel(0)='0' AND cin='1'
    ELSE not inpA  WHEN sel(1) = '0' AND sel(0) ='1'
    ELSE inpA and inpB  WHEN sel(1) = '1' AND sel(0) ='0'
    ELSE inpA or inpB;
    cout <= '0';
END Logicpartimp;