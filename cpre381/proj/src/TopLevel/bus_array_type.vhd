library IEEE;
use IEEE.std_logic_1164.all;

package bus_array_type is
	type bus_array is array (31 downto 0)
		of std_logic_vector(31 downto 0);
end package bus_array_type; 