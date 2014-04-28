----------------------------------------------------------------------------
--  enc_tmds.vhd
--	Encode TMDS Bitstream
--	Version 1.0
--
--  Copyright (C) 2014 H.Poetzl
--
--	This program is free software: you can redistribute it and/or
--	modify it under the terms of the GNU General Public License
--	as published by the Free Software Foundation, either version
--	2 of the License, or (at your option) any later version.
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity enc_tmds is
    port (
	clk	: in std_logic;
	--
	din	: in std_logic_vector (7 downto 0);
	ain	: in std_logic_vector (3 downto 0);
	cin	: in std_logic_vector (1 downto 0);
	--
	vde	: in std_logic;
	ade	: in std_logic;
	--
	dout	: out std_logic_vector (9 downto 0)
    );
end entity enc_tmds;

architecture RTL of enc_tmds is

    --attribute KEEP_HIERARCHY of RTL : architecture is "TRUE";

    signal enc_or : std_logic_vector (8 downto 0);
    signal enc_nor : std_logic_vector (8 downto 0);
    signal word : std_logic_vector (8 downto 0);

    signal set : natural range 0 to 8;
    signal disparity : integer range -4 to 4;
    signal word8 : natural range 0 to 1;

    function bits_set ( val : std_logic_vector )
        return natural is
	variable num : natural := 0;
    begin
	for I in val'range loop
	    if val(I) = '1' then
		num := num + 1;
	    end if;
	end loop;
	return num;
    end function;


begin

    enc_or(0) <= din(0);
    enc_nor(0) <= din(0);

    GEN_ENC: for I in 1 to 7 generate
	enc_or(I) <= din(I) xor enc_or(I - 1);
	enc_nor(I) <= din(I) xnor enc_nor(I - 1);
    end generate;

    enc_or(8) <= '1';
    enc_nor(8) <= '0';

    set <= bits_set(din);

    word <= enc_nor when set > 4
	else enc_nor when set = 4 and din(0) = '0'
	else enc_or;

    disparity <= bits_set(word(7 downto 0)) - 4;
    word8 <= 1 when word(8) = '1' else 0;

    enc_proc: process(clk)

	variable dc_bias : integer range -4 to 4 := 0;

    begin
	if rising_edge(clk) then
	    if vde = '1' then		-- Encode data word
		if dc_bias = 0 or disparity = 0 then
		    if word8 = 1 then
			dout <= "01" & word(7 downto 0);
			dc_bias := dc_bias + disparity;
		
		    else
			dout <= "10" & not(word(7 downto 0));
			dc_bias := dc_bias - disparity;
		
		    end if;

		elsif (dc_bias > 0 and disparity > 0) or
		    (dc_bias < 0 and disparity < 0) then
		    dout <= '1' & word(8) & not word(7 downto 0);
		    dc_bias := dc_bias + word8 - disparity;

		else
		    dout <= '0' & word;
		    dc_bias := dc_bias + 1 - word8 + disparity;

		end if;

	    elsif ade = '1' then	-- Encode audio/aux word
		case ain is
		   when "0000" => dout <= "1010011100";
		   when "0001" => dout <= "1001100011";
		   when "0010" => dout <= "1011100100";
		   when "0011" => dout <= "1011100010";
		   when "0100" => dout <= "0101110001";
		   when "0101" => dout <= "0100011110";
		   when "0110" => dout <= "0110001110";
		   when "0111" => dout <= "0100111100";
		   when "1000" => dout <= "1011001100";
		   when "1001" => dout <= "0100111001";
		   when "1010" => dout <= "0110011100";
		   when "1011" => dout <= "1011000110";
		   when "1100" => dout <= "1010001110";
		   when "1101" => dout <= "1001110001";
		   when "1110" => dout <= "0101100011";
		   when "1111" => dout <= "1011000011";
		   when others => dout <= "0000000000";
		end case;

	    else			-- Encode control word
		case cin is
		   when "00"   => dout <= "1101010100";
		   when "01"   => dout <= "0010101011";
		   when "10"   => dout <= "0101010100";
		   when "11"   => dout <= "1010101011";
		   when others => dout <= "0000000000";
		end case;

		dc_bias := 0;

	    end if;
	end if;
    end process;

end RTL;


