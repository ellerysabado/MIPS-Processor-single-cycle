library IEEE;
use IEEE.std_logic_1164.all;
--use work.bus_array_type.all;

entity FetchComponent is
  generic(N : integer := 32;
	  I : integer := 26); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;     -- Clock input
       i_jAddr      : in std_logic_vector(I-1 downto 0);     -- Reset input
       i_PC         : in std_logic_vector(N-1 downto 0);     -- Write enable input
       i_branchAddr : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_branchEN   : in std_logic;     
       i_jumpEN     : in std_logic; 
       i_jrAddr     : in std_logic_vector(N-1 downto 0); 
       i_jrEN	    : in std_logic;
       i_jumplink   : in std_logic;
       o_pcOut      : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_pcAddFour  : out std_logic_vector(N-1 downto 0));

end FetchComponent;

architecture structural of FetchComponent is
type bus_array is array (31 downto 0)
		of std_logic_vector(31 downto 0);
  component mux2t1_N is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic_vector(N-1 downto 0);
         i_D1                 : in std_logic_vector(N-1 downto 0);
         o_O                  : out std_logic_vector(N-1 downto 0));
  end component;

component Add_Sub
  port(
       iA               : in std_logic_vector(N-1 downto 0);
       iB               : in std_logic_vector(N-1 downto 0);
       i_S		: in std_logic;
       oC		: out std_logic;
       oSum		: out std_logic_vector(N-1 downto 0));

end component;


signal s_carry1, s_carry2 : std_logic;
signal s_pcAddFour, s_jumpMux, s_branchMux, s_pcAddBranch, s_finalJAdder, s_shiftBranchAddr, s_JL : std_logic_vector(N-1 downto 0);


begin

-- pc + 4
g_PCAdder0: Add_Sub 
port map(
	iA	=> i_PC,
	iB	=> x"00000004",
	i_S	=> '0',
	oC	=> s_carry1,
	oSum	=> s_pcAddFour);

o_pcAddFour <= s_pcAddFour;

--pc + branch adder
s_shiftBranchAddr <= i_branchAddr(29 downto 0) & "00";

g_PCAdder1: Add_Sub 
port map(
	iA	=> s_pcAddFour,
	iB	=> s_shiftBranchAddr,
	i_S	=> '0',
	oC	=> s_carry2,
	oSum	=> s_pcAddBranch);

-- branch mux or pc+4
g_branchMUX: mux2t1_N 
port map (
    i_S  => i_branchEN,
    i_D0 => s_pcAddFour,      
    i_D1 => s_pcAddBranch,     
    o_O  => s_branchMux);

--shift for jump
s_finalJAdder <= s_pcAddFour(N-1 downto 28) & i_jAddr & "00";

-- If jump or not 
g_jumpMUX: mux2t1_N 
port map (
    i_S  => i_jumpEN,
    i_D0 => s_branchMux,      
    i_D1 => s_finalJAdder,     
    o_O  => s_jumpMux);

--s_finalJAdder <= o_pcOut;

g_jumplink: mux2t1_N 
port map (
    i_S  => i_jumplink,
    i_D0 => s_jumpMux,      
    i_D1 => s_finalJAdder,     
    o_O  => s_JL);


--jump register 
g_jumpRegMux: mux2t1_N 
port map (
    i_S  => i_jrEN,
    i_D0 => i_jrAddr,      
    i_D1 => s_JL,     
    o_O  => o_pcOut);



end structural;












