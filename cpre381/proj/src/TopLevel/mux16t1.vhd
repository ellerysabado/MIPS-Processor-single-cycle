library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.MIPS_types.all;


entity mux16to1 is
    Port (
        i_S : in STD_LOGIC_VECTOR(3 downto 0); -- 4 select lines
        i_D : in Arr_six; -- 16 input lines
        o_O : out std_logic_vector(31 downto 0)
    );
end mux16to1;

architecture Dataflow of mux16to1 is
    begin
        o_O <= i_D(to_integer(unsigned(i_S)));
    end Dataflow;
