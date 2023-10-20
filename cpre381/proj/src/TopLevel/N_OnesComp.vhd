library IEEE;
use IEEE.std_logic_1164.all;

entity N_OnesComp is
    generic(N : integer := 32); 
    port (i_oneIn : in std_logic_vector(N-1 downto 0);
          o_oneOut : out std_logic_vector(N-1 downto 0));
end N_OnesComp;

architecture structural of N_OnesComp is 

    component invg is
        port(i_A                  : in std_logic;
            o_F                  : out std_logic);
    end component;
begin
    NBit_Ones: for i in 0 to N-1 generate
        Ones: invg port map(
            i_A => i_oneIn(i),
            o_F => o_oneOut(i));
        
    end generate NBit_Ones;


end structural;