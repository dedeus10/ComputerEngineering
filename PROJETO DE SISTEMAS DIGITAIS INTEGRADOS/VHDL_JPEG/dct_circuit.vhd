--------------------------------------------------------------------------------
--                                                                            --
--                          V H D L    F I L E                                --
--                 FEDERAL UNIVERSITY OF SANTA MARIA (UFSM)                   --
--                   PROJECT OF INTEGRATED DIGITAL SYSTEMS                    --
--------------------------------------------------------------------------------
--                                                                            --
-- Title       : DCT2D                                                       --
-- Design      : Implementation ASIC for JPEG Compressor                      --
-- Author's    : Luis Felipe de Deus | Nathanel Luchetta | Tiago Knorst       --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
-- File        : dct_circuit.vhd                                              --
-- Created     : Friday, 08/12/18                                             --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Description : Structural Implementation                                   --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity dct_circuit is  
	generic(
		d_signed    : integer := 1;     -- 1 input data signed; 0 - unsigned, and for compression 1/2 is subtracted
		scale_out   : integer := 0      -- 1 output data are scaled; 0 - genuine DCT 
    );    
	port(
		clk         : in std_logic;
		rst         : in std_logic;
		start_i     : in std_logic;     -- after this impulse the 0-th datum is sampled
		en_i        : in std_logic;     -- operation enable to slow-down the calculations
		data_i      : in std_logic_vector(7 downto 0);
		rdy_o       : out std_logic;
		data_o      : out std_logic_vector(11 downto 0)
    );
end dct_circuit;				  

architecture behavioral of dct_circuit is	
    
    component dct_core is 
        generic( 
            WIDHT_g     : integer := 10;
            WIDHT2_g    : integer := 10;
            N_CYCLES_g  : integer := 31;
            D_SIGNED_g  : integer := 1;    -- 1 input data signed 0 - unsigned, and for compression 1/2 is subtracted
            SCALE_OUT_g : integer := 1);   -- 1 output data are scaled 0 - genuine DCT 
        port (
            clk         : in std_logic;
            rst         : in std_logic;		
            start_i     : in std_logic;     -- after this impulse the 0-th datum is sampled
            en_i        : in std_logic;     -- operation enable to slow-down the calculations
            data_i      : in std_logic_vector (WIDHT_g-3 downto 0);
            rdy_o       : out std_logic;    -- delayed start_i_i impulse, after it the 0-th result is outputted
            data_o      : out std_logic_vector (WIDHT_g-1 downto 0)     --  output data
            );
    end component;		 
	
	component dct_buffer is 
		generic( 
            WIDHT_g : integer := 10        -- input data WIDHT_gdth
        ); 	   
		port (
			clk     : in std_logic;
			rst     : in std_logic;		
			start_i : in std_logic;           -- after this impulse the 0-th datum is sampled
			en_i    : in std_logic;           -- operation enable to slow-down the calculations
			data_i  : in std_logic_vector (WIDHT_g-1 downto 0);
			rdy_o   : out std_logic;          -- delayed start_i impulse, after it the 0-th result is outputted
			data_o  : out std_logic_vector (WIDHT_g-1 downto 0) --  output data
        );
	end component;		  
	
	signal rdy1_s, rdy2_s, rdy3_s   : std_logic;
	signal data1_s, data1r_s        : std_logic_vector (9 downto 0);
	signal data2_s                  : std_logic_vector (11 downto 0);
	
begin	 
	
	U_ST1: dct_core	
        generic map(            
            WIDHT_g     => 10,
            WIDHT2_g    => 10,
            N_CYCLES_g  => 31,
            D_SIGNED_g  => d_signed,
            SCALE_OUT_g => scale_out
        )
        port map (
            clk     => clk,
            rst     => rst,		
            start_i => start_i,
            en_i    => en_i,
            data_i  => data_i,
            rdy_o   => rdy1_s,
            data_o  => data1_s
        );
       
	U_B1: dct_buffer  
        generic map( 
            WIDHT_g => 10       -- input data WIDHT_gdth
        ) 	   
        port map(
            clk     => clk,
            rst     => rst,	
            start_i => rdy1_s,  -- after this impulse the 0-th datum is sampled
            en_i    => en_i,    -- operation enable to slow-down the calculations
            data_i  => data1_s,
            rdy_o   => rdy2_s,  -- delayed start_i impulse, after it the 0-th result is outputted
            data_o  => data1r_s -- output data
        );
				
	U_ST2: dct_core		  
		generic map (            
            WIDHT_g     => 12,
            WIDHT2_g    => 11,
            N_CYCLES_g  => 16,
            D_SIGNED_g  => 1,
            SCALE_OUT_g => scale_out
        )
        port map (
            clk     => clk,
            rst     => rst,			
            start_i => rdy2_s,
            en_i    => en_i,
            data_i  => data1r_s,
            rdy_o   => rdy3_s,
            data_o  => data2_s
        );
        
	U_B2: dct_buffer  
        generic map( 
            WIDHT_g => 12       -- input data WIDHT_gdth
		) 	   
        port map(
            clk     => clk,
            rst     => rst,	
            start_i => rdy3_s,  -- after this impulse the 0-th datum is sampled
            en_i    => en_i,    -- operation enable to slow-down the calculations
            data_i  => data2_s,
            rdy_o   => rdy_o,   -- delayed start_i impulse, after it the 0-th result is outputted
            data_o  => data_o   -- output data
        );

	
end behavioral;
