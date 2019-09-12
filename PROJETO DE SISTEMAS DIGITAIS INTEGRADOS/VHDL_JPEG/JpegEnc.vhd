--------------------------------------------------------------------------------
--                                                                            --
--                          V H D L    F I L E                                --
--                 FEDERAL UNIVERSITY OF SANTA MARIA (UFSM)                   --
--                   PROJECT OF INTEGRATED DIGITAL SYSTEMS                    --
--------------------------------------------------------------------------------
--                                                                            --
-- Title       : JPEG ENCODER                                                 --
-- Design      : Implementation ASIC for JPEG Compressor                      --
-- Author's    : Luis Felipe de Deus | Nathanel Luchetta | Tiago Knorst       --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
-- File        : JpegEnc.vhd                                                  --
-- Created     : Friday, 08/12/18                                             --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Description : TOP entity of Jpeg Encoder                                  --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 

entity JpegEnc is
    generic( 
             SIGNED_DATA : integer:= 1;   --  input data - 0 - unsigned, 1 - signed
             scale_out:integer:=0	 
            );
             
    port (

            clk                : in  std_logic;
            rst                : in  std_logic;

            
            data_av_i          : in  std_logic;
            RGB_i              : in  std_logic_vector(23 downto 0);
            protocol_i		   : in std_logic;
            
		    ready_o            : out std_logic;
            data_o             : out std_logic_vector(11 downto 0);
            
			we_ram_o      	   :  out std_logic;
			waddr_ram_o    	   :  out std_logic_vector(6 downto 0)
			
			
        );
end JpegEnc;

architecture structural of JpegEnc is
    
type State is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
signal currentState: State;

signal datai_dct_s       :std_logic_vector(7 downto 0);
signal start_dct_s       :std_logic;
signal Y_s               :std_logic_vector(7 downto 0);
signal Cb_s              :std_logic_vector(7 downto 0);
signal Cr_s              :std_logic_vector(7 downto 0);
signal ready_color_s     :std_logic;
signal storage_s         :std_logic;
signal Y_cmp_s           :std_logic_vector(63 downto 0);
signal Cb_cmp_s          :std_logic_vector(63 downto 0);
signal Cr_cmp_s          :std_logic_vector(63 downto 0);
signal pixel_cnt_s       :std_logic_vector(2 downto 0);
signal componente_s      :std_logic_vector(1 downto 0);
signal send_data_s       :std_logic;
signal ready_dct_s       :std_logic;
signal dct_out_s         :std_logic_vector(11 downto 0);
signal zig_ready_s       :std_logic;
signal qua_data 	     :std_logic_vector(11 downto 0);
signal fdct_buf_sel      :std_logic;
signal fdct_rd_addr      :std_logic_vector(5 downto 0);
signal fdct_rden         :std_logic;
signal dbuf_raddr     	 :std_logic_vector(6 downto 0);
signal dbuf_q_s        	   :   std_logic_vector(11 downto 0);
signal qua_buf_sel_s :  std_logic;
signal qua_rdaddr_s:  std_logic_vector(5 downto 0);

    begin    
    ------ Instancia da conversão de cores RGB -> YCbCr
    U_rgb2ycbcr : entity work.rgb2_ycbcr
    port map
    (
        clk              =>   clk,
        rst              =>   rst,
        data_av_i        =>   data_av_i,
        RGB_i            =>   RGB_i,
        Y_o              =>   Y_s,
        Cb_o             =>   Cb_s,
        Cr_o             =>   Cr_s,
        ready_o          =>   ready_color_s
    );


    ------- Instancia do DCT 2D
    U_DCT2D : entity work.dct_circuit	   	
	generic map(
                d_signed => SIGNED_DATA,
                scale_out =>scale_out 
            )
	port map(
        clk               => clk,
        rst               => rst,
		data_i            => datai_dct_s,		
		en_i              => '1',
		data_o            => dct_out_s,
		rdy_o             => ready_dct_s,
		start_i           => start_dct_s
        );
		
		ready_o <= zig_ready_s;
        

    U_ZZ_TOP : entity work.ZZ_TOP
        port map
        (
              clk                => clk,
              rst                => rst,

              -- CTRL
              start_pb_i           => ready_dct_s,
              ready_pb_o           => zig_ready_s,
      
              -- Quantizer
              qua_buf_sel_i        => qua_buf_sel_s,
              qua_rdaddr_i         => qua_rdaddr_s,
              qua_data_o           => qua_data,
      
              -- FDCT
              fdct_buf_sel_o       => fdct_buf_sel,
              fdct_rd_addr_o       => fdct_rd_addr,
              fdct_data_i          => dct_out_s,
              fdct_rden_o          => fdct_rden,

              -- RAMZ
		    dbuf_data_o           =>  data_o,
		    dbuf_q_i        	   =>  dbuf_q_s,
		    dbuf_we_o      	         =>  we_ram_o,
		    dbuf_waddr_o    	   =>  waddr_ram_o,
		    dbuf_raddr_o     	   =>  dbuf_raddr
          );
             
        
          --PROTOCOLO PARA ARMAZENAR OS 8 BLOCOS DE CADA componente_s (8X8 = 64 bits)
        process (clk, rst)
        begin
            if(rst = '1') then
                pixel_cnt_s <= "000";
                Y_cmp_s <= x"0000000000000000";
                Cb_cmp_s <= x"0000000000000000";
                Cr_cmp_s <= x"0000000000000000";
                storage_s <= '0';
             elsif rising_edge(clk) then
                if(data_av_i = '1' and send_data_s = '0') then
                    if( pixel_cnt_s = "000") then 
                        Y_cmp_s <= x"00000000000000" & Y_s;
                        Cb_cmp_s <= x"00000000000000" & Cb_s;
                        Cr_cmp_s <= x"00000000000000" & Cr_s;
                        pixel_cnt_s <= std_logic_vector(unsigned(pixel_cnt_s) + 1);
                    elsif( pixel_cnt_s = "001") then 
                        Y_cmp_s(63 downto 8) <= x"000000000000" & Y_s;
                        Cb_cmp_s(63 downto 8) <= x"000000000000" & Cb_s;
                        Cr_cmp_s(63 downto 8) <= x"000000000000" & Cr_s;    
                        pixel_cnt_s <= std_logic_vector(unsigned(pixel_cnt_s) + 1);
                    elsif( pixel_cnt_s = "010") then 
                        Y_cmp_s(63 downto 16) <= x"0000000000" & Y_s;
                        Cb_cmp_s(63 downto 16) <= x"0000000000" & Cb_s;
                        Cr_cmp_s(63 downto 16) <= x"0000000000" & Cr_s;        
                        pixel_cnt_s <= std_logic_vector(unsigned(pixel_cnt_s) + 1);
                    elsif( pixel_cnt_s = "011") then 
                        Y_cmp_s(63 downto 24) <= x"00000000" & Y_s;
                        Cb_cmp_s(63 downto 24) <= x"00000000" & Cb_s;
                        Cr_cmp_s(63 downto 24) <= x"00000000" & Cr_s;   
                        pixel_cnt_s <= std_logic_vector(unsigned(pixel_cnt_s) + 1);
                    elsif( pixel_cnt_s = "100") then 
                        Y_cmp_s(63 downto 32) <= x"000000" & Y_s;
                        Cb_cmp_s(63 downto 32) <= x"000000" & Cb_s;
                        Cr_cmp_s(63 downto 32) <= x"000000" & Cr_s;   
                        pixel_cnt_s <= std_logic_vector(unsigned(pixel_cnt_s) + 1);
                    elsif( pixel_cnt_s = "101") then 
                        Y_cmp_s(63 downto 40) <= x"0000" & Y_s;
                        Cb_cmp_s(63 downto 40) <= x"0000" & Cb_s;
                        Cr_cmp_s(63 downto 40) <= x"0000" & Cr_s;   
                        pixel_cnt_s <= std_logic_vector(unsigned(pixel_cnt_s) + 1);
                    elsif( pixel_cnt_s = "110") then 
                        Y_cmp_s(63 downto 48) <= x"00" & Y_s;
                        Cb_cmp_s(63 downto 48) <= x"00" & Cb_s;
                        Cr_cmp_s(63 downto 48) <= x"00" & Cr_s;   
                        pixel_cnt_s <= std_logic_vector(unsigned(pixel_cnt_s) + 1);
                    elsif( pixel_cnt_s = "111") then 
                        Y_cmp_s(63 downto 56) <=  Y_s;
                        Cb_cmp_s(63 downto 56) <=  Cb_s;
                        Cr_cmp_s(63 downto 56) <=  Cr_s;       
                        pixel_cnt_s <= "000";
                        storage_s<= '1';    
                    end if;
                end if;     
            end if;     
        end process;

        ---------- INICIO PROCESS PROTOCOLO DE ENVIO DA CONVERSÃO DE CORES PARA O DCT2D
        ---------- Manda componente_s por componente_s do pixel (Y Cb Cr)
    process(clk,rst)
    begin
        if rst = '1' then
			currentState <= S0;                      
            datai_dct_s <= x"00";
            componente_s <= "00";
            send_data_s <= '0';
            start_dct_s <= '0';
            dbuf_q_s <= x"000";
	        qua_buf_sel_s <= '0';
	       qua_rdaddr_s <= "000000";
        elsif rising_edge(clk) then
            if(storage_s = '1') then
                case currentState is
                    when S0 =>                       
                        start_dct_s <= '1';
                        if(componente_s = "00") then
                            datai_dct_s <= Y_cmp_s(7 downto 0);
                        elsif (componente_s = "01" ) then 
                            datai_dct_s <= Cb_cmp_s(7 downto 0);
                        else
                            datai_dct_s <= Cr_cmp_s(7 downto 0);
                        end if;    
                    
                        currentState <= S1;                      
                    when S1 =>
                        start_dct_s <= '0';
                        if(componente_s = "00") then
                            datai_dct_s <= Y_cmp_s(15 downto 8);
                        elsif (componente_s = "01" ) then 
                            datai_dct_s <= Cb_cmp_s(15 downto 8);
                        else
                            datai_dct_s <= Cr_cmp_s(15 downto 8);
                        end if;    

                        currentState <= S2;                      
                    when S2 =>
                        if(componente_s = "00") then
                            datai_dct_s <= Y_cmp_s(23 downto 16);
                        elsif (componente_s = "01" ) then 
                            datai_dct_s <= Cb_cmp_s(23 downto 16);
                        else
                            datai_dct_s <= Cr_cmp_s(23 downto 16);
                        end if;    

                        currentState <= S3;                                          
                    when S3 =>
                        if(componente_s = "00") then
                            datai_dct_s <= Y_cmp_s(31 downto 24);
                        elsif (componente_s = "01" ) then 
                            datai_dct_s <= Cb_cmp_s(31 downto 24);
                        else
                            datai_dct_s <= Cr_cmp_s(31 downto 24);
                        end if;    

                        currentState <= S4;           
                    when S4 =>
                        if(componente_s = "00") then
                            datai_dct_s <= Y_cmp_s(39 downto 32);
                        elsif (componente_s = "01" ) then 
                            datai_dct_s <= Cb_cmp_s(39 downto 32);
                        else
                            datai_dct_s <= Cr_cmp_s(39 downto 32);
                        end if;    

                        currentState <= S5; 
                    when S5 =>
                        if(componente_s = "00") then
                            datai_dct_s <= Y_cmp_s(47 downto 40);
                        elsif (componente_s = "01" ) then 
                            datai_dct_s <= Cb_cmp_s(47 downto 40);
                        else
                            datai_dct_s <= Cr_cmp_s(47 downto 40);
                        end if;    

                        currentState <= S6; 
                    when S6 =>
                        if(componente_s = "00") then
                            datai_dct_s <= Y_cmp_s(55 downto 48);
                        elsif (componente_s = "01" ) then 
                            datai_dct_s <= Cb_cmp_s(55 downto 48);
                        else
                            datai_dct_s <= Cr_cmp_s(55 downto 48);
                        end if;    
                    
                        currentState <= S7;
                    when S7 =>
                        if(componente_s = "00") then
                            datai_dct_s <= Y_cmp_s(63 downto 56);
                            componente_s <= "01";
                        
                        elsif (componente_s = "01" ) then 
                            datai_dct_s <= Cb_cmp_s(63 downto 56);
                            componente_s <= "10";
                        else
                            datai_dct_s <= Cr_cmp_s(63 downto 56);
                            componente_s <= "00";
                            send_data_s <= '0';
                        end if;    

                        currentState <= S8;        
                        when S8 =>
						    if(protocol_i = '1') then
                                currentState <= S0;
                            else   
                                currentState <= S8;
                            end if;    
                        
                        when others =>                        
                            currentState <= S0;
                 
                        end case;
                    else 
                    send_data_s <= '0';
                    start_dct_s <= '0';
                end if;     
            end if;
        end process;

end structural;
