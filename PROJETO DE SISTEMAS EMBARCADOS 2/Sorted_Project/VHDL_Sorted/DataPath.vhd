--------------------------------------------------------------------------
-- Design unit: Data path                                               --
-- Description: Data Path of Sorted Project Based on the Logisim        --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 22/10/18                                                       --
-- Update: --/--/18                                                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.DataPath_pkg.all;
use work.ControlPath_pkg.all;


entity DataPath is
    port (

        clk             :in std_logic;
        rst             :in std_logic;

        v_0             :in std_logic_vector(15 downto 0);
        v_1             :in std_logic_vector(15 downto 0);
        v_2             :in std_logic_vector(15 downto 0);
        v_3             :in std_logic_vector(15 downto 0);
        v_4             :in std_logic_vector(15 downto 0);
        v_5             :in std_logic_vector(15 downto 0);
        v_6             :in std_logic_vector(15 downto 0);
        v_7             :in std_logic_vector(15 downto 0);
        v_8             :in std_logic_vector(15 downto 0);
        v_9             :in std_logic_vector(15 downto 0);

        R_0             :out std_logic_vector(15 downto 0);
        R_1             :out std_logic_vector(15 downto 0);
        R_2             :out std_logic_vector(15 downto 0);
        R_3             :out std_logic_vector(15 downto 0);
        R_4             :out std_logic_vector(15 downto 0);
        R_5             :out std_logic_vector(15 downto 0);
        R_6             :out std_logic_vector(15 downto 0);
        R_7             :out std_logic_vector(15 downto 0);
        R_8             :out std_logic_vector(15 downto 0);
        R_9             :out std_logic_vector(15 downto 0);

        -- Control path interface
        uins            : in  control_signals;               -- Control path record (control signals)
        -- Data path interface
        uins_o          : out  data_signals               -- Data path record (data signals)

    );
end DataPath;    

architecture structural of DataPath is

    ----------------------------------------------
    -- Internal nets to interconnect components --
    ----------------------------------------------
    --outputs regs    
    signal  reg0_q, reg1_q, reg2_q, reg3_q, reg4_q, reg5_q, reg6_q, reg7_q, reg8_q, reg9_q: std_logic_vector(15 downto 0);

    --input regs
    signal mux_0_q, mux_1_q, mux_2_q, mux_3_q, mux_4_q, mux_5_q, mux_6_q, mux_7_q, mux_8_q, mux_9_q : std_logic_vector(15 downto 0);

    -- input compares
    signal mux_c_0, mux_c_1, mux_c_2, mux_c_3 : std_logic_vector(15 downto 0);

    -- output compares
    signal ltA, ltB, ltC, ltD, ltE: std_logic;
    signal eqA, eqB, eqC, eqD, eqE: std_logic;

    begin

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER ZERO
    REG_ZERO: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_0,
        datain       => mux_0_q, 
        dataout      => reg0_q
    );    

----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER ONE
    REG_ONE: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_1,
        datain       => mux_1_q, 
        dataout      => reg1_q
    );    

----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER TWO
    REG_TWO: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_2,
        datain       => mux_2_q, 
        dataout      => reg2_q
    );    

----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER THREE
    REG_THREE: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_3,
        datain       => mux_3_q, 
        dataout      => reg3_q
    );    

----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER FOUR
    REG_FOUR: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_4,
        datain       => mux_4_q, 
        dataout      => reg4_q
    );    

----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER FIVE
    REG_FIVE: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_5,
        datain       => mux_5_q, 
        dataout      => reg5_q
    );    

----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER SIX
    REG_SIX: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_6,
        datain       => mux_6_q, 
        dataout      => reg6_q
    );    

----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER SEVEN
    REG_SEVEN: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_7,
        datain       => mux_7_q, 
        dataout      => reg7_q
    );    

----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER EIGHT
    REG_EIGHT: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_8,
        datain       => mux_8_q, 
        dataout      => reg8_q
    );    

----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER NINE
    REG_NINE: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_9,
        datain       => mux_9_q, 
        dataout      => reg9_q
    );    

----------------------------------------------------------------------------------------------
    
---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX ZERO
    MUX_ZERO: entity work.multiplexador_2_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => v_0,
        i1        => reg1_q,
        sel       => uins.sel_0, 
        q         => mux_0_q 
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX ONE
    MUX_ONE: entity work.multiplexador_4_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => v_1,
        i1        => reg0_q,
        i2        => reg2_q,
        sel       => uins.sel_1, 
        q         => mux_1_q 
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX TWO
    MUX_TWO: entity work.multiplexador_4_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => v_2,
        i1        => reg1_q,
        i2        => reg3_q,
        sel       => uins.sel_2, 
        q         => mux_2_q 
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX THREE
    MUX_THREE: entity work.multiplexador_4_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => v_3,
        i1        => reg2_q,
        i2        => reg4_q,
        sel       => uins.sel_3, 
        q         => mux_3_q 
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX FOUR
    MUX_FOUR: entity work.multiplexador_4_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => v_4,
        i1        => reg3_q,
        i2        => reg5_q,
        sel       => uins.sel_4, 
        q         => mux_4_q 
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX FIVE
    MUX_FIVE: entity work.multiplexador_4_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => v_5,
        i1        => reg4_q,
        i2        => reg6_q,
        sel       => uins.sel_5, 
        q         => mux_5_q 
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX SIX
    MUX_SIX: entity work.multiplexador_4_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => v_6,
        i1        => reg5_q,
        i2        => reg7_q,
        sel       => uins.sel_6, 
        q         => mux_6_q 
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX SEVEN
    MUX_SEVEN: entity work.multiplexador_4_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => v_7,
        i1        => reg6_q,
        i2        => reg8_q,
        sel       => uins.sel_7, 
        q         => mux_7_q 
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX EIGHT
    MUX_EIGHT: entity work.multiplexador_4_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => v_8,
        i1        => reg7_q,
        i2        => reg9_q,
        sel       => uins.sel_8, 
        q         => mux_8_q 
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX NINE
    MUX_NINE: entity work.multiplexador_2_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => v_9,
        i1        => reg8_q,
        sel       => uins.sel_9, 
        q         => mux_9_q 
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX COMPARE ZERO
    MUX_C_ZERO: entity work.multiplexador_2_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => reg0_q,
        i1        => reg2_q,
        sel       => uins.even, 
        q         => mux_c_0
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX COMPARE ONE
    MUX_C_ONE: entity work.multiplexador_2_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => reg2_q,
        i1        => reg4_q,
        sel       => uins.even, 
        q         => mux_c_1
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX COMPARE TWO
    MUX_C_TWO: entity work.multiplexador_2_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => reg4_q,
        i1        => reg6_q,
        sel       => uins.even, 
        q         => mux_c_2
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX COMPARE THREE
    MUX_C_THREE: entity work.multiplexador_2_1(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => reg6_q,
        i1        => reg8_q,
        sel       => uins.even, 
        q         => mux_c_3
    );    

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
    -- INSTANCE OF COMPARE ZERO

    CMP_ZERO: entity work.compare_beh(behavioral)
    port map(
        A                => reg1_q,
        B                => mux_c_0,
        AeqB             => eqA,
        AltB             => ltA
    );    
---------------------------------------------------------------------------------------------
uins_o.BltA_A <= ltA nor eqA;
uins_o.equal_A <= eqA;
uins_o.less_than_A <= ltA;
---------------------------------------------------------------------------------------------
    -- INSTANCE OF COMPARE ONE

    CMP_ONE: entity work.compare_beh(behavioral)
    port map(
        A                => reg3_q,
        B                => mux_c_1,
        AeqB             => eqB,
        AltB             => ltB
    );    
---------------------------------------------------------------------------------------------
uins_o.BltA_B <= ltB nor eqB;
uins_o.equal_B <= eqB;
uins_o.less_than_B <= ltB;
---------------------------------------------------------------------------------------------
    -- INSTANCE OF COMPARE TWO

    CMP_TWO: entity work.compare_beh(behavioral)
    port map(
        A                => reg5_q,
        B                => mux_c_2,
        AeqB             => eqC,
        AltB             => ltC
    );    
---------------------------------------------------------------------------------------------
uins_o.BltA_C <= ltC nor eqC;
uins_o.equal_C <= eqC;
uins_o.less_than_C <= ltC;
---------------------------------------------------------------------------------------------
    -- INSTANCE OF COMPARE THREE

    CMP_THREE: entity work.compare_beh(behavioral)
    port map(
        A                => reg7_q,
        B                => mux_c_3,
        AeqB             => eqD,
        AltB             => ltD
    );    
---------------------------------------------------------------------------------------------
uins_o.BltA_D <= ltD nor eqD;
uins_o.equal_D <= eqD;
uins_o.less_than_D <= ltD;
---------------------------------------------------------------------------------------------
    -- INSTANCE OF COMPARE FOUR

    CMP_FOUR: entity work.compare_beh(behavioral)
    port map(
        A                => reg8_q,
        B                => reg9_q,
        AeqB             => eqE,
        AltB             => ltE
    );    
---------------------------------------------------------------------------------------------
uins_o.BltA_E <= ltE nor eqE;
uins_o.equal_E <= eqE;
uins_o.less_than_E <= ltE;

---------------------------------------------------------------------------------------------
R_0 <= reg0_q;
R_1 <= reg1_q;
R_2 <= reg2_q;
R_3 <= reg3_q;
R_4 <= reg4_q;
R_5 <= reg5_q;
R_6 <= reg6_q;
R_7 <= reg7_q;
R_8 <= reg8_q;
R_9 <= reg9_q;



end structural;        