LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY newBarrelShifter IS
    PORT (
        i_S : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- 5 select lines
        i_D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        shiftsel : IN STD_LOGIC;
        logOrAr : IN STD_LOGIC;
        o_O : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END newBarrelShifter;

ARCHITECTURE Structual OF newBarrelShifter IS
    SIGNAL s_shiftsig : STD_LOGIC_VECTOR(1 DOWNTO 0);
    CONSTANT ONES : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '1');
    SIGNAL bitsAdded : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL bitsSaved : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL shifts : STD_LOGIC_VECTOR(32 DOWNTO 0);
BEGIN
    -- 0 shift right and 1 shift left
    bitsSaved(31 DOWNTO to_integer(unsigned(i_S))) <= i_D(31 DOWNTO to_integer(unsigned(i_S))) WHEN shiftsel = '1' ELSE
    i_D(31 - to_integer(unsigned(i_S)) DOWNTO 0) WHEN shiftsel = '0';
    s_shiftsig <= shiftsel & logOrAr;
    bitsAdded(to_integer(unsigned(i_S)) DOWNTO 0) <=
    (OTHERS => '0') WHEN s_shiftsig = "00" ELSE
    (OTHERS => '0') WHEN s_shiftsig = "01" ELSE
    (OTHERS => '0') WHEN s_shiftsig = "10" ELSE
    (OTHERS => i_D(31)) WHEN s_shiftsig = "11";
    WITH s_shiftsig SELECT shifts <=
        bitsSaved(31 DOWNTO to_integer(unsigned(i_S))) & bitsAdded(to_integer(unsigned(i_S)) DOWNTO 0) WHEN "00",
        bitsSaved(31 DOWNTO to_integer(unsigned(i_S))) & bitsAdded(to_integer(unsigned(i_S)) DOWNTO 0) WHEN "01",
        bitsAdded(to_integer(unsigned(i_S)) DOWNTO 0) & bitsSaved(31 DOWNTO to_integer(unsigned(i_S))) WHEN "10",
        bitsAdded(to_integer(unsigned(i_S)) DOWNTO 0) & bitsSaved(31 DOWNTO to_integer(unsigned(i_S))) WHEN "11",
        "000000000000000000000000000000000" WHEN OTHERS;
    o_O <= shifts(32 DOWNTO 1) WHEN shiftsel = '0' ELSE
        shifts(31 DOWNTO 0) WHEN shiftsel = '1';

END Structual;
