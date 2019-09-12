--------------------------------------------------------------------------
-- Design unit: Data path                                               --
-- Description: Data Path of SquareRoot Project Based on the Logisim    --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 03/09/18                                                       --
-- Update: 04/09/18                                                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.ControlPath_pkg.all;

entity DataPath is
    port (

        clk             :in std_logic;
        rst             :in std_logic;
        data_in         :in std_logic_vector(15 downto 0);

        -- Control path interface
        uins            : in  control_signals;               -- Control path record (control signals)
        root            : out std_logic_vector(7 downto 0);
        less_than       : out std_logic;
        go_fw           : out std_logic;
        ready           : out std_logic

    );
end DataPath;    

architecture structural of DataPath is

    ----------------------------------------------
    -- Internal nets to interconnect components --
    ----------------------------------------------
    
    signal  result_a1, mux_root_q, root_q, zero, const_one, const_half_root: std_logic_vector(7 downto 0);

    signal  square_q, mux_square_q, r_s_ext, result_a2, input_q, const_four, const_half_squa, zero_16bits: std_logic_vector(15 downto 0);

    signal carry_in, d_ready, q_ready, rst_n, go_fw_s : std_logic;

    begin

carry_in <= '1';       
zero <= x"00";
zero_16bits <= x"0000";
const_one <= "00000001"; 
const_four <= x"0004";
const_half_root <= x"80";
const_half_squa <= x"4101";
rst_n <= not rst;

------------------------------------------------------------------------------------------------
        -- INSTANCE OF ADDER ONE 
    ADDER_ONE: entity work.Adder(dataflow)
    generic map(
        ADDER_WIDTH      => 8
    )
    port map(
        input0       => root_q,
        input1       => zero,
        carry_in     => carry_in,
        result       => result_a1 
    );

----------------------------------------------------------------------------------------------
    -- INSTANCE OF ADDER TWO 
    ADDER_TWO: entity work.Adder(dataflow)
    generic map(
        ADDER_WIDTH      => 16
    )
    port map(
        input0       => square_q,
        input1       => r_s_ext,
        carry_in     => carry_in, 
        result       => result_a2 
    );

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER input_q
    input_REG: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_input,
        datain       => data_in, 
        dataout      => input_q
    );    

----------------------------------------------------------------------------------------------
    -- INSTANCE OF REGISTER ROOT
    ROOT_REG: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 8
    )
    port map(
        clock        => clk,
        enable       => uins.en_ro_sq,
        datain       => mux_root_q, 
        dataout      => root_q 
    );    

---------------------------------------------------------------------------------------------
        -- EMULATTE SUM
    r_s_ext <= "0000000" & root_q & '0';
----------------------------------------------------------------------------------------------

    -- INSTANCE OF REGISTER SQUARE
    SQUARE_REG: entity work.gen_Reg(structure)
    generic map(
        REG_WIDTH      => 16
    )
    port map(
        clock        => clk,
        enable       => uins.en_ro_sq,
        datain       => mux_square_q, 
        dataout      => square_q 
    );    


----------------------------------------------------------------------------------------------
    -- INSTANCE OF FF READY
    READY_FF: entity work.dffa_R(behaviour)
    port map(
        clock        => clk,
        enable       => uins.ready,
        reset        => rst_n,
        d            => d_ready, 
        q            => q_ready 
    );    

    d_ready <= '1';

---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX ROOT
    MUX_ROOT: entity work.multiplexador(arch1)
    generic map(
        MUX_WIDTH      => 8
    )
    port map(
        i0        => const_one,
        i1        => const_half_root,
        i2        => result_a1,
        i3        => zero,
        sel       => uins.sel_i, 
        q         => mux_root_q 
    );    

    ---------------------------------------------------------------------------------------------
    -- INSTANCE OF MUX SQUARE
    MUX_SQUARE: entity work.multiplexador(arch1)
    generic map(
        MUX_WIDTH      => 16
    )
    port map(
        i0        => const_four,
        i1        => const_half_squa,
        i2        => result_a2,
        i3        => zero_16bits,
        sel       => uins.sel_i, 
        q         => mux_square_q 
    );    

---------------------------------------------------------------------------------------------
    -- INSTANCE OF COMPARE

    COMPARE: entity work.Comparator16bits(structural)
    port map(
        A                => input_q,
        B                => result_a2,
        AltB             => less_than 
    );    

---------------------------------------------------------------------------------------------
    -- INSTANCE OF GO FORWARD
    go_fw_s <= input_q(15) or input_q(14);

    --Output of DataPath
    root <= root_q;
    ready <= q_ready;
    go_fw <= go_fw_s;

end structural;        