LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY nbitAnd IS
GENERIC (N : INTEGER := 32);
    PORT (
        in1 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        in2 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        o_O : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );

END nbitAnd;

ARCHITECTURE arch OF nbitAnd IS
component andg2 is
    port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

BEGIN
G_NBit_AND: for i in 0 to N-1 generate
MUXI: andg2 port map(      -- All instances share the same select input.
          i_A     => in1(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
          i_B     => in2(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
          o_F      => o_O(i));  -- ith instance's data output hooked up to ith data output.
end generate G_NBit_AND;
END arch; -- arch of extender is