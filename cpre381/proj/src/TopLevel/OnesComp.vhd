library IEEE;
use IEEE.std_logic_1164.all;
--Mux 2:1--
entity OnesComp is
generic(N : integer := 32);
  port(
       i_One         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end OnesComp;

architecture structure of OnesComp is
  
  component invg
    port(i_A          : in std_logic;
       o_F          : out std_logic);
  end component;
begin 

G_One_C: for i in 0 to N-1 generate
G_One_Comp: invg
port Map(i_A		=>i_One(i),
	o_F		=>o_O(i));
end generate G_One_C;

end structure;
