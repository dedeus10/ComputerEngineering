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
-- File        : dct_core.vhd                                                 --
-- Created     : Friday, 08/12/18                                             --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Description : Effects the discrete cosine transform                       --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;	 
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity dct_core is 		
	generic( 
        WIDHT_g      : integer := 10;
        -- 1: 10
        -- 2: 12
        WIDHT2_g     : integer := 10;
        -- 1: 10
        -- 2: 11
        N_CYCLES_g   : integer := 31;
        D_SIGNED_g   : integer := 1;    --1 input data signed 0 - unsigned, and for compression 1/2 is subtracted
		SCALE_OUT_g  : integer := 1     -- 1 output data are scaled 0 - genuine DCT 
    );   
	port (
		clk         : in std_logic;
		rst         : in std_logic;		
		start_i     : in std_logic;     -- after this impulse the 0-th datum is sampled
		en_i        : in std_logic;     -- operation enable to slow-down the calculations
		data_i      : in std_logic_vector (WIDHT_g-3 downto 0);
		rdy_o       : out std_logic;    -- delayed start_i impulse, after it the 0-th result is outputted
		data_o      : out std_logic_vector (WIDHT_g-1 downto 0)     --  output data
    );
end dct_core;


architecture behavioral of dct_core is   
	
	type array8_t  is array (0 to 7)  of std_logic_vector (10 downto 0);	
	type array16_t is array (0 to 15) of std_logic_vector (WIDHT_g-3 downto 0);
	signal sr_s16_s : array16_t := (others=>(others=>'0'));      -- sr_sL16 array
	
	constant S : array8_t := 
	(conv_std_logic_vector(integer(0.35355*2.0**9),11),
	conv_std_logic_vector(integer(0.2549*2.0**9),11),
	conv_std_logic_vector(integer(0.2706*2.0**9),11),			
	conv_std_logic_vector(integer(0.30067*2.0**9),11),	 
	conv_std_logic_vector(integer(0.35355*2.0**9),11),
	conv_std_logic_vector(integer(0.44999*2.0**9),11),
	conv_std_logic_vector(integer(0.65328*2.0**9),11),
	conv_std_logic_vector(integer(1.2815*2.0**9),11) );
    --(0.5/sqrt(2.0), 0.25/cos(pii*1.0),0.25/cos(pii*2.0),0.25/cos(pii*3.0),
	-- 0.25/cos(pii*4.0),0.25/cos(pii*5.0),0.25/cos(pii*6.0),0.25/cos(pii*7.0));
	
	constant m1_c  : std_logic_vector (10 downto 0) := conv_std_logic_vector(integer(0.70711*2.0**9),11); -- cos(pii*4.0) 
	constant m2_c  : std_logic_vector (10 downto 0) := conv_std_logic_vector(integer(0.38268*2.0**9),11); -- cos(pii*6.0)
	constant m3_c  : std_logic_vector (10 downto 0) := conv_std_logic_vector(integer(0.5412 *2.0**9),11); --(cos(pii*2.0) - cos(pii*6.0)) 
	constant m4_c  : std_logic_vector (10 downto 0) := conv_std_logic_vector(integer(1.3066*2.0**9),11);  -- cos(pii*2.0) + cos(pii*6.0)
	
	constant zeros_c    : std_logic_vector (WIDHT_g-5 downto 0) := (others => '0');	
	constant a1_2       : std_logic_vector (WIDHT_g-3 downto 0) := "10"&zeros_c;
    
	signal sr_s : std_logic_vector (10 downto 0) ;
	
	signal cycle_s, ad1_s, cycle6_s  : integer range 0 to 7;
    signal cycles_s                  : integer range 0 to N_CYCLES_g;
    
	signal di_s, a1_s, a2_s, a3_s, a4_s             : std_logic_vector (WIDHT_g-3 downto 0);	
	signal bp_s, bm_s, b1_s, b2_s, b3_s, b4_s, b6_s : std_logic_vector (WIDHT_g-2 downto 0);  	
    signal cp_s, cm_s, c1_s, c2_s, c3_s, c4_s       : std_logic_vector (WIDHT_g downto 0);	
    
    signal dp_s, dm_s                               : std_logic_vector (WIDHT2_g+1 downto 0);	   
	signal rd_s                                     : std_logic_vector (WIDHT2_g+1 downto 0);
	signal ep_s                                     : std_logic_vector (WIDHT2_g+12 downto 0);
    signal m1_4_s                                   : std_logic_vector (10 downto 0);
	signal e27_s                                    : std_logic_vector (WIDHT_g downto 0);	 	      
	signal fp_s, fm_s, f45_s, s7_s, s07_s, sp_st_s  : std_logic_vector (WIDHT_g+1 downto 0);   
	signal sp_s                                     : std_logic_vector (WIDHT_g+12 downto 0);
	
	
begin	   	 	 
	UU_COUN0: process(clk,rst)
	begin
		if rst = '1' then	
			cycle_s  <= 0;	   
			cycle6_s <= (-6) mod 8;	
			ad1_s    <= (-5) mod 8;	  
			cycles_s <= 16;				  
			rdy_o  <= '0';
		elsif clk = '1' and clk'event then 	
			if en_i = '1' then		
				rdy_o <='0';
                
				if start_i = '1' then	   
					cycle_s  <= 0;		
					cycle6_s <= (-6) mod 8;	
					ad1_s    <= (-5) mod 8;	  
					cycles_s <= 0;	
				elsif en_i = '1' then	
					cycle_s  <= (cycle_s + 1) mod 8 ;	  
					cycle6_s <= (cycle6_s + 1) mod 8 ;	  
					ad1_s    <= (ad1_s + 1) mod 8;  
                    
					if cycles_s = 15 then 
						rdy_o <= '1';  
					end if;
                    
					if (cycles_s/=17 and WIDHT_g=10) or (cycles_s/=16 and WIDHT_g=12) then
                        cycles_s <=(cycles_s +1) ;	  
					end if;		
				end if;		  
			end if;
		end if;
	end process;	   			 
	
	sr_sL16_a: process(clk)  begin      --  sr_sL16
		if clk'event and clk='1' then 
			if en_i='1' and (cycle_s=1 or cycle_s=2 or cycle_s=3 or cycle_s=4) then	 
				sr_s16_s <= di_s & sr_s16_s(0 to 14);   -- shift sr_sL16		  
			end if;
		end if;
	end process;	 
	a1_s<= sr_s16_s(ad1_s);     -- output from sr_sL16
	
	
	SM_B: process(clk,rst)	
	begin
		if rst = '1' then	  
			di_s <= (others => '0');		  
			bp_s <= (others => '0');      
			bm_s <= (others => '0');
            
		elsif clk = '1' and clk'event then 	 
			if en_i = '1' then	  				  
				if D_SIGNED_g =0 then
					di_s <= unsigned(data_i) - unsigned(a1_2);
				else
					di_s <= data_i;
				end if;	 
                
				bp_s <= SXT(di_s, WIDHT_g-1) + a1_s;
				bm_s <= a1_s - SXT(di_s, WIDHT_g-1);
			end if;
		end if;
	end process;	   	
	
	SM_C: process(clk,rst)	
	begin
		if rst = '1' then	  
			b1_s <= (others => '0');		  
			b2_s <= (others => '0');      
			b3_s <= (others => '0');
			b4_s <= (others => '0');		  
			b6_s <= (others => '0');      
			cp_s <= (others => '0');
			cm_s <= (others => '0');	
			c1_s <= (others => '0');
			
		elsif clk = '1' and clk'event then 	 
			if en_i = '1' then	  	
				b1_s <= bp_s;
				b2_s <= b1_s;
                
				if cycle_s = 2 then 
					b3_s <= b4_s;
				else
					b3_s <= b2_s;
				end if;
                
				b4_s <= b3_s;
				b6_s <= bm_s;
                
				case cycle_s is
					when 0|1|7 =>
                        cp_s <= SXT(bm_s, WIDHT_g+1) + b6_s;	
					when 2|3 =>
                        cp_s <= SXT(b2_s, WIDHT_g+1) + b3_s;
					when others=> 
                        cp_s <= cp_s + c1_s;
				end case;
                
				c1_s <= cp_s;
				
				if cycle_s=2 or  cycle_s=3 then
					cm_s <= SXT(b2_s, WIDHT_g+1) - b3_s;
				else
					cm_s <= cp_s - c1_s;
				end if;	   
				
			end if;
		end if;
	end process;	  
	
	
	SM_D: process(clk,rst)	
	begin
		if rst = '1' then	  
			c2_s <= (others => '0');      
			c3_s <= (others => '0');
			c4_s <= (others => '0');		 
			dp_s <= (others => '0');
			dm_s <= (others => '0');	
            
		elsif clk = '1' and clk'event then 	 
			if en_i = '1' then	  	
				if cycle_s=3 or  cycle_s=4 or cycle_s=5 then
					c2_s <= cm_s;											
				end if;
                
				if cycle_s = 1 then 
					c3_s <= c1_s;
				end if;	
                
				if cycle_s = 2 then 
					c4_s <= SXT(b6_s, WIDHT_g+1);	
				elsif cycle_s=5 then
					c4_s <= c2_s;
				end if;		
                
				if cycle_s = 4 then 
					dp_s <= SXT(cm_s, WIDHT2_g+2) + c2_s(WIDHT_g downto 0); 
				else
					dp_s <= ep_s(WIDHT2_g+10 downto 9) + c4_s(WIDHT_g downto 0); 
				end if;	   
				
				if cycle_s = 2 then 
					dm_s <= c3_s(WIDHT_g downto 0) - SXT(cp_s, WIDHT2_g+2); 
				elsif cycle_s=3  or cycle_s =7 then
					dm_s <= c4_s(WIDHT_g downto 0) - ep_s(WIDHT2_g+10 downto 9); 	
				end if;		   
				
			end if;
		end if;
	end process;	 	  
	
	MPU1: process(clk,rst)	
	begin
		if clk = '1' and clk'event then 	 
			if en_i = '1' then
				case cycle_s is
					when 1|5 => 
                        m1_4_s <= m1_c;
					when 2 => 
                        m1_4_s <= m4_c;
					when 3 => 
                        m1_4_s <= m2_c;
					when others => 
                        m1_4_s <= m3_c;
				end case ;	  
                
				case cycle_s is
					when 1|2 => 
                        rd_s <= SXT(cp_s, WIDHT2_g+2);
					when 3 => 
                        rd_s <= dm_s;
					when 4 => 
                        rd_s <= SXT(c3_s, WIDHT2_g+2);
					when others => 
                        rd_s <= dp_s;
				end case;	   
                
				ep_s  <= rd_s * m1_4_s;
				e27_s <= ep_s(WIDHT_g+9 downto 9);
			end if;
		end if;
	end process;	   
	
	SM_F: process(clk,rst)	
	begin
		if rst = '1' then	  
			fp_s  <= (others => '0');		  
			fm_s  <= (others => '0');      
			f45_s <= (others => '0');		   
			s7_s  <= (others => '0');	
            
		elsif clk = '1' and clk'event then 	 
			if en_i = '1' then	  				  
				case cycle_s is
					when 3 => 
                        fp_s <= ep_s(WIDHT_g+9 downto 9) + SXT(c4_s, WIDHT_g+2);
					when 5 => 
                        fp_s <= ep_s(WIDHT_g+9 downto 9) + SXT(e27_s, WIDHT_g+2);
					when 6|0 =>	
                        fp_s <= fp_s + f45_s;				
					when 7 =>
                        fp_s <= e27_s + f45_s; 	
					when others => 
                        null;
				end case;	   
				
				if cycle_s=4 then
					f45_s <= fp_s;
				elsif cycle_s=6 then
					f45_s <= SXT(e27_s, WIDHT_g+2);	
				elsif cycle_s=7 or cycle_s=0 then
					f45_s <= SXT(dm_s, WIDHT_g+2);
				end if;
				
                fm_s <= f45_s - fp_s;
                
				if cycle_s=7 then
					s7_s <= fm_s;
				end if;
			end if;
		end if;
	end process;	   
	
	MPU2: process(clk,rst)	
	begin
		if clk = '1' and clk'event then 	 
			if en_i = '1' then
				sr_s <= s(cycle6_s);
				case cycle_s is
					when 6 => 
                        s07_s <= SXT(c1_s, WIDHT_g+2);
					when 7|3 => 
                        s07_s <= fp_s;
					when 0 => 
                        s07_s <= SXT(dp_s, WIDHT_g+2);
					when 1 => 
                        s07_s <= SXT(fm_s, WIDHT_g+2);
					when 2 => 
                        s07_s <= SXT(c2_s, WIDHT_g+2);
					when 4 => 
                        s07_s <= SXT(f45_s, WIDHT_g+2);
					when others => 
                        s07_s <= s7_s;
				end case ;	  
				if SCALE_OUT_g = 0 then
					sp_s <= s07_s * sr_s;	 
					data_o <= sp_s(WIDHT_g+8 downto 9);
				else	 
					sp_st_s <= s07_s;	 
					data_o  <= sp_st_s(WIDHT_g downto 1);
				end if;
			end if;
		end if;
	end process;
	
end behavioral;
