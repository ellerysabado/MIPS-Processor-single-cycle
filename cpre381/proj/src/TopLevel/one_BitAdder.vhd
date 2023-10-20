library IEEE;
use IEEE.std_logic_1164.all;

entity one_BitAdder is 
    port (i_in1: in std_logic;
	      i_in2: in std_logic;
          i_Cin: in std_logic;
          o_Sum: out std_logic;
          o_Cout: out std_logic);
end one_BitAdder;

architecture arch of one_BitAdder is 
--Sum = C xor (In1 xor In2)
--Cout = In1*In2 + C*(In1 xor In2)

component andg2 is
    port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2 is 
    port(i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic);

end component;

component xorg2 is

    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  
  end component;

signal s_xor1 : std_logic;
signal s_and1 : std_logic;
signal s_and2 : std_logic;

begin
    Xor1: xorg2 port map(
        i_A => i_in1,
        i_B => i_in2,
        o_F => s_xor1);


    Xor2: xorg2 port map(
        i_A => s_xor1,
        i_B => i_Cin,
        o_F => o_Sum);
    
    And1 : andg2 port map(
        i_A => i_in1,
        i_B => i_in2,
        o_F => s_and1);

    And2 : andg2 port map(
        i_A => s_xor1,
        i_B => i_Cin,
        o_F => s_and2);

    Or1 : org2 port map(
        i_A => s_and1,
        i_B => s_and2,
        o_F => o_Cout);

    
end arch;