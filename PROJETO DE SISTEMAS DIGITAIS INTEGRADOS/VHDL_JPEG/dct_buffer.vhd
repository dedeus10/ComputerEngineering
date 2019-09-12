--------------------------------------------------------------------------------
--                                                                            --
--                          V H D L    F I L E                                --
--                 FEDERAL UNIVERSITY OF SANTA MARIA (UFSM)                   --
--                   PROJECT OF INTEGRATED DIGITAL SYSTEMS                    --
--------------------------------------------------------------------------------
--                                                                            --
-- Title       : DCT2D                                                        --
-- Design      : Implementation ASIC for JPEG Compressor                      --
-- Author's    : Luis Felipe de Deus | Nathanel Luchetta | Tiago Knorst       --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
-- File        : dct_buffer.vhd                                               --
-- Created     : Friday, 08/12/18                                             --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Description : Buffer for interconnection     		                      --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;	 
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity dct_buffer is 
	generic( 
        WIDHT_g : integer:= 10      -- input data WIDHT_gdth
    ); 	   
	port (
		clk     : in std_logic;
		rst     : in std_logic;		
		start_i : in std_logic;     -- after this impulse the 0-th datum is sampled
		en_i    : in std_logic;     -- operation enable to slow-down the calculations
		data_i  : in std_logic_vector (WIDHT_g-1 downto 0);
		rdy_o   : out std_logic;    -- delayed start_i impulse, after it the 0-th result is outputted
		data_o  : out std_logic_vector (WIDHT_g-1 downto 0) --  output data
    );
end dct_buffer;


architecture behavioral of dct_buffer is   
	
	constant rnd_c : std_logic := '0';
	
	type array100 is array (0 to 99) of std_logic_vector (WIDHT_g -1 downto 0);	 
	type array64i is array (0 to 63) of integer range 0 to 127 ;	 
	constant address : array64i :=
	(49,50-8,  51-16,52-24,  53-32,54-40,55-48,56-56,
	56, 57-8,  58-16,59-24,  60-32,61-40,62-48,63-56,
	63, 64-8,  65-16,66-24,  67-32,68-40,69-48,70-56,  
	70, 71-8,  72-16,73-24,  74-32,75-40,76-48,77-56,
	
	77, 78-8,  79-16,80-24,  81-32,82-40,83-48,84-56,
	84, 85-8,  86-16,87-24,  88-32,89-40,90-48,91-56,
	91, 92-8,  93-16,94-24,  95-32,96-40,97-48,98-56,
	98, 99-8,100-16,101-24,102-32,103-40,104-48,105-56);
									   
	signal sr64_s : array100 := (others=>(others=>'0'));
	
	
	signal cycle_s, ad1_s   : integer range 0 to 63;	 
	signal ad2_s            : integer range 0 to 99;	 
	signal cycles_s         : integer range 0 to 63;	 	 
	
	
begin	   	 	 
	UU_COUN: process(clk,rst)
	begin
		if rst = '1' then	
			ad1_s    <= (-5) mod 64;	  
			cycles_s <= 63;				  
			rdy_o    <= '0';
            
		elsif clk = '1' and clk'event then 	
			if en_i = '1' then		
				rdy_o <= '0';
                
				if start_i = '1' then	   
					ad1_s <= (-48) mod 64;	  
					cycles_s <= 0;	
				elsif en_i = '1' then	
					ad1_s <= (ad1_s + 1) mod 64;  	 
					rdy_o <= '0';
                    
					if cycles_s /= 63 then 
						cycles_s <= (cycles_s + 1) ;
					end if;
                    
					if cycles_s = 48 then
						rdy_o <= '1';	
						ad1_s <= 0;
					end if;		
				end if;		  
			end if;
		end if;
	end process;	   			 
	
	SRL16_a: process(clk)  begin                        --  SRL16
		if clk'event and clk='1' then 
			if en_i = '1' then	 
				sr64_s <= data_i & sr64_s(0 to 98);     -- shift behavioral		  
				ad2_s  <= address(ad1_s) ;              -- FIFO address recoding
			end if;
		end if;
	end process;	 		   
	
	data_o <= sr64_s(ad2_s);    -- output from behavioral
	
	
end behavioral;
