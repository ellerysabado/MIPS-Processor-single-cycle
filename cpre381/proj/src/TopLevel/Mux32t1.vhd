library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
--use work.bus_array_type.all;
use work.MIPS_types.all;
entity Mux32t1 is

    Port (
        S : in STD_LOGIC_VECTOR(4 downto 0); -- 5-bit selection input
        D : in bus_array; -- 32 data inputs
        Y : out STD_LOGIC_VECTOR(31 downto 0));
end Mux32t1;

architecture Dataflow of Mux32t1 is
begin

    Y <= D(to_integer(unsigned(S)));

end Dataflow;
