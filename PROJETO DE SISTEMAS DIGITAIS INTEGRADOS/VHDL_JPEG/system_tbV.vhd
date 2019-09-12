--------------------------------------------------------------------------------
--                                                                            --
--                          V H D L    F I L E                                --
--                 FEDERAL UNIVERSITY OF SANTA MARIA (UFSM)                   --
--                   PROJECT OF INTEGRATED DIGITAL SYSTEMS                    --
--------------------------------------------------------------------------------
--                                                                            --
-- Title       : TEST BENCH                                                   --
-- Design      : Implementation ASIC for JPEG Compressor                      --
-- Author's    : Luis Felipe de Deus | Nathanel Luchetta | Tiago Knorst       --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
-- File        : system_tbV.vhd                                               --
-- Created     : Friday, 08/12/18                                             --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Description : TestBench of Jpeg Encoder                                  --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 
use std.textio.all;
use work.Util_pkg.all;


entity System_tb is
    generic( SIGNED_DATA : integer:= 1;   --  input data - 0 - unsigned, 1 - signed
	         scale_out:integer:=0	 );
end System_tb;

architecture structural of System_tb is
  
    signal clk : std_logic := '1';
    signal rst : std_logic;
    
    signal data_in1    : std_logic_vector(7 downto 0);
    signal data_in2    : std_logic_vector(7 downto 0);
    signal color_cmp   : std_logic_vector(1 downto 0);
    signal index       : integer;
    signal blocos_enviados       : std_logic_vector(4 downto 0);
    signal en_send_block: std_logic;
    signal cor_process       : std_logic_vector(2 downto 0);

    signal data_av_i          :std_logic;
    signal RGB_i              :std_logic_vector(23 downto 0);
    signal protocol_i		   :std_logic;
    signal ready_o            :std_logic;
    signal data_o             :std_logic_vector(11 downto 0);
    signal we_ram_o      	   :std_logic;
    signal waddr_ram_o    	   :std_logic_vector(6 downto 0);

    --Declara dois sinais do tipo estado (2 process)
    type State is (S0, S1, S2);
        signal currentState: State;
        
----------------------------------FUNÇÃO QUE LÊ O TXT ------------------------------------------------------        
	constant SIZE           : integer := 50;      --numero de linhas do arquivo_tx.txt
   
    type byteVec is array (0 to 4*SIZE-1) of std_logic_vector(7 downto 0);
   
   impure function PROGRAMLoad (imageFileName : in string) return byteVec is
        FILE imageFile : text open READ_MODE is imageFileName;
        variable fileLine : line;
        variable BinArray : byteVec;
        variable data_str : bit; --string(1 to 2);
		  variable bin : std_logic_vector(7 downto 0);
    begin   
        for i in 1 to SIZE loop
            readline (imageFile, fileLine);
            for j in 1 to 4 loop
					 for k in 7 downto 0 loop
						  read (fileLine, data_str);
						  bin(k) := to_stdulogic(data_str);
				    end loop;
                BinArray((i*4)-j) := bin; --StringToStdLogicVector(data_str);
            end loop; 
        end loop;
        return BinArray;
    end function;
     
    signal TXArray   : byteVec := PROGRAMLoad("teste.txt");
-----------------FIM FUNÇÃO DE LEITURA DO TXT-------------------------------------------------    

------- Instancia do DCT 2D
component JpegEnc
generic (SIGNED_DATA: integer:=1;
		scale_out: integer:=0 );
port
(
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
end component;

begin
    
    --Estímulos
    clk <= not clk after 5 ns; -- 100 MHz
    rst <= '1', '0' after 195 ns; 


	------ Instancia da entidade top
    U_JpegEnc : JpegEnc
    generic map(SIGNED_DATA, scale_out )
    port map
    (
        clk,
        rst,
        data_av_i,
        RGB_i,
        protocol_i,
        ready_o,
        data_o,
        we_ram_o,
        waddr_ram_o
    );
    
    
--------INICIO PROCESS PROTOCOLO DE CONVERSÃO DE CORES (Lê a cada ciclo de clock 8 bits (RGB_i))
--------Depois do 3 ciclo envia para entrada do rgb2ycbcr um entrada de 24 bits (componentes RGB_i)
	process(clk,rst)
    begin
        
        if rst = '1' then
            index <= 0;
            color_cmp <= "00";
            currentState <= S0;
            data_av_i <= '0';

        elsif rising_edge(clk) then
            case currentState is
                when S0 =>
                    
                        if en_send_block = '1' then
                        data_av_i <= '0';
                        if(color_cmp = "00") then
                            data_in1 <= TXArray(index);
                            color_cmp <= std_logic_vector(unsigned(color_cmp) + 1);
                            index <= index + 1;
                            currentState <= S0;

                        elsif (color_cmp = "01") then
                            data_in2 <= TXArray(index);
                            color_cmp <= std_logic_vector(unsigned(color_cmp) + 1);
                            index <= index + 1;
                            currentState <= S0;

                        elsif (color_cmp = "10") then
                            RGB_i <= TXArray(index)  & data_in2 & data_in1;
                            color_cmp <= "00";
                            index <= index + 1;
                            data_av_i <= '1';
                           
                            currentState <= S0;
                         else
                        currentState <= S0;
                        end if;   
                    else
                        data_av_i <= '0';
                        currentState <= S0;
                    end if;
                    
                when others =>                        
                        currentState <= S0;
						                      
            end case;
        end if;
    end process;

    process(clk, rst)
    begin
        if (rst = '1') then
        en_send_block <= '1';
        blocos_enviados <= "00000";
        cor_process <= "000";
        protocol_i <= '0';
        elsif  rising_edge(clk) then
            if(ready_o = '1') then
                protocol_i <= '1';
                if(cor_process = "010") then
                    en_send_block <= '1';
                    cor_process <= "000";
                else
                    cor_process <= std_logic_vector(unsigned(cor_process) + 1);
                end if;    
                
            elsif (en_send_block = '1') then
                
                    protocol_i <= '0';
                if(blocos_enviados = "11000") then
                    blocos_enviados <= "00000"; 
                
                    en_send_block <= '0';
                else
                    blocos_enviados <= std_logic_vector(unsigned(blocos_enviados) + 1);
                    
                end if;
            else
                
                protocol_i <= '0';
               
            end if;    
        end if;    
            
        end process;

end structural;
