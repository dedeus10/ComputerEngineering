--------------------------------------------------------------------------------
--                                                                            --
--                          V H D L    F I L E                                --
--                 FEDERAL UNIVERSITY OF SANTA MARIA (UFSM)                   --
--                   PROJECT OF INTEGRATED DIGITAL SYSTEMS                    --
--------------------------------------------------------------------------------
--                                                                            --
-- Title       : RGB TO YCBCR                                                 --
-- Design      : Implementation ASIC for JPEG Compressor                      --
-- Author's    : Luis Felipe de Deus | Nathanel Luchetta | Tiago Knorst       --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
-- File        : rgb_ycbcr.vhdl                                               --
-- Created     : Friday, 08/12/18                                             --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Description : RGB color converter for YCbCr                               --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------


library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity rgb2_ycbcr is
  port 
  (
        clk                  : in  std_logic;
        rst                  : in  std_logic;

        data_av_i            : in  std_logic;
        RGB_i                : in std_logic_vector(23 downto 0);

        
        Y_o                  : out std_logic_vector(7 downto 0);
        Cb_o                 : out std_logic_vector(7 downto 0);
        Cr_o                 : out std_logic_vector(7 downto 0);
        ready_o              : out std_logic
    );
end entity rgb2_ycbcr;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
----------------------------------- ARCHITECTURE ------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
architecture RTL of rgb2_ycbcr is
  
  -----COnstantes Para conversão---------
  constant C_Y_1_c       : signed(14 downto 0) := to_signed(4899,  15);
  constant C_Y_2_c       : signed(14 downto 0) := to_signed(9617,  15);
  constant C_Y_3_c       : signed(14 downto 0) := to_signed(1868,  15);
  constant C_Cb_1_c      : signed(14 downto 0) := to_signed(-2764, 15);
  constant C_Cb_2_c      : signed(14 downto 0) := to_signed(-5428, 15);
  constant C_Cb_3_c      : signed(14 downto 0) := to_signed(8192,  15);
  constant C_Cr_1_c      : signed(14 downto 0) := to_signed(8192,  15);
  constant C_Cr_2_c      : signed(14 downto 0) := to_signed(-6860, 15);
  constant C_Cr_3_c      : signed(14 downto 0) := to_signed(-1332, 15);

  ------Signals-------
  signal Y_reg_1_s           : signed(23 downto 0);
  signal Y_reg_2_s           : signed(23 downto 0);
  signal Y_reg_3_s           : signed(23 downto 0);
  signal Cb_reg_1_s          : signed(23 downto 0);
  signal Cb_reg_2_s          : signed(23 downto 0);
  signal Cb_reg_3_s          : signed(23 downto 0);
  signal Cr_reg_1_s          : signed(23 downto 0);
  signal Cr_reg_2_s          : signed(23 downto 0);
  signal Cr_reg_3_s          : signed(23 downto 0);
  signal Y_reg_s             : signed(23 downto 0);
  signal Cb_reg_s            : signed(23 downto 0);
  signal Cr_reg_s            : signed(23 downto 0);
  signal R_s                 : signed(8 downto 0);
  signal G_s                 : signed(8 downto 0);
  signal B_s                 : signed(8 downto 0);
  
  
-------------------------------------------------------------------------------
-- Architecture: begin
-------------------------------------------------------------------------------
begin

  R_s <= signed('0' & RGB_i(7 downto 0));
  G_s <= signed('0' & RGB_i(15 downto 8));
  B_s <= signed('0' & RGB_i(23 downto 16));
  
  -------------------------------------------------------------------
  -- RGB to YCbCr conversion
  -------------------------------------------------------------------
  p_rgb2ycbcr : process(clk, rst)
  begin
    if rst = '1' then
      Y_reg_1_s  <= (others => '0');
      Y_reg_2_s  <= (others => '0');
      Y_reg_3_s  <= (others => '0');
      Cb_reg_1_s <= (others => '0');
      Cb_reg_2_s <= (others => '0');
      Cb_reg_3_s <= (others => '0');
      Cr_reg_1_s <= (others => '0');
      Cr_reg_2_s <= (others => '0');
      Cr_reg_3_s <= (others => '0');
      Y_reg_s    <= (others => '0');
      Cb_reg_s   <= (others => '0');
      Cr_reg_s   <= (others => '0');
	  ready_o <= '0';
    elsif clk'event and clk = '1' then
      if data_av_i = '1' then
          ready_o <= '0';
          Y_reg_1_s  <= R_s*C_Y_1_c;
          Y_reg_2_s  <= G_s*C_Y_2_c;
          Y_reg_3_s  <= B_s*C_Y_3_c;
      
          Cb_reg_1_s <= R_s*C_Cb_1_c;
          Cb_reg_2_s <= G_s*C_Cb_2_c;
          Cb_reg_3_s <= B_s*C_Cb_3_c;
      
          Cr_reg_1_s <= R_s*C_Cr_1_c;
          Cr_reg_2_s <= G_s*C_Cr_2_c;
          Cr_reg_3_s <= B_s*C_Cr_3_c;
      
          Y_reg_s  <= Y_reg_1_s + Y_reg_2_s + Y_reg_3_s;
          Cb_reg_s <= Cb_reg_1_s + Cb_reg_2_s + Cb_reg_3_s + to_signed(128*16384,Cb_reg_s'length);
          Cr_reg_s <= Cr_reg_1_s + Cr_reg_2_s + Cr_reg_3_s + to_signed(128*16384,Cr_reg_s'length);
          
          
          else
          ready_o <= '1';
          end if;

    end if;
  end process;

  Y_o  <= std_logic_vector(Y_reg_s(21 downto 14));
  Cb_o <= std_logic_vector(Cb_reg_s(21 downto 14));
  Cr_o <= std_logic_vector(Cr_reg_s(21 downto 14));
  
  
  ----------------------------------
end architecture RTL;
-------------------------------------------------------------------------------
-- Architecture: end
-------------------------------------------------------------------------------