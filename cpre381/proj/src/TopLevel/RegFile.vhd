-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.MIPS_types.all;

entity RegFile is
generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_RS          : in std_logic_vector(4 downto 0);     
       i_RT          : in std_logic_vector(4 downto 0); 
       i_RD          : in std_logic_vector(4 downto 0);    
       o_Q          : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_O          : out std_logic_vector(N-1 downto 0));
end RegFile;

architecture mixed of RegFile is

component Register_N
port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end component;

component Mux32t1
    port(
        S : in STD_LOGIC_VECTOR(4 downto 0); -- 5-bit selection input
        D : in bus_array; -- 32 data inputs
        Y : out STD_LOGIC_VECTOR(N-1 downto 0));
end component;

component Decoder_5to32
    port (
        A : in STD_LOGIC_VECTOR(4 downto 0); -- 5 input lines
	EN: in std_logic;
        Y : out STD_LOGIC_VECTOR(N-1 downto 0) -- 32 output lines
    );
end component;



  signal s_Decoder    : std_logic_vector(N-1 downto 0);    -- Multiplexed input to the FF
  signal s_Reg    : std_logic_vector(N-1 downto 0);    -- Output of the FF
 signal s_Bus    : bus_array; 
begin



g_Decoder: Decoder_5to32
Port Map(
	A	=> i_RD,
	EN	=> i_WE,
	Y	=> s_Decoder);


g_RegFile0: Register_N
Port Map(i_CLK		=>i_CLK,
i_RST		=>i_RST,
i_WE		=>'0',
i_D		=>i_D,
o_Q		=>s_Bus(0));


g_RegFile1: for i in 1 to N-1 generate
g_RegFile: Register_N
port Map(i_CLK		=>i_CLK,
	i_RST		=>i_RST,
	i_WE		=>s_Decoder(i),
	i_D		=>i_D,
	o_Q		=>s_Bus(i));

  end generate g_RegFile1;


g_Mux0: Mux32t1
port Map(S	=> i_RS,
	D	=> s_Bus,
	Y	=> o_Q);


g_Mux1: Mux32t1
port Map(S	=> i_RT,
	D	=> s_Bus,
	Y	=> o_O);


  
end mixed;
