
library IEEE;
use IEEE.std_logic_1164.all;

entity Nbit_adder is
generic(N : integer := 32);
  port(
       iA               : in std_logic_vector(N-1 downto 0);
       iB               : in std_logic_vector(N-1 downto 0);
       iC		: in std_logic;
 	oC		: out std_logic;
       oSum		: out std_logic_vector(N-1 downto 0));

end Nbit_adder;

architecture structure of Nbit_adder is

component FullAdder
    port(iA               : in std_logic;
       iB               : in std_logic;
       iC		: in std_logic;
       oC               : out std_logic;
       oSum		: out std_logic);
  end component;



 -- Signal
signal carry : std_logic_vector(N downto 0);


begin
carry(0) <= iC;


g_FA1: for i in 0 to N-1 generate
g_FA2: FullAdder
port MAP(
	iA	=> iA(i),
	iB	=> iB(i),
	iC	=> carry(i),
	oC	=> carry(i+1),
	oSum	=> oSum(i));

end generate g_FA1;

oC <= carry(N);

end structure;