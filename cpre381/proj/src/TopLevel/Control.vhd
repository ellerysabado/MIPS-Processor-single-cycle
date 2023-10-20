library IEEE;
use IEEE.std_logic_1164.all;

entity Control is

  port(i_Opcode : in std_logic_vector(5 downto 0);  --OpCode
       i_Function   : in std_logic_vector(5 downto 0);  --Function
       o_ALUSrc     : out std_logic;
       o_ALUControl : out std_logic_vector(3 downto 0);
       o_Mem2Reg    : out std_logic;
       o_MemWrite   : out std_logic;
       o_RegDst     : out std_logic;
       o_RegWrite   : out std_logic;                    
       o_Jump       : out std_logic;
       o_JumpLink   : out std_logic;
       o_JumpReg    : out std_logic;
       o_Branch     : out std_logic;
       o_ExtSelect  : out std_logic;
       o_MemRead    : out std_logic);

end Control;

architecture dataflow of Control is

--Signal s_Op_Func : std_logic_vector(11 downto 0);


begin
    process (i_Opcode, i_Function)
    begin
        -- Default values for outputs
        o_ALUSrc <= '0';
        o_ALUControl <= "0000";
        o_Mem2Reg <= '0';
        o_MemWrite <= '0';
        o_RegDst <= '0';
        o_RegWrite <= '0';
        o_Jump <= '0';
        o_JumpLink <= '0';
        o_JumpReg <= '0';
        o_Branch <= '0';
        o_ExtSelect <= '0';
	o_MemRead <= '0';

        -- R-Type instructions
        if i_Opcode = "000000" then
            case i_Function is
                when "100000" =>
                    -- R-type instruction: add
                    o_ALUControl <= "0000";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "100001" =>
                    -- R-type instruction: addu
                    o_ALUControl <= "0001";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "100100" =>
                    -- R-type instruction: and
                    o_ALUControl <= "0101";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "100111" =>
                    -- R-type instruction: nor
                    o_ALUControl <= "0110";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "100110" =>
                    -- R-type instruction: xor
                    o_ALUControl <= "0111";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "100101" =>
                    -- R-type instruction: or
                    o_ALUControl <= "1001";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "101010" =>
                    -- R-type instruction: slt
                    o_ALUControl <= "1010";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "000000" =>
                    -- R-type instruction: sll
                    o_ALUControl <= "0011";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "000010" =>
                    -- R-type instruction: srl
                    o_ALUControl <= "1000";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "000011" =>
                    -- R-type instruction: sra
                    o_ALUControl <= "1100";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "100010" =>
                    -- R-type instruction: sub
                    o_ALUControl <= "0010";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "100011" =>
                    -- R-type instruction: subu
                    o_ALUControl <= "0100";
                    o_RegDst <= '1';
                    o_RegWrite <= '1';

                when "001000" =>
                    -- R-type instruction: jr
                    o_ALUControl <= "----";
                    o_JumpReg <= '1';


                when others =>
                    -- Default case for R-type instruction
                    null;
            end case;

        -- I-Type instructions
        else
            case i_Opcode is
                when "001000" =>
                    -- I-type instruction: addi
                    o_ALUSrc <= '1';
                    o_ALUControl <= "0000";
                    o_Mem2Reg <= '0';
                    o_RegWrite <= '1';
                    o_ExtSelect <= '1';

                when "001001" =>
                    -- I-type instruction: addiu
                    o_ALUSrc <= '1';
                    o_ALUControl <= "0001";
                    o_Mem2Reg <= '0';
                    o_RegWrite <= '1';
                    o_ExtSelect <= '1';

                when "001100" =>
                    -- I-type instruction: andi
                    o_ALUSrc <= '1';
                    o_ALUControl <= "0101";
                    o_Mem2Reg <= '0';
                    o_RegWrite <= '1';
                    o_ExtSelect <= '1';

                when "001111" =>
                    -- I-type instruction: lui
                    o_ALUSrc <= '1';
                    o_ALUControl <= "1110";
                    o_Mem2Reg <= '0';
                    o_RegWrite <= '1';
                    o_ExtSelect <= '0';

                when "100011" =>
                    -- I-type instruction: lw
                    o_ALUSrc <= '1';
                    o_ALUControl <= "----";
                    o_Mem2Reg <= '1';
                    o_RegWrite <= '1';
		    o_MemRead <= '1';

                when "001110" =>
                    -- I-type instruction: xori
                    o_ALUSrc <= '1';
		    o_RegWrite <= '1';
                    o_ALUControl <= "0111";
                    o_MemWrite <= '0';
                    o_ExtSelect <= '0';

                when "001101" =>
                    -- I-type instruction: ori
                    o_ALUSrc <= '1';
                    o_ALUControl <= "1001";
                    o_Mem2Reg <= '0';
                    o_RegWrite <= '1';
                    o_ExtSelect <= '0';

                when "001010" =>
                    -- I-type instruction: slti
                    o_ALUSrc <= '1';
                    o_ALUControl <= "1010";
                    o_Mem2Reg <= '0';
                    o_RegWrite <= '1';
                    o_ExtSelect <= '1';

                when "101011" =>
                    -- I-type instruction: sw
                    o_ALUSrc <= '1';
                    o_ALUControl <= "----";
                    o_MemWrite <= '1';

                when "000100" =>
                    -- I-type instruction: beq
                    o_ALUControl <= "1011";
                    o_Branch <= '1';

                when "000101" =>
                    -- I-type instruction: bne
                    o_ALUControl <= "1101";
                    o_Branch <= '0';

                when "000010" =>
                    -- I-type instruction: j
                    o_ALUControl <= "----";
                    o_Jump <= '1';

                when "000011" =>
                    -- I-type instruction: jal
                    o_ALUControl <= "----";
                    o_RegWrite <= '1';
                    o_JumpLink <= '1';
                    o_JumpReg <= '1';

                when others =>
                    -- Default case for I-type instruction
                    null;
            end case;
        end if;
    end process;
end dataflow;
