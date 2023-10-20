-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH;
	  I : integer := 26);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
component FetchComponent is
  port(i_CLK        : in std_logic;     -- Clock input
       i_jAddr      : in std_logic_vector(I-1 downto 0);     -- Reset input
       i_PC         : in std_logic_vector(N-1 downto 0);     -- Write enable input
       i_branchAddr : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_branchEN   : in std_logic; 
       i_jumplink   : in std_logic;    
       i_jumpEN     : in std_logic; 
       i_jrAddr     : in std_logic_vector(N-1 downto 0); 
       i_jrEN	    : in std_logic;
       o_pcOut      : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_pcAddFour  : out std_logic_vector(N-1 downto 0));
end component;

component RegFile is 
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_RS         : in std_logic_vector(4 downto 0);     
       i_RT         : in std_logic_vector(4 downto 0); 
       i_RD         : in std_logic_vector(4 downto 0);    
       o_Q          : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

component Register_N is
generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end component;

component Extender is
	port 
	(
		i_data		: in std_logic_vector(15 downto 0);
		sel             : in std_logic;
		o_data	        : out std_logic_vector(31 downto 0)
	);

end component;


component mux2t1_N is
generic(N : integer := 32);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

component Control is 
  port(i_OpCode : in std_logic_vector(5 downto 0);  --OpCode
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
end component;

component andg2 is 
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component CompleteALU is
  port(i_iput1      : in std_logic_vector(N-1 downto 0);
       i_iput2      : in std_logic_vector(N-1 downto 0);
       i_shamt 	    : in std_logic_vector(4 downto 0); 	
       alucontrol   : in std_logic_vector(3 downto 0);
       ALUSrc       : in std_logic;
       o_ASum       : out std_logic_vector(N-1 downto 0);
       o_ZERO       : out std_logic;
       o_over       : out std_logic); 
end component;



--Extra Added Signals 
signal  s_RS, s_RT         :  std_logic_vector(4 downto 0);     
signal  s_RegOutData  	   :  std_logic_vector(31 downto 0);
signal  s_imm16            :  std_logic_vector(15 downto 0);
signal  s_imm32 	   :  std_logic_vector(31 downto 0);
signal  s_MuxOutToALU      :  std_logic_vector(N-1 downto 0);
signal  s_ALUSrc           :  std_logic;
signal  s_ALUControl 	   :  std_logic_vector(3 downto 0);
signal  s_Mem2Reg    	   :  std_logic;
signal  s_MemWrite  	   :  std_logic;
signal  s_RegDst    	   :  std_logic;
signal  s_RegWrite  	   :  std_logic;                    
signal  s_Jump       	   :  std_logic;
signal  s_JumpLink   	   :  std_logic;
signal  s_JumpReg    	   :  std_logic;
signal  s_Branch    	   :  std_logic;
signal  s_ExtSelect 	   :  std_logic;
signal	s_MemRead    	   :  std_logic;
signal  s_PC               :  std_logic_vector(N-1 downto 0);     
signal  s_branchAddr 	   :  std_logic_vector(N-1 downto 0);         
signal  s_jrAddr           :  std_logic_vector(N-1 downto 0); 
signal  s_PCsrc  	   :  std_logic;
signal  s_Zero  	   :  std_logic;
signal  s_PCoutput, s_pcDEL         :  std_logic_vector(N-1 downto 0); 



begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
with s_Inst select
    s_Halt <= '1' when x"50000000",
      '0' when others;
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU
  -- TODO: Implement the rest of your processor below this comment! 
g_extender: Extender 
port map(i_data	=> s_Inst(15 downto 0),
	sel	=> s_ExtSelect,
	o_data	=> s_imm32);

g_MuxWriteReg: mux2t1_N
generic map(N => 5)
port map(i_S		=> s_RegDst,
	i_D0		=> s_Inst(20 downto 16),
	i_D1		=> s_Inst(15 downto 11),
	o_O		=> s_RegWrAddr);

g_RegisterFile: RegFile
port map(i_CLK		=> iCLK,
	i_RST		=> iRST,
	i_WE		=> s_RegWr,
	i_D		=> s_RegWrData,
	i_RS		=> s_Inst(25 downto 21),
	i_RT		=> s_Inst(20 downto 16),
	i_RD		=> s_RegWrAddr,
	o_Q		=> s_RegOutData,
	o_O		=> s_DMemData);

g_PCreg : Register_N
port map(i_CLK       => iCLK, 
       i_RST         => iRST,
       i_WE          => '1',
       i_D           => s_PCoutput,
       o_Q           => s_NextInstAddr);

g_MuxtoALU: mux2t1_N
port map(i_S		=> s_ALUSrc,
	i_D0		=> s_DMemData,
	i_D1		=> s_imm32,
	o_O		=> s_MuxOutToALU);

g_FetchComponent: FetchComponent
port map(i_CLK		=> iCLK,     
       i_jAddr		=> s_Inst(25 downto 0),      
       i_PC		=> s_NextInstAddr,        
       i_branchAddr	=> s_imm32, 
       i_branchEN	=> s_PCSrc,       
       i_jumpEN		=> s_Jump,    
       i_jrAddr		=> s_RegOutData,      
       i_jrEN		=> s_JumpReg,
       i_jumplink	=> s_JumpLink,	    
       o_pcOut		=> s_PCoutput,     
       o_pcAddFour	=> s_pcDEL);


g_ControlUnit: Control
port map(i_OpCode      => s_Inst(31 downto 26),   
       i_Function      => s_Inst(5 downto 0),   
       o_ALUSrc        => s_ALUSrc, 
       o_ALUControl    => s_ALUControl, 
       o_Mem2Reg       => s_Mem2Reg,
       o_MemWrite      => s_DMemWr, 
       o_RegDst        => s_RegDst,
       o_RegWrite      => s_RegWr,                   
       o_Jump          => s_Jump,
       o_JumpLink      => s_JumpLink,
       o_JumpReg       => s_JumpReg,
       o_Branch        => s_Branch,
       o_ExtSelect     => s_ExtSelect,
       o_MemRead       => s_MemRead );

g_andGate: andg2
port map(i_A            => s_Branch,
       i_B              => s_Zero,
       o_F              => s_PCSrc);

g_completeALU: CompleteALU
port map(alucontrol	=> s_ALUControl,
	i_iput1		=> s_RegOutData,
	i_iput2		=> s_MuxOutToALU,
	i_shamt 	=> s_Inst(10 DOWNTO 6),
	ALUSrc		=> s_ALUSrc,    
	o_over		=> s_Ovfl,
	o_ZERO		=> s_Zero,
	o_ASum		=> oALUOut);

s_DMemAddr <= oALUOut;

g_MuxMemToReg: mux2t1_N
port map(i_S		=> s_Mem2Reg,
	i_D0		=> s_DMemAddr,
	i_D1		=> s_DMemOut,
	o_O		=> s_RegWrData);

end structure;

