--
-- Copyright (c) MikeJ - May 2004
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS CODE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- You are responsible for any legal issues arising from your use of this code.
--
-- The latest version of this file can be found at: www.fpgaarcade.com
--
-- Email support@fpgaarcade.com
--
-- Revision list
--
-- version 002 return 00 on allpot when fast scan completed to fix self test
-- version 001 initial release (this version should be considered Beta
--   it seems to make all the right sort of sounds however ... )
--
-- Experimental Cloak adaptation, 2026-10-06. Original changes GPL-3.0-or-later.
-- Inherited MikeJ and subsequent upstream terms are preserved; see docs/POKEY_PROVENANCE.md.
-- Local changes and remaining limitations: docs/POKEY_PROVENANCE.md.
-- The byte-exact upstream snapshot is upstream/mikej-pokey/POKEY.vhd; this file is adapted.
library ieee;
	use ieee.std_logic_1164.all;
	-- Arithmetic uses explicit numeric_std unsigned widths (VHDL-93).
	use ieee.numeric_std.all;

-- Local timing requirements: Altirra Hardware Reference 2026-01-02, chapter 5.
-- The clock-enable interface uses 16 system clocks per POKEY clock on Cloak.
-- CLOCKS_PER_POKEY=1 is only for accelerated tests; its half-cycle uses CLK's
-- falling edge. The production default uses rising-edge registers exclusively.
entity MIKEJ_POKEY is
generic(CLOCKS_PER_POKEY : positive := 16);
port (
    RESET_EXT : in std_logic; -- deterministic FPGA reset; distinct from SKCTL init
	ADDR      : in  std_logic_vector(3 downto 0);
	DIN       : in  std_logic_vector(7 downto 0);
	DOUT      : out std_logic_vector(7 downto 0);
	DOUT_OE_L : out std_logic;
	RW_L      : in  std_logic;
	CS        : in  std_logic; -- used as enable
	CS_L      : in  std_logic;
	--
	AUDIO_OUT : out signed(5 downto 0);
	--
	PIN       : in  std_logic_vector(7 downto 0);
	ENA       : in  std_logic;
	CLK       : in  std_logic  -- note 6 Mhz
);
end;

architecture RTL of MIKEJ_POKEY is
	type  array_8x8   is array (0 to 7) of std_logic_vector(7 downto 0);
	type  array_4x8   is array (1 to 4) of std_logic_vector(7 downto 0);
	type  array_4x4   is array (1 to 4) of std_logic_vector(3 downto 0);
	type  array_4x9   is array (1 to 4) of std_logic_vector(8 downto 0);
	type  array_2x17  is array (1 to 2) of std_logic_vector(16 downto 0);
	type  bool_4      is array (1 to 4) of boolean;

	signal we                   : std_logic;
	signal oe                   : std_logic;
	--
	signal ena_64k_15k          : std_logic;
	signal cnt_64k              : std_logic_vector(4 downto 0) := (others => '0');
	signal ena_64k              : std_logic;
	signal cnt_15k              : std_logic_vector(6 downto 0) := (others => '0');
	signal ena_15k              : std_logic;
	--
	signal poly4                : std_logic_vector(3 downto 0)  := "0000";              -- hardware sequence start
	signal poly5                : std_logic_vector(4 downto 0)  := "00000";             -- hardware sequence start
	signal poly9                : std_logic_vector(8 downto 0)  := "111111111";         -- XOR feedback: MUST be non-zero
	signal poly17               : std_logic_vector(16 downto 0) := "11111111111111111"; -- XOR feedback: MUST be non-zero
	signal poly_17_9            : std_logic;

	-- registers
	signal audf                 : array_4x8 := (others => (others => '0'));
	signal audc                 : array_4x8 := (others => (others => '0'));
	signal audctl               : std_logic_vector(7 downto 0) := (others => '0');
	signal stimer_reload : std_logic;
	signal stimer               : std_logic_vector(7 downto 0);
	signal skres                : std_logic_vector(7 downto 0);
	signal potgo                : std_logic;
	signal serout               : std_logic_vector(7 downto 0);
	signal irqen                : std_logic_vector(7 downto 0);
	signal skctls               : std_logic_vector(7 downto 0);
	signal reset                : std_logic;
	--
	signal kbcode               : std_logic_vector(7 downto 0);
	signal random               : std_logic_vector(7 downto 0);
	signal serin                : std_logic_vector(7 downto 0);
	signal irqst                : std_logic_vector(7 downto 0);
	signal skstat               : std_logic_vector(7 downto 0);
	--
	signal pot_fin              : std_logic;
	signal pot_cnt              : std_logic_vector(7 downto 0);
	signal pot_val              : array_8x8;
	signal pin_reg              : std_logic_vector(7 downto 0);
	signal pin_reg_gated        : std_logic_vector(7 downto 0);
	--
	signal chan_ena             : std_logic_vector(4 downto 1);
	signal tone_gen_div         : std_logic_vector(4 downto 1);
	-- Observation-only nets: explicit loads are distinct from timer pulses and audio/IRQ.
    signal qualification_reload : std_logic_vector(4 downto 1) := (others=>'0');
    signal qualification_counts : std_logic_vector(31 downto 0);
	signal tone_gen_cnt         : array_4x8 := (others => (others => '0'));
	signal tone_gen_div_mux     : std_logic_vector(4 downto 1);
	signal tone_gen_zero        : std_logic_vector(4 downto 1);
	signal tone_gen_zero_t      : array_4x8 := (others => (others => '0'));
	signal chan_done_load       : std_logic_vector(4 downto 1) := (others => '0');
	--
	-- Channel output flip-flop, split the way the real chip splits it (see p_poly_gating):
	--   audio_clock  = the CLOCK into the FF   (timer pulse, optionally gated by poly5)
	--   audio_sample = the DATA into the FF    (poly4, or the 17/9-bit poly)
	signal audio_clock          : std_logic_vector(4 downto 1);
	signal audio_sample         : std_logic_vector(4 downto 1);
	signal tone_gen_final       : std_logic_vector(4 downto 1) := (others => '0');
	-- High-pass capture FFs (channels 1 and 2 only -- 3 and 4 have no high-pass).
	signal hp_sample : std_logic_vector(2 downto 1) := (others=>'1');
	signal hp_capture           : std_logic_vector(2 downto 1) := (others => '0');
	-- With the high-pass DISABLED, does the capture FF hold 1 (channels 1/2 come out INVERTED -- what
	-- MAME `pokey.cpp` and Videodr0me's Major Havoc core both do) or 0 (pass-through)? Left at
	-- the reference behaviour; see p_audio_out. Kept as a named constant because the choice is
	-- subtle. Measured: toggling it changes NOTHING about POKEY's DC on a continuously clocked
	-- channel (inverting is then a pure phase flip); it could only matter for a channel PARKED
	-- with non-zero volume.
	constant POKEY_HP_INVERT_WHEN_OFF : boolean := true;
    signal tx_busy, tx_ready, tx_clock, tx_data, fsk_level : std_logic := '0';
    signal tx_waiting : std_logic := '0';
    signal tx_bits : integer range 0 to 10 := 0;
    signal tx_shift : std_logic_vector(9 downto 0) := (others=>'1');
    signal fsk_trigger : std_logic;
    signal fsk_reload : std_logic := '0';
	-- Post-high-pass channel state -- this, NOT tone_gen_final, is what the mixer sees.
	signal channel_output       : std_logic_vector(4 downto 1);
	--
	-- The shared polynomial generators reach the four audio
	-- channels PHASE-STAGGERED -- channel 1 sees the current bit, channels 2/3/4
	-- see it delayed by 1/2/3 POKEY clocks. Modelling all four from the same bit
	-- on the same cycle is subtly wrong, so keep 4 stages of history per polynomial.
	signal poly4_hist           : std_logic_vector(3 downto 0) := (others => '0');
	signal poly5_hist           : std_logic_vector(3 downto 0) := (others => '0');
	signal poly917_hist         : std_logic_vector(3 downto 0) := (others => '0');
begin
    qualification_counts <= tone_gen_cnt(4) & tone_gen_cnt(3) & tone_gen_cnt(2) & tone_gen_cnt(1);
    poly9 <= poly17(16 downto 8);

	p_we : process(RW_L, CS_L, CS)
	begin
		we <= (not CS_L) and CS and (not RW_L);
	end process;

	p_oe : process(RW_L, CS_L, CS)
	begin
		oe <= (not CS_L) and CS and RW_L;
	end process;
	DOUT_OE_L <= not oe;

	p_ipreg : process
	begin
		wait until rising_edge(CLK);
		pin_reg <= PIN;
	end process;

    p_dividers : process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET_EXT='1' or reset='1' then
                cnt_64k <= std_logic_vector(to_unsigned(18,5));
                cnt_15k <= std_logic_vector(to_unsigned(77,7));
                ena_64k <= '0'; ena_15k <= '0';
            elsif ENA='1' then
                ena_64k <= '0'; ena_15k <= '0';
                if unsigned(cnt_64k)=0 then cnt_64k <= "11011"; ena_64k <= '1';
                else cnt_64k <= std_logic_vector(unsigned(cnt_64k) - 1); end if;
                if unsigned(cnt_15k)=0 then cnt_15k <= "1110001"; ena_15k <= '1';
                else cnt_15k <= std_logic_vector(unsigned(cnt_15k) - 1); end if;
            end if;
        end if;
    end process;

	p_ena_64k_15k : process(ena_64k, ena_15k, audctl)
	begin
		if (audctl(0) = '1') then
			ena_64k_15k <= ena_15k;
		else
			ena_64k_15k <= ena_64k;
		end if;
	end process;

	-- POLYNOMIAL GENERATORS -- three corrections vs the original file.
	--
	-- Found by comparing against Videodr0me's Arcade-Tempest_MiSTer `rtl/pokey.vhd` (GPL-2.0), which
	-- is the SAME MikeJ/FPGAArcade lineage as this file but carries fixes this copy never got. All
	-- three feed the AUDC distortion selects, so they affect every noise-based effect -- which is
	-- most of Paperboy's SFX.
	--
	--  1. poly5 was CROSS-COUPLED TO poly4: `not (poly5(4) xor poly4(2))` tapped bit 2 of a
	--     DIFFERENT register, so it was not a 5-bit LFSR at all and had no maximal-length period.
	--     Unambiguous bug under any bit-order convention. Now `poly5(2)`.
	--  2. poly9 was wrong and the original file said so -- there was a literal `-- not correct` comment
	--     above it. Replaced with the hardware sequence (shift right, taps 0 and 5).
	--  3. poly17 used a plain left shift with taps 16/2; the real chip has a SPLIT path where the
	--     feedback lands in the middle of the register (bit 7 = bit 8 xor bit 13), not at the end.
	--
	-- NOTE ON BIT ORDER: poly9/poly17 now shift RIGHT where they used to shift left, so the output
	-- taps moved with them -- see p_random_mux below. Getting only half of that right would just
	-- have traded one wrong sequence for another. poly4/poly5 keep their existing top-bit output
	-- taps: the shift expressions are identical to Tempest's, only the tapped bit differs, which is
	-- a 3-clock phase offset -- and per-channel phase is modelled separately by poly*_hist.
	--
    -- FPGA adaptation: XOR 9/17 registers represent inverted noise; seed all ones.
    -- RANDOM sees that representation, audio sees its complement. 4/5 start zero.
    -- Complemented hardware shift-register representation. Initialisation forces
    -- serial input bits, not the entire state: short SKCTL pulses retain history.
    -- Long init settles top nine bits to 1 and bottom eight bits to 0.
    p_poly : process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET_EXT='1' then
                poly4 <= "0000"; poly5 <= "00000";
                poly17 <= "11111111100000000";
            elsif ENA='1' then
                if reset='1' then
                    poly4 <= poly4(2 downto 0) & '0';
                    poly5 <= poly5(3 downto 0) & '0';
                    poly17(16) <= '1';
                else
                    poly4 <= poly4(2 downto 0) & not(poly4(3) xor poly4(2));
                    poly5 <= poly5(3 downto 0) & not(poly5(4) xor poly5(2));
                    if audctl(7)='1' then poly17(16) <= poly17(8) xor poly17(13);
                    else poly17(16) <= poly17(0); end if;
                end if;
                poly17(15 downto 8) <= poly17(16 downto 9);
                poly17(7) <= poly17(8) xor poly17(13);
                poly17(6 downto 0) <= poly17(7 downto 1);
            end if;
        end if;
    end process;

	-- Output taps MUST match the shift direction chosen in p_poly. poly9/poly17 now shift right, so
	-- the readable window and the noise tap come off the LOW end, exactly as in the Tempest core.
	-- (Paperboy's sound ROM never reads RANDOM -- the only reference to $180a in the whole ROM is a
	-- `dec $180a` at $ef4c, which is data disassembled as code -- so the readable-window change is
	-- software-invisible here. It still has to be consistent, because poly_17_9 drives the noise.)
	p_random_mux : process(audctl, poly9, poly17)
	begin
		if (audctl(7) = '1') then          -- 9-bit poly selected
			random    <= poly17(15 downto 8);
			poly_17_9 <= not poly9(0);
		else
			random    <= poly17(15 downto 8);
			poly_17_9 <= not poly17(8);
		end if;
	end process;

    p_wdata : process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET_EXT='1' then
                audf <= (others => (others => '0'));
                audc <= (others => (others => '0'));
                audctl <= x"00"; skctls <= x"00"; irqen <= x"00";
                stimer <= x"00"; skres <= x"00"; serout <= x"00";
                potgo <= '0';
            else
                potgo <= '0';
                if we='1' then
                    case ADDR is
                        when x"0" => audf(1) <= DIN;
                        when x"1" => audc(1) <= DIN;
                        when x"2" => audf(2) <= DIN;
                        when x"3" => audc(2) <= DIN;
                        when x"4" => audf(3) <= DIN;
                        when x"5" => audc(3) <= DIN;
                        when x"6" => audf(4) <= DIN;
                        when x"7" => audc(4) <= DIN;
                        when x"8" => audctl <= DIN;
                        when x"9" => stimer <= DIN;
                        when x"A" => skres <= DIN;
                        when x"B" => potgo <= '1';
                        when x"D" => serout <= DIN;
                        when x"E" => irqen <= DIN;
                        when x"F" => skctls <= DIN;
                        when others => null;
                    end case;
                end if;
            end if;
        end if;
    end process;

	p_reset : process(skctls)
	begin
		-- chip in reset if bits 1..0 of skctls are both zero
		reset <= '0';
		if (skctls(1 downto 0) = "00") then
			reset <= '1';
		end if;
	end process;

	p_rdata : process(oe, ADDR, pot_val, pin_reg_gated, kbcode, random, serin, irqst, skstat)
	begin
		DOUT <= x"00";
		if (oe = '1') then -- keep things quiet
			case ADDR IS
				when x"0" => DOUT <= pot_val(0);   -- pot 0
				when x"1" => DOUT <= pot_val(1);   -- pot 1
				when x"2" => DOUT <= pot_val(2);   -- pot 2
				when x"3" => DOUT <= pot_val(3);   -- pot 3
				when x"4" => DOUT <= pot_val(4);   -- pot 4
				when x"5" => DOUT <= pot_val(5);   -- pot 5
				when x"6" => DOUT <= pot_val(6);   -- pot 6
				when x"7" => DOUT <= pot_val(7);   -- pot 7
				when x"8" => DOUT <= pin_reg_gated;-- allpot
				when x"9" => DOUT <= kbcode;
				when x"A" => DOUT <= random;
				when x"B" => DOUT <= x"FF";
				when x"C" => DOUT <= x"FF";
				when x"D" => DOUT <= serin;
				when x"E" => DOUT <= irqst;
				when x"F" => DOUT <= skstat;
				when others => null;
			end case;
		end if;
	end process;

    kbcode <= x"FF"; -- no keyboard connected by Cloak adapter
    serin <= x"00"; -- deterministic FPGA reset value, no connected serial input
    skstat <= x"FF"; -- disconnected input high, no keyboard or receive activity
    p_irq : process(CLK)
        variable q : std_logic_vector(7 downto 0);
    begin
        if rising_edge(CLK) then
            if RESET_EXT='1' then irqst <= x"F7";
            else
                q := irqst;
                if ENA='1' then
                    if tone_gen_div(1)='1' and irqen(0)='1' then q(0):='0'; end if;
                    if tone_gen_div(2)='1' and irqen(1)='1' then q(1):='0'; end if;
                    if tone_gen_div(4)='1' and irqen(2)='1' then q(2):='0'; end if;
                end if;
                if we='1' and ADDR=x"E" then
                    q := q or (not DIN and x"F7");
                end if;
                if tx_ready='1' and irqen(4)='1' then q(4):='0'; end if;
                q(3):=tx_busy; -- active-low complete IRQ is live, even when masked
                irqst <= q;
            end if;
        end if;
    end process;

    -- No serial pins at this board interface: input and external clock are high.
    -- A holding byte plus a separate ten-bit shifter implements double buffering.
    -- Internal TX clocks: modes 2/3/4/5 use ch4; modes 6/7 use ch2.
    -- Modes 0/1 have no external edges. Async modes hold ch3/4 while RX is idle.
    p_serial : process(CLK)
        variable edge : boolean;
        variable source : integer range 2 to 4;
    begin
        if rising_edge(CLK) then
            tx_ready <= '0';
            if RESET_EXT='1' then
                tx_waiting<='0'; tx_busy<='0'; tx_clock<='0';
                tx_bits<=0; tx_shift<=(others=>'1'); tx_data<='1';
            else
                if ENA='1' then
                    if reset='1' then
                        tx_waiting<='0'; tx_busy<='0'; tx_bits<=0;
                    else
                        edge:=false;
                        source:=4;
                        if skctls(6 downto 5)="11" then source:=2; end if;
                        if unsigned(skctls(6 downto 4))>=2 and tone_gen_div(source)='1' then
                            edge:=tx_clock='0'; tx_clock<=not tx_clock;
                        end if;
                        if edge then
                            if tx_busy='1' and tx_bits>1 then
                                tx_shift <= '1' & tx_shift(9 downto 1);
                                tx_data <= tx_shift(1); tx_bits<=tx_bits-1;
                            elsif tx_waiting='1' then
                                tx_shift <= '1' & serout & '0'; tx_data<='0';
                                tx_bits<=10; tx_busy<='1'; tx_waiting<='0'; tx_ready<='1';
                            else
                                tx_bits<=0; tx_busy<='0'; tx_data<='1';
                            end if;
                        end if;
                    end if;
                    if skctls(6 downto 4)="000" then tx_clock<='0'; end if;
                end if;
                -- Writes run at CPU acceptance, even between audio enables.
                -- A simultaneous transfer uses the old queued byte and keeps the new one.
                if we='1' and ADDR=x"D" and reset='0' then tx_waiting<='1'; end if;
            end if;
        end if;
    end process;
    fsk_trigger <= skctls(3) and ((tone_gen_div(1) and tx_data and not skctls(7)) or tone_gen_div(2));
    p_two_tone : process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET_EXT='1' then fsk_level<='0';
            elsif ENA='1' then
                if skctls(3)='0' then fsk_level<='0';
                elsif fsk_trigger='1' then fsk_level<=not fsk_level; end if;
            end if;
        end if;
    end process;

    -- Board adapter ties all POT inputs high, matching accepted board boundary.
    -- Analogue RC paddles are outside this prototype; ALLPOT bypasses this logic.
    p_pots : process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET_EXT='1' then
                pot_cnt <= x"00"; pot_fin <= '1';
                pot_val <= (others => x"00");
            elsif potgo='1' then pot_cnt <= x"00"; pot_fin <= '0'; pot_val <= (others=>x"00");
            elsif ENA='1' and pot_fin='0' then
                if ena_15k='1' or skctls(2)='1' then
                    if pot_cnt=x"E3" then pot_fin <= '1'; end if;
                    if unsigned(pot_cnt)<228 then
                        pot_cnt <= std_logic_vector(unsigned(pot_cnt)+1);
                        pot_val <= (others => std_logic_vector(unsigned(pot_cnt)+1));
                    end if;
                end if;
            end if;
        end if;
    end process;
    pin_reg_gated <= pin_reg;

    -- Independent concurrent enables avoid a demonstrated GHDL synthesis
    -- collapse of both outputs through one temporary process variable.
    -- Native VHDL behavior is unchanged: fast clocks reach the low channel
    -- independently; the high channel follows fast only while joined.
    chan_ena(1) <= '1' when audctl(6)='1' else ena_64k_15k;
    chan_ena(2) <= '1' when audctl(6)='1' and audctl(4)='1' else ena_64k_15k;
    chan_ena(3) <= '1' when audctl(5)='1' else ena_64k_15k;
    chan_ena(4) <= '1' when audctl(5)='1' and audctl(3)='1' else ena_64k_15k;

    p_tone_generators : process(CLK)
        type delays is array(1 to 4) of integer range 0 to 3;
        variable pending : delays := (others => 0);
        variable restart : integer range 0 to 3 := 0;
        variable count : array_4x8 := (others => x"00");
        variable linked : boolean;
        variable resync : std_logic_vector(1 downto 0) := "00";
        variable lo, hi : integer;
    begin
        if rising_edge(CLK) then
            qualification_reload <= (others=>'0');
            if RESET_EXT='1' then
                pending := (others => 0); restart := 0; resync:="00"; fsk_reload<='0';
                count := (others => x"00");
                tone_gen_div <= (others => '0'); stimer_reload <= '0';
            else
                if ENA='1' then
                    tone_gen_div <= (others => '0'); stimer_reload <= '0'; fsk_reload<='0';
                    if restart>0 then
                        restart := restart-1;
                        -- In-flight underflows survive a late STIMER write. Only the
                        -- reload boundary cancels them (T+4 preempts; T+5 is too late).
                        if restart>0 then
                            for ch in 1 to 4 loop
                                if pending(ch)>0 then
                                    pending(ch):=pending(ch)-1;
                                    if pending(ch)=0 then
                                        tone_gen_div(ch)<='1'; count(ch):=audf(ch);
                                    end if;
                                end if;
                            end loop;
                        end if;
                        if restart=0 then
                            count := audf; pending := (others => 0);
                            stimer_reload <= '1'; qualification_reload <= (others=>'1');
                            -- Do not advance the joined counters here: Figure 8
                            -- places low/high IRQs at T+8/T+11, not T+7/T+10.
                        end if;
                    else
                        for pair in 0 to 1 loop
                            lo:=1+pair*2; hi:=lo+1;
                            linked := (pair=0 and audctl(4)='1') or (pair=1 and audctl(3)='1');
                            if linked then
                                -- Low channel continues its 8-bit countdown, with no autoreload.
                                if chan_ena(lo)='1' then
                                    if count(lo)=x"00" then pending(lo):=3; end if;
                                    count(lo):=std_logic_vector(unsigned(count(lo))-1);
                                end if;
                                -- High underflow follows the low-channel pulse by three ticks.
                                if pending(hi)>0 then
                                    pending(hi):=pending(hi)-1;
                                    if pending(hi)=0 then
                                        tone_gen_div(hi)<='1';
                                        count(lo):=audf(lo); count(hi):=audf(hi);
                                        qualification_reload(lo)<='1'; qualification_reload(hi)<='1';
                                    end if;
                                end if;
                                if pending(lo)>0 then
                                    -- Newly detected underflow must retain its three-cycle delay.
                                    if not (chan_ena(lo)='1' and count(lo)=x"FF") then
                                        pending(lo):=pending(lo)-1;
                                        if pending(lo)=0 then
                                            tone_gen_div(lo)<='1';
                                            if count(hi)=x"00" then pending(hi):=3; end if;
                                            count(hi):=std_logic_vector(unsigned(count(hi))-1);
                                        end if;
                                    end if;
                                end if;
                            else
                                for ch in lo to hi loop
                                    if pending(ch)>0 then
                                        pending(ch):=pending(ch)-1;
                                        if pending(ch)=0 then
                                            count(ch):=audf(ch); tone_gen_div(ch)<='1'; qualification_reload(ch)<='1';
                                        end if;
                                    elsif chan_ena(ch)='1' then
                                        if count(ch)=x"00" then pending(ch):=3; end if;
                                        count(ch):=std_logic_vector(unsigned(count(ch))-1);
                                    end if;
                                end loop;
                            end if;
                        end loop;
                    end if;
                    -- Idle asynchronous receive holds timers 3/4 at their reload state.
                    if skctls(4)='1' then
                        count(3):=audf(3); count(4):=audf(4); qualification_reload(4 downto 3)<="11";
                        pending(3):=0; pending(4):=0;
                        tone_gen_div(3)<='0'; tone_gen_div(4)<='0';
                    end if;
                    -- Reload two POKEY cycles after the original timer pulse.
                    -- Two pipeline bits retain consecutive resync triggers.
                    if resync(0)='1' then
                        count(1):=audf(1); count(2):=audf(2); qualification_reload(2 downto 1)<="11";
                        pending(1):=0; pending(2):=0; fsk_reload<='1';
                    end if;
                    resync:=resync(0) & fsk_trigger;
                end if;
                if we='1' and ADDR=x"9" then restart:=3; end if;
            end if;
            tone_gen_cnt <= count;
        end if;
    end process;

	p_tone_generator_mux : process(audctl, tone_gen_div)
	begin
		if (audctl(4) = '1') then -- chan 1/2 joined
			tone_gen_div_mux(1) <= tone_gen_div(1); -- do they both waggle
			tone_gen_div_mux(2) <= tone_gen_div(2); -- or do I mute chan 1?
		else
			tone_gen_div_mux(1) <= tone_gen_div(1);
			tone_gen_div_mux(2) <= tone_gen_div(2);
		end if;

		if (audctl(3) = '1') then -- chan 3/4 joined
			tone_gen_div_mux(3) <= tone_gen_div(3); -- ditto
			tone_gen_div_mux(4) <= tone_gen_div(4);
		else
			tone_gen_div_mux(3) <= tone_gen_div(3);
			tone_gen_div_mux(4) <= tone_gen_div(4);
		end if;
	end process;

	-- Keep 4 stages of each polynomial so channel N can see the
	-- bit as it arrived N-1 POKEY clocks ago (channel 1 leads, channel 4 lags by 3).
    p_poly_hist : process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET_EXT='1' then
                poly4_hist <= (others=>'0'); poly5_hist <= (others=>'1');
                poly917_hist <= (others=>'0');
            elsif ENA='1' then
                poly4_hist <= poly4_hist(2 downto 0) & poly4(3);
                poly5_hist <= poly5_hist(2 downto 0) & not poly5(4);
                poly917_hist <= poly917_hist(2 downto 0) & poly_17_9;
            end if;
        end if;
    end process;

	-- CHANNEL OUTPUT FLIP-FLOP -- topology corrected vs the original file.
	--
	-- The chip does NOT gate the polynomial into the timer pulse and toggle on the result. Each
	-- channel has ONE flip-flop, CLOCKED by the timer pulse (optionally gated by poly5) whose D
	-- input is either /Q (pure tone) or the selected polynomial bit. MAME `pokey.cpp`:
	--
	--     if ((AUDC & NOTPOLY5) || (poly5 & 1)) {
	--         if      (AUDC & PURE)   output ^= 1;         -- toggle
	--         else if (AUDC & POLY4)  output = poly4  & 1; -- SAMPLE
	--         else if (AUDCTL & POLY9)output = poly9  & 1;
	--         else                    output = poly17 & 1;
	--     }
	--
	-- We used to AND the poly into the pulse and toggle on the rising edge, which makes the output
	-- the running PARITY of the polynomial rather than the polynomial itself -- a different, and
	-- uncorrelated, waveform. Paperboy sits on this path: AUDC1 = 0x02/0x05 means bit7=0 (poly5
	-- gates) and bit5=0 (distortion), i.e. exactly the "sample the 17-bit poly" case.
	-- Corroborated independently by MAME and by Videodr0me's Major Havoc core.
	--
	-- Measured on Paperboy's own mode, old vs new: the sequences agree only ~50% (uncorrelated) but
	-- transition counts land within 1% and band energy within +0.6 dB (20-200 Hz) / -1.4 dB
	-- (0.5-3 kHz). So this is a CORRECTNESS fix, not a large level or timbre change.
	p_poly_gating : process(audc, poly4_hist, poly5_hist, poly917_hist, tone_gen_div_mux)
		variable p5, p4, p917 : std_logic;
	begin
		for i in 1 to 4 loop
			-- stage 0 = current bit (channel 1) ... stage 3 = 3 clocks old (channel 4)
			p5   := poly5_hist(i - 1);
			p4   := poly4_hist(i - 1);
			p917 := poly917_hist(i - 1);

			-- CLOCK into the channel FF: the timer pulse, gated by poly5 unless AUDC bit7 says not to
			if (audc(i)(7) = '0') then
				audio_clock(i) <= p5 and tone_gen_div_mux(i);
			else
				audio_clock(i) <= tone_gen_div_mux(i);
			end if;

			-- DATA into the channel FF: 4-bit poly if AUDC bit6, else the 17/9-bit poly
			if (audc(i)(6) = '1') then
				audio_sample(i) <= p4;
			else
				audio_sample(i) <= p917;
			end if;
		end loop;
	end process;

	-- HIGH-PASS FILTER -- capture source and XOR placement, two errors an earlier revision had:
	--
	--  1. Capturing the wrong signal: the capture FF took `poly_sel`, which is a ONE-CLOCK PULSE
	--     (high 0.093% of clocks), where the chip captures the channel OUTPUT FF STATE. MAME:
	--     `m_channel[CHAN1].m_filter_sample = m_channel[CHAN1].m_output`. Simulated at ch2/ch4
	--     periods 263/519 our capture FF saw '1' on 1 of 2021 timer events (0.05%) against
	--     992/2021 (49.08%) for the chip -- i.e. THE FILTER WAS EFFECTIVELY INERT. Paperboy does
	--     use it: AUDCTL 0x6a and 0x52 both set bit1 (channel 2 high-pass).
	--
	--  2. XORing in the wrong place: the XOR belongs at the MIXER, on the channel state
	--     (`m_output ^ m_filter_sample`), not on the toggle-detector input. Applied to the pulse it
	--     did NOT invert channels 1/2 when the filter is disabled -- the behaviour the old comment
	--     claimed -- it merely shifted the toggle edge by one clock.
	--
	-- Still true and still modelled: the XOR is NEVER bypassed. With the filter off the capture FF
	-- is FORCED TO 1, so channels 1/2 come out inverted. Channels 3/4 have no filter (MAME seeds
	-- their m_filter_sample to 0, i.e. XOR with 0 = pass-through).
	p_high_pass_filters : process(tone_gen_final, hp_capture)
	begin
		channel_output <= tone_gen_final;
		channel_output(1) <= tone_gen_final(1) xor hp_capture(1);
		channel_output(2) <= tone_gen_final(2) xor hp_capture(2);
	end process;

	p_audio_out : process
	begin
		wait until rising_edge(CLK);
		if RESET_EXT='1' then
            tone_gen_final <= (others=>'0'); hp_sample <= (others=>'1');
        elsif (ENA = '1') then
            if stimer_reload='1' then tone_gen_final <= (others=>'1'); end if;
			-- Capture FFs: channel 1's state is latched by tone generator 3, channel 2's by 4.
			-- When the filter is DISABLED the chip holds the FF at 1 rather than bypassing the XOR
			-- (MAME: `else m_channel[CHAN1].m_filter_sample = 1`), so channels 1/2 come out inverted.
			-- Holding the register (rather than muxing a 1 in downstream) also matches the reference
			-- on the enable transition: the filter starts from 1, not from a stale live capture.
			if (audctl(2) = '0') then
				if POKEY_HP_INVERT_WHEN_OFF then hp_sample(1) <= '1';
				else                             hp_sample(1) <= '0'; end if;
			elsif (tone_gen_div(3) = '1') then
				hp_sample(1) <= tone_gen_final(1);
			end if;

			if (audctl(1) = '0') then
				if POKEY_HP_INVERT_WHEN_OFF then hp_sample(2) <= '1';
				else                             hp_sample(2) <= '0'; end if;
			elsif (tone_gen_div(4) = '1') then
				hp_sample(2) <= tone_gen_final(2);
			end if;

			-- Channel output FFs: clocked by audio_clock, D = /Q (pure tone) or the polynomial bit.
			for i in 1 to 4 loop
				if stimer_reload='0' and (audio_clock(i) = '1') then
					if (audc(i)(5) = '1') then
						tone_gen_final(i) <= not tone_gen_final(i);
					else
						tone_gen_final(i) <= audio_sample(i);
					end if;
				end if;
			end loop;
		end if;
	end process;

    -- High-pass path: sample at high-timer audio clock (+1 POKEY tick),
    -- expose the captured state 1.5 ticks after that clock. Disabled filters force 1.
    hp_accelerated : if CLOCKS_PER_POKEY=1 generate
        signal delayed_sample : std_logic_vector(2 downto 1) := (others=>'1');
    begin
        process(CLK)
        begin
            if falling_edge(CLK) then
                if RESET_EXT='1' then hp_capture<=(others=>'1'); delayed_sample<=(others=>'1');
                elsif ENA='1' then
                    hp_capture<=delayed_sample; delayed_sample<=hp_sample;
                    if audctl(2)='0' then hp_capture(1)<='1'; end if;
                    if audctl(1)='0' then hp_capture(2)<='1'; end if;
                end if;
            end if;
        end process;
    end generate;
    hp_native : if CLOCKS_PER_POKEY>1 generate
        type delay_pair is array(1 to 2) of integer range 0 to CLOCKS_PER_POKEY*3/2;
    begin
        process(CLK)
            variable wait_clocks : delay_pair := (others=>0);
        begin
            if rising_edge(CLK) then
                if RESET_EXT='1' then
                    wait_clocks:=(others=>0); hp_capture<=(others=>'1');
                else
                    for ch in 1 to 2 loop
                        if audctl(3-ch)='0' then
                            hp_capture(ch)<='1'; wait_clocks(ch):=0;
                        elsif ENA='1' and tone_gen_div(ch+2)='1' then
                            wait_clocks(ch):=CLOCKS_PER_POKEY*3/2;
                        elsif wait_clocks(ch)>0 then
                            wait_clocks(ch):=wait_clocks(ch)-1;
                            if wait_clocks(ch)=0 then hp_capture(ch)<=hp_sample(ch); end if;
                        end if;
                    end loop;
                end if;
            end if;
        end process;
    end generate;

    -- Preserve Cloak's linear digital mixer, no Paperboy DAC/LM324 treatment.
    -- Explicit sensitivity retains VHDL-93 compatibility for Quartus 17.
    p_op_mixer : process(audc, channel_output, RESET_EXT)
        variable total : integer range 0 to 60;
    begin
        total:=0;
        for ch in 1 to 4 loop
            if audc(ch)(4)='1' or channel_output(ch)='1' then
                total:=total+to_integer(unsigned(audc(ch)(3 downto 0)));
            end if;
        end loop;
        if RESET_EXT='1' then AUDIO_OUT<=to_signed(-32,6);
        else AUDIO_OUT<=to_signed(total-32,6); end if;
    end process;

	-- Keyboard and serial receive input remain disconnected at this board boundary.
end architecture RTL;
