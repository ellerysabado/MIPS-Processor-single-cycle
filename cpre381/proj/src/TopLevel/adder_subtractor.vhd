library IEEE;
use IEEE.std_logic_1164.all;

entity adder_subtractor is 
    generic(N : integer := 32);
    port (i_iput1: in std_logic_vector(N-1 downto 0);
	    i_iput2: in std_logic_vector(N-1 downto 0);
          i_C: in std_logic;
          o_ASum: out std_logic_vector(N-1 downto 0);
          o_ASC: out std_logic);
end adder_subtractor;

architecture arch of adder_subtractor is 

component N_OnesComp is
    port (i_oneIn : in std_logic_vector(N-1 downto 0);
    o_oneOut : out std_logic_vector(N-1 downto 0));
end component;


component mux2t1_N is
    port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

component MyAdder is
    port (i_in1: in std_logic_vector(N-1 downto 0);
	  i_in2: in std_logic_vector(N-1 downto 0);
          i_Cin: in std_logic;
          o_Sum: out std_logic_vector(N-1 downto 0);
          o_Cout: out std_logic);
end component;

signal s_oneOut : std_logic_vector(N-1 downto 0);
signal s_muxOut : std_logic_vector(N-1 downto 0);


begin
    mux1: mux2t1_N port map (
        i_S => i_C,     
        i_D0 => i_iput2,
        i_D1 => s_oneOut,      
        o_O =>  s_muxOut);

    ones: N_OnesComp port map(
        i_oneIn => i_iput2,
        o_oneOut => s_oneOut);

    adder: MyAdder port map(
        i_in1 => i_iput1,
	    i_in2 => s_muxOut,
        i_Cin => i_C,
        o_Sum => o_ASum,
        o_Cout => o_ASC);
end arch;