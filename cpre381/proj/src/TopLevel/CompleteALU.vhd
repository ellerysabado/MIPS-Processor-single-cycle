LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.MIPS_types.all;

ENTITY CompleteALU IS
    GENERIC (N : INTEGER := 32);
    PORT (
        i_iput1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        i_iput2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
	i_shamt : in STD_LOGIC_VECTOR(4 DOWNTO 0); 
        alucontrol : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        ALUSrc : IN STD_LOGIC;
        o_ASum : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        o_ZERO : OUT STD_LOGIC;
        o_over : OUT STD_LOGIC);

END CompleteALU;

ARCHITECTURE arch OF CompleteALU IS

    COMPONENT nXor IS
        PORT (
            in1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            in2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            o_O : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT nbitAnd IS
        PORT (
            in1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            in2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            o_O : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT nbitOr IS
        PORT (
            in1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            in2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            o_O : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT nbitNor IS
        PORT (
            in1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            in2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            o_O : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT newBarrelShifter IS
        PORT (
            i_S : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            i_D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            shiftsel : IN STD_LOGIC;
            logOrAr : IN STD_LOGIC;
            o_O : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT adder_subtractor IS
        PORT (
            i_iput1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            i_iput2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            i_C : IN STD_LOGIC;
            o_ASum : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            o_ASC : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT mux16to1 IS
	PORT (
        	i_S : in STD_LOGIC_VECTOR(3 downto 0); -- 4 select lines
        	i_D : in Arr_six; -- 16 input lines
        	o_O : out std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	   

    SIGNAL andToMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL xorToMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL orToMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL norToMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL barToMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL addSubToMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL beqToMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL bneToMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL sltToMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL sltbeforeMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL carryOut1 : STD_LOGIC;
    SIGNAL carryOut2 : STD_LOGIC;
    SIGNAL carryOut3 : STD_LOGIC;
    SIGNAL carryOut4 : STD_LOGIC;
    SIGNAL zeroCal : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL luiToMux : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL aluSig : STD_LOGIC;
    SIGNAL overflow : STD_LOGIC_VECTOR(N DOWNTO 0);

BEGIN
    ANDG : nbitAnd PORT MAP(
        in1 => i_iput1,
        in2 => i_iput2,
        o_O => andToMux
    );

    XORG : nXor PORT MAP(
        in1 => i_iput1,
        in2 => i_iput2,
        o_O => xorToMux
    );

    ORG : nbitOr PORT MAP(
        in1 => i_iput1,
        in2 => i_iput2,
        o_O => orToMux
    );

    NORG : nbitNor PORT MAP(
        in1 => i_iput1,
        in2 => i_iput2,
        o_O => norToMux
    );

    NBSG : newBarrelShifter PORT MAP(
        i_S => i_shamt,
        i_D => i_iput2,
        shiftsel => alucontrol(3),
        logOrAr => alucontrol(2),
        o_O => barToMux
    );

    lui : newBarrelShifter PORT MAP(
	i_S => "10000",
        i_D => i_iput2,
        shiftsel => '0',
        logOrAr => '0',
        o_O => luiToMux
    );


    WITH alucontrol SELECT aluSig <=
    '0' WHEN "0000",
    '0' WHEN "0001",
    '1' WHEN "0010",
    '1' WHEN "0100",
    '0' WHEN OTHERS;

    adderSub : adder_subtractor PORT MAP(
    i_iput1 => i_iput1,
    i_iput2 => i_iput2,
    i_C => aluSig,
    o_ASum => addSubToMux,
    o_ASC => carryOut1
    );

    BNE : adder_subtractor PORT MAP(
        i_iput1 => i_iput1,
        i_iput2 => i_iput2,
        i_C => '1',
        o_ASum => bneToMux,
        o_ASC => carryOut2
    );

    BEQ : adder_subtractor PORT MAP(
        i_iput1 => i_iput1,
        i_iput2 => i_iput2,
        i_C => '1',
        o_ASum => beqToMux,
        o_ASC => carryOut3
    );

    slt : adder_subtractor PORT MAP(
        i_iput1 => i_iput1,
        i_iput2 => i_iput2,
        i_C => '1',
        o_ASum => sltbeforeMux,
        o_ASC => carryOut4
    );

    WITH sltbeforeMux(31) SELECT sltToMux <=
    x"00000001" WHEN '1',
    x"00000000" WHEN '0',
    x"00000000" WHEN OTHERS;

mux : mux16to1 PORT MAP(
        i_S => alucontrol,
        i_D(0) => addSubToMux, --add addi
        i_D(1) => addSubToMux, --addiu addu
        i_D(2) => addSubToMux, --sub
        i_D(3) => barToMux, --srl
        i_D(4) => addSubToMux, --subu
        i_D(5) => andToMux, --and
        i_D(6) => norToMux, --nor
        i_D(7) => xorToMux, --xor xori
        i_D(8) => barToMux, --sll
        i_D(9) => orToMux, --or ori
        i_D(10) => sltToMux, --slt slti
        i_D(11) => beqToMux, --beq
        i_D(12) => barToMux, --sra
        i_D(13) => bneToMux, --bne
        i_D(14) => luiToMux, --lui
        i_D(15) => x"00000000", --default
        o_O => o_ASum
    );

    --zero output is 1 when branch is need
    WITH beqToMux & bneToMux SELECT o_ZERO <=
    '1'    WHEN x"0000000000000000",
    '0' WHEN OTHERS;

    --Add, addi, and sub cause overflow
    WITH alucontrol & i_iput1(31) & i_iput2(31) & aluSig & addSubToMux(31) SELECT o_over <=
      '1'  WHEN "00000001",
      '1'  WHEN "00100111",
      '1'  WHEN "00101010",
      '1'  WHEN "00001100",
    '0' WHEN OTHERS;
END arch;
