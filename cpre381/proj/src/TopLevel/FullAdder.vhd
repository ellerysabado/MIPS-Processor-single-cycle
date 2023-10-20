
library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is

  port(
       iA               : in std_logic;
       iB               : in std_logic;
       iC		: in std_logic;
       oC               : out std_logic;
       oSum		: out std_logic);

end FullAdder;

architecture structure of FullAdder is

component invg
    port(i_A          : in std_logic;
       o_F          : out std_logic);
  end component;

  component andg2
    port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component org2
    port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component xorg2
    port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

 -- Signal
  signal s_Xor       : std_logic;
  signal s_And1, s_And2: std_logic;


begin

g_Not1: xorg2
port Map(i_A		=>iA,
	i_B		=>iB,
	o_F		=>s_Xor);

g_And1: andg2
port Map(i_A		=>iA,
	i_B		=>iB,
	o_F		=>s_And1);

g_xor2: xorg2
port Map(i_A		=>s_Xor,
	i_B		=>iC,
	o_F		=>oSum);

g_And2: andg2
port Map(i_A		=>s_Xor,
	i_B		=>iC,
	o_F		=>s_And2);

g_Or1: org2
port Map(i_A		=>s_And2,
	i_B		=>s_And1,
	o_F		=>oC);




end structure;
