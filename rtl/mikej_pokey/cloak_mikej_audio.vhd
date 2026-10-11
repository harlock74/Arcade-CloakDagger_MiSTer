-- Experimental board audio boundary, original owner contributions GPL-3.0-or-later.
-- Decoder/start bit ordering and mixer scaling taken from accepted cloak_core.sv.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity cloak_mikej_audio is
generic(CLOCKS_PER_POKEY : positive := 16);
port (
    clk, reset, ce_main, ce_pokey, cpu_we : in std_logic;
    cpu_addr : in std_logic_vector(15 downto 0);
    cpu_din, dips : in std_logic_vector(7 downto 0);
    start1, start2 : in std_logic;
    cpu_dout : out std_logic_vector(7 downto 0);
    audio1, audio2, mono : out std_logic_vector(15 downto 0)
);
end entity;
architecture rtl of cloak_mikej_audio is
    signal cs1, cs2 : std_logic;
    signal d1, d2, starts : std_logic_vector(7 downto 0);
    signal a1, a2 : std_logic_vector(15 downto 0);
    signal mix : unsigned(16 downto 0);
begin
    cs1 <= ce_main when cpu_addr(15 downto 4)=x"100" else '0';
    cs2 <= ce_main when cpu_addr(15 downto 4)=x"180" else '0';
    starts <= start1 & start2 & "111111";
    p1 : entity work.pokey_compat_mikej generic map(CLOCKS_PER_POKEY=>CLOCKS_PER_POKEY) port map (
        clk,reset,ce_pokey,cs1,cpu_we,cpu_addr(3 downto 0),cpu_din,starts,d1,a1);
    p2 : entity work.pokey_compat_mikej generic map(CLOCKS_PER_POKEY=>CLOCKS_PER_POKEY) port map (
        clk,reset,ce_pokey,cs2,cpu_we,cpu_addr(3 downto 0),cpu_din,dips,d2,a2);
    cpu_dout <= d1 when cpu_addr(15 downto 4)=x"100" else
                d2 when cpu_addr(15 downto 4)=x"180" else x"FF";
    audio1 <= a1; audio2 <= a2;
    mix <= resize(unsigned(a1),17)+resize(unsigned(a2),17);
    mono <= std_logic_vector(mix(16 downto 1));
end architecture;
