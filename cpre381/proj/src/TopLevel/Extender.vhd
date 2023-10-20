library ieee;
use ieee.std_logic_1164.all;



entity Extender is
	port 
	(
		i_data		: in std_logic_vector(15 downto 0);
		sel             : in std_logic;
		o_data	        : out std_logic_vector(31 downto 0)
	);

end Extender;

architecture Behavioral of Extender is
Signal s_d0 : std_logic_vector(1 downto 0);

begin
    s_d0 <= sel & i_data(15);
    with s_d0 select o_data <=
  	 "0000000000000000" & i_data when "00",
   	 "0000000000000000" & i_data when "01",
   	 "0000000000000000" & i_data when "10",
   	 "1111111111111111" & i_data when "11",
    "00000000000000000000000000000000" when others;


end Behavioral;
