-------------------------------------------------------------------------
-- Design unit: MIPS multicycle
-- Description: Control and data paths port map
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.MIPS_pkg.all;

entity MIPS_MultiCycle is
    generic (
        PC_START_ADDRESS    : integer := 0  -- PC initial value (first instruction address)
    );
    port ( 
        clock, reset        : in std_logic;
        
		--Interrupt Pin
		intr				: in std_logic;
        -- Instruction memory interface
        instructionAddress  : out std_logic_vector(31 downto 0);
        instruction         : in  std_logic_vector(31 downto 0);
        
        -- Data memory interface
        dataAddress         : out std_logic_vector(31 downto 0);
        data_i              : in  std_logic_vector(31 downto 0);      
        data_o              : out std_logic_vector(31 downto 0);
        ce_ins              : out std_logic;
        ce_data             : out std_logic;
        wbe                 : out std_logic_vector(3 downto 0)
    );
end MIPS_MultiCycle;

architecture structural of MIPS_MultiCycle is
    
    signal uins: Microinstruction;
    signal IR, dataAddress_dp, instructionAddress_dp: std_logic_vector(31 downto 0);
	signal div_zero, overflow : std_logic;

begin

     CONTROL_PATH: entity work.ControlPath(behavioral)
         port map (
             clock          => clock,
             reset          => reset,
			 intr			=> intr,
             instruction    => IR, 
             uins           => uins, 
			 overflow		=> overflow,
			 div_zero		=> div_zero
			 
         );         
         
     DATA_PATH: entity work.DataPath(structural)
         generic map (
            PC_START_ADDRESS => PC_START_ADDRESS
         )
         port map (
            clock               => clock,
            reset               => reset,            
            uins                => uins,              
            instructionAddress  => instructionAddress_dp, 
            instruction         => instruction,              
            dataAddress         => dataAddress_dp,  
            data_i              => data_i,  
            data_o              => data_o, 
            IR                  => IR, 
			overflow			=> overflow,
			div_zero			=> div_zero
         );
    
    dataAddress <= dataAddress_dp;
    instructionAddress <= instructionAddress_dp;
    
    -- Instruction memory control
    ce_ins <= uins.ce_ins;
    
    -- Data memory control
    wbe <= uins.MemWrite & uins.MemWrite & uins.MemWrite & uins.MemWrite;   -- SW
    ce_data <= uins.ce_data;
    
    --assert not (uins.ce_data = '1' and uins.MemWrite = '0' and uins.Instruction = LW and dataAddress_dp(1 downto 0) /= "00")
    --report "*************** LW address not aligned on word boundary ***************"
    --severity failure;
    
    --assert not (uins.ce_data = '1' and uins.MemWrite = '1' and uins.Instruction = SW and dataAddress_dp(1 downto 0) /= "00")
    --report "*************** SW address not aligned on word boundary ***************"
    --severity failure;
    
   -- assert  not (instructionAddress_dp(1 downto 0) /= "00" and reset = '0')
   -- report "*************** Instruction fetch address not aligned on word boundary ***************"
   -- severity failure;
     
end structural;