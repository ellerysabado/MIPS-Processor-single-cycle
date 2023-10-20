library IEEE;
use IEEE.std_logic_1164.all;

entity MyAdder is 
    generic(N : integer := 32);
    port (i_in1: in std_logic_vector(N-1 downto 0);
	  i_in2: in std_logic_vector(N-1 downto 0);
          i_Cin: in std_logic;
          o_Sum: out std_logic_vector(N-1 downto 0);
          o_Cout: out std_logic);
end MyAdder;

architecture arch of MyAdder is 
--Sum = C xor (In1 xor In2)
--Cout = In1*In2 + C*(In1 xor In2)

component one_BitAdder is
    port (i_in1: in std_logic;
	  i_in2: in std_logic;
          i_Cin: in std_logic;
          o_Sum: out std_logic;
          o_Cout: out std_logic);
end component;

signal s_C: std_logic_vector(N downto 0);


begin
    
    s_C(0) <= i_Cin;
        
    RipAdder: for i in 0 to N-1 generate
        Adder: one_BitAdder port map(
            i_in1 => i_in1(i),
            i_in2 => i_in2(i),
            i_Cin => s_C(i),
            o_Sum => o_Sum(i),
            o_Cout => s_C(i+1));
    end generate RipAdder;

    o_Cout <= s_C(N);

    -- Last_iter: one_BitAdder port map(
	-- i_in1 => i_in1(N-1),
    --     i_in2 => i_in2(N-1),
    --     i_Cin => s_C(N-1),
    --     o_Sum => o_Sum(N-1),
    --     o_Cout => s_C(N));
    
end arch;