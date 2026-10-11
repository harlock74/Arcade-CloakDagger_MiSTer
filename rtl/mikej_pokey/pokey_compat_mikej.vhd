-- Original Cloak adapter: GPL-3.0-or-later; upstream POKEY terms stay intact.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pokey_compat_mikej is
generic(CLOCKS_PER_POKEY : positive := 16);
port (
    clk, reset, ce_1m25, cs, we : in std_logic;
    addr : in std_logic_vector(3 downto 0);
    din, allpot : in std_logic_vector(7 downto 0);
    dout : out std_logic_vector(7 downto 0);
    audio : out std_logic_vector(15 downto 0)
);
end entity;
architecture rtl of pokey_compat_mikej is
    signal chip_dout : std_logic_vector(7 downto 0);
    signal chip_audio : signed(5 downto 0);
    signal select_bus : std_logic;
    signal read_not_write : std_logic;
begin
    -- CS represents accepted CPU write strobe, not the POKEY audio CE.
    -- Readback stays combinational even between CPU enables (accepted interface).
    select_bus <= cs when we='1' else '1';
    read_not_write <= not we;
    chip : entity work.MIKEJ_POKEY generic map(CLOCKS_PER_POKEY=>CLOCKS_PER_POKEY) port map (
        RESET_EXT=>reset, ADDR=>addr, DIN=>din, DOUT=>chip_dout,
        DOUT_OE_L=>open, RW_L=>read_not_write, CS=>select_bus, CS_L=>'0',
        AUDIO_OUT=>chip_audio, PIN=>x"FF", ENA=>ce_1m25, CLK=>clk
    );
    dout <= allpot when addr=x"8" else chip_dout;
    audio <= std_logic_vector(to_unsigned((to_integer(chip_audio)+32)*1024,16));
end architecture;
