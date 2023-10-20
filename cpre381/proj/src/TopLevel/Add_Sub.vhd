
library IEEE;
use IEEE.std_logic_1164.all;

entity Add_Sub is
generic(N : integer := 32);
  port(
       iA               : in std_logic_vector(N-1 downto 0);
       iB               : in std_logic_vector(N-1 downto 0);
       i_S		: in std_logic;
	oC		: out std_logic;
       oSum		: out std_logic_vector(N-1 downto 0));

end Add_Sub;

architecture structure of Add_Sub is

component Nbit_Adder
    port(iA               : in std_logic_vector(N-1 downto 0);
       iB               : in std_logic_vector(N-1 downto 0);
       iC		: in std_logic;
       oC               : out std_logic;
       oSum		: out std_logic_vector(N-1 downto 0));
  end component;

component OnesComp 
  port(
       i_One         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

component mux2t1_N
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

 -- Signal
signal s_mux : std_logic_vector(N-1 downto 0);
signal o_comp: std_logic_vector(N-1 downto 0);

begin


g_ones_comp: OnesComp
 port Map(
       i_One        => iB,
       o_O         => o_comp);



MUX1: mux2t1_N
port Map(
	i_S	=> i_S,
	i_D0	=> iB,
	i_D1	=> o_comp,
	o_O	=> s_mux);




g_Add_Sub: Nbit_adder
port Map(
	iA	=> iA,
	iB	=> s_mux,
	iC	=> i_S,
	oC	=> oC,
	oSum	=> oSum);


end structure;