--------------------------------------------------------------------------------
--                                                                            --
--                          V H D L    F I L E                                --
--                 FEDERAL UNIVERSITY OF SANTA MARIA (UFSM)                   --
--                   PROJECT OF INTEGRATED DIGITAL SYSTEMS                    --
--------------------------------------------------------------------------------
--                                                                            --
-- Title       : ZIGZAG                                                       --
-- Design      : Implementation ASIC for JPEG Compressor                      --
-- Author's    : Luis Felipe de Deus | Nathanel Luchetta | Tiago Knorst       --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
-- File        : zigzag.vhd                                                   --
-- Created     : Friday, 08/12/18                                             --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Description : Zig-Zag scan                                                --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.All;
  use ieee.numeric_std.all;
  
entity zigzag is
  generic 
    ( 
      RAMADDR_W     : integer := 6;
      RAMDATA_W     : integer := 12
    );
  port
    (
      rst        : in  std_logic;
      clk        : in  std_logic;
      d_i         : in  std_logic_vector(RAMDATA_W-1 downto 0);
      divalid_i    : in  std_logic;
      rd_addr_i    : in  unsigned(5 downto 0);
      fifo_rden_i  : in  std_logic;
      
      fifo_empty_o : out std_logic;
      dout_o       : out std_logic_vector(RAMDATA_W-1 downto 0);
      dovalid_o    : out std_logic;
      zz_rd_addr_o : out std_logic_vector(5 downto 0)
    );
end zigzag;

architecture rtl of zigzag is
  
  type ZIGZAG_TYPE is   array (0 to 2**RAMADDR_W-1) of integer range 0 to 2**RAMADDR_W-1;
  constant ZIGZAG_ARRAY : ZIGZAG_TYPE := 
                      (
                       0,1,8,16,9,2,3,10, 
                       17,24,32,25,18,11,4,5,
                       12,19,26,33,40,48,41,34,
                       27,20,13,6,7,14,21,28,
                       35,42,49,56,57,50,43,36,
                       29,22,15,23,30,37,44,51,
                       58,59,52,45,38,31,39,46,
                       53,60,61,54,47,55,62,63
                      ); 
  
  signal fifo_wr_s      : std_logic;
  signal fifo_q_s       : std_logic_vector(11 downto 0);
  signal fifo_full_s    : std_logic;
  signal fifo_count_s   : std_logic_vector(6 downto 0);
  signal fifo_data_in_s : std_logic_vector(11 downto 0);
  signal fifo_empty_s : std_logic;
  
  
begin

  dout_o <= fifo_q_s;
  fifo_empty_o <= fifo_empty_s;

  -------------------------------------------------------------------
  -- FIFO (show ahead)
  -------------------------------------------------------------------
  U_FIFO : entity work.FIFO   
  generic map
  (
        DATA_WIDTH        => 12,
        ADDR_WIDTH        => 6
  )
  port map 
  (        
        rst               => RST,
        clk               => CLK,
        rinc              => fifo_rden_i,
        winc              => fifo_wr_s,
        datai             => fifo_data_in_s,

        datao             => fifo_q_s,
        fullo             => fifo_full_s,
        emptyo            => fifo_empty_s,
        count             => fifo_count_s
  );

  fifo_wr_s      <= divalid_i;
  fifo_data_in_s <= d_i;
  
  
  process(clk)
  begin
    if clk = '1' and clk'event then
      if rst = '1' then
        zz_rd_addr_o <= (others => '0');
        dovalid_o    <= '0';
      else
        zz_rd_addr_o <= std_logic_vector(
                      to_unsigned((ZIGZAG_ARRAY(to_integer(rd_addr_i))),6));
                      
        dovalid_o    <= fifo_rden_i and not fifo_empty_s;
      end if;
    end if;
  end process;    
  
   
end rtl;  
--------------------------------------------------------------------------------
