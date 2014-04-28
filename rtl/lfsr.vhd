----------------------------------------------------------------------------
--  
--	HDMI example
--	Version 1.1
--
--  Copyright (C) 2014 R.Tursen
--
--  This program is free software: you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation, either version
--  2 of the License, or (at your option) any later version.
--
--
----------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity lfsr is
generic(
       seed          : integer := 783   -- random number
);
port(
       i_rst         : in  std_logic;
       clk           : in  std_logic;

       i_place_seed  : in  std_logic;
       i_lvalid      : in  std_logic;
       i_fvalid      : in  std_logic;
       
       o_lvalid        : out std_logic;
       o_fvalid        : out std_logic;
       o_pix         : out std_logic_vector(15 downto 0)
);
end lfsr;


architecture rtl of lfsr is

signal lfsr       : std_logic_vector(15 downto 0);
signal input      : std_logic;
signal lval       : std_logic := '0';
signal fval       : std_logic := '0';

begin

-- linear feedback shift register
process(clk, i_rst)
begin
  if(i_rst = '1') then
    lfsr <= (others => '0');
  elsif(clk'event and clk = '1') then
    if(i_place_seed = '1') then
      lfsr <= conv_std_logic_vector(seed, 16);
    elsif(i_lvalid = '1') then
      lfsr <= lfsr(14 downto 0) & input;
    end if;
  end if;
end process;

-- tap choices are made according to XAPP052
input <= not(lfsr(3) xor lfsr(12) xor lfsr(14) xor lfsr(15));

-- delay i_lvalid for 1 CC 
process(clk)
begin
  if(clk'event and clk = '1') then
    lval <= i_lvalid;
    fval <= i_fvalid;
  end if;
end process;

-- assign outputs

o_fvalid <= fval;
o_lvalid <= lval;
o_pix  <= lfsr;

end rtl;

