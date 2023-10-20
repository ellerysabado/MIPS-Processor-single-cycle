library IEEE;
use IEEE.std_logic_1164.all;


entity mux2t1 is

  port(i_S          : in std_logic;
       i_D0         : in std_logic;
       i_D1         : in std_logic;
       o_O          : out std_logic);

end mux2t1;

architecture structure of mux2t1 is
  
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
 


  -- Signal to carry stored weight
  signal s_Not         : std_logic;
  -- Signals to carry delayed X
  signal s_And1, s_And2   : std_logic;


begin

g_And2: andg2
    port MAP(i_A               => i_D1,
             i_B              => i_S,
             o_F               => s_And2);

g_Not: invg
port MAP(i_A			=>i_S,
	o_F			=>s_Not);


	
g_And1: andg2
    port MAP(i_A               => i_D0,
             i_B              => s_Not,
             o_F               => s_And1);

g_Or1: org2
    port MAP(i_A               => s_And1,
             i_B              => s_And2,
             o_F               => o_O);

  end structure;