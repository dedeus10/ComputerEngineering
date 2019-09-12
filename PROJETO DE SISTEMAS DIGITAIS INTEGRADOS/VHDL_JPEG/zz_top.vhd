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
-- File        : zz_top.vhd                                                   --
-- Created     : Friday, 08/12/18                                             --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Description : Zig-Zag TOP entity                                          --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

--library work;
  --use work.JPEG_PKG.all;

entity zz_top is
  port 
  (
        clk                : in  std_logic;
        rst                : in  std_logic;
        -- CTRL
        start_pb_i           : in  std_logic;
        ready_pb_o           : out std_logic;
        
        -- Quantizer
        qua_buf_sel_i        : in  std_logic;
        qua_rdaddr_i         : in  std_logic_vector(5 downto 0);
        qua_data_o           : out std_logic_vector(11 downto 0);
        
        -- FDCT
        fdct_buf_sel_o       : out std_logic;
        fdct_rd_addr_o       : out std_logic_vector(5 downto 0);
        fdct_data_i          : in  std_logic_vector(11 downto 0);
        fdct_rden_o          : out std_logic;
		
		    -- RAMZ
		    dbuf_data_o    	   : out std_logic_vector(11 downto 0);
		    dbuf_q_i        	   : in  std_logic_vector(11 downto 0);
		    dbuf_we_o      	   : out std_logic;
		    dbuf_waddr_o    	   : out std_logic_vector(6 downto 0);
		    dbuf_raddr_o     	   : out std_logic_vector(6 downto 0)
    );
end entity zz_top;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
----------------------------------- ARCHITECTURE ------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
architecture RTL of zz_top is

  signal zigzag_di_s      : std_logic_vector(11 downto 0);
  signal zigzag_divalid_s : std_logic;
  signal zigzag_dout_s    : std_logic_vector(11 downto 0);
  signal zigzag_dovalid_s : std_logic;
  signal wr_cnt_s         : unsigned(5 downto 0);
  signal rd_cnt_s         : unsigned(5 downto 0);
  signal rd_en_d_s        : std_logic_vector(5 downto 0);
  signal rd_en_s          : std_logic;
  signal fdct_buf_sel_s : std_logic;
  signal zz_rd_addr_s     : std_logic_vector(5 downto 0);
  signal fifo_empty_s     : std_logic;
  signal fifo_rden_s      : std_logic;
  
-------------------------------------------------------------------------------
-- Architecture: begin
-------------------------------------------------------------------------------
begin
  fdct_rd_addr_o <= zz_rd_addr_s;
  qua_data_o     <= dbuf_q_i;
  fdct_buf_sel_o <= fdct_buf_sel_s;
  fdct_rden_o    <= rd_en_s;

  -------------------------------------------------------------------
  -- ZigZag Core
  -------------------------------------------------------------------
  U_zigzag : entity work.zigzag
  generic map
    ( 
      RAMADDR_W     => 6,
      RAMDATA_W     => 12
    )
  port map
    (
      rst        => rst,
      clk        => clk,
      d_i         => zigzag_di_s,
      divalid_i    => zigzag_divalid_s,
      rd_addr_i    => rd_cnt_s,
      fifo_rden_i  => fifo_rden_s,
      
      fifo_empty_o => fifo_empty_s,
      dout_o       => zigzag_dout_s,
      dovalid_o    => zigzag_dovalid_s,
      zz_rd_addr_o => zz_rd_addr_s
    );
  
  zigzag_di_s      <= fdct_data_i;
  zigzag_divalid_s <= rd_en_d_s(1);
  
  
  dbuf_data_o  <= zigzag_dout_s;
  dbuf_waddr_o <= (not qua_buf_sel_i) & std_logic_vector(wr_cnt_s);
  dbuf_we_o    <= zigzag_dovalid_s;
  dbuf_raddr_o <= qua_buf_sel_i & qua_rdaddr_i;
  
  -------------------------------------------------------------------
  -- FIFO Ctrl
  -------------------------------------------------------------------
  p_fifo_ctrl : process(clk, rst)
  begin
    if rst = '1' then
      fifo_rden_s   <= '0';
    elsif clk'event and clk = '1' then
      if fifo_empty_s = '0' then
        fifo_rden_s <= '1';
      else
        fifo_rden_s <= '0';
      end if;      
    end if;
  end process;
  
  -------------------------------------------------------------------
  -- Counter1
  -------------------------------------------------------------------
  p_counter1 : process(clk, rst)
  begin
    if rst = '1' then
      rd_en_s        <= '0';
      rd_en_d_s      <= (others => '0');
      rd_cnt_s       <= (others => '0');
    elsif clk'event and clk = '1' then
      rd_en_d_s <= rd_en_d_s(4 downto 0) & rd_en_s;
    
      if start_pb_i = '1' then
        rd_cnt_s <= (others => '0');
        rd_en_s <= '1';       
      end if;
      
      if rd_en_s = '1' then
        if rd_cnt_s = 63 then
          rd_cnt_s <= (others => '0');
          rd_en_s  <= '0';
        else
          rd_cnt_s <= rd_cnt_s + 1;
        end if;
      end if;
      
    end if;
  end process;
  
  -------------------------------------------------------------------
  -- wr_cnt_s
  -------------------------------------------------------------------
  p_wr_cnt : process(clk, rst)
  begin
    if rst = '1' then
      wr_cnt_s   <= (others => '0');
      ready_pb_o <= '0';
    elsif clk'event and clk = '1' then
      ready_pb_o <= '0';
    
      if start_pb_i = '1' then
        wr_cnt_s <= (others => '0');
      end if;
      
      if zigzag_dovalid_s = '1' then
        if wr_cnt_s = 63 then
          wr_cnt_s <= (others => '0');
        else
          wr_cnt_s <=wr_cnt_s + 1;
        end if;
        
        -- give ready ahead to save cycles!
        if wr_cnt_s = 60 then
          ready_pb_o <= '1';
        end if;
        
      end if;
    end if;
  end process;
  
  -------------------------------------------------------------------
  -- fdct_buf_sel_o
  -------------------------------------------------------------------
  p_buf_sel : process(clk, rst)
  begin
    if rst = '1' then
      fdct_buf_sel_s   <= '0'; 
    elsif clk'event and clk = '1' then
      if start_pb_i = '1' then
        fdct_buf_sel_s <= not fdct_buf_sel_s;
      end if;
    end if;
  end process;

end architecture RTL;
-------------------------------------------------------------------------------
-- Architecture: end
-------------------------------------------------------------------------------