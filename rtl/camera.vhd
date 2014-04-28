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

library work;
use work.sub_module_components.all;

entity camera is
port(
      i_clk        : in  std_logic;
      i_rst        : in  std_logic;

      o_lval       : out std_logic;
      o_fval       : out std_logic;
      o_pix        : out std_logic_vector(39 downto 0)
);
end camera;

architecture rtl of camera is

--constant  ONE_SECOND  : integer := 125000000;
constant  ONE_SECOND  : integer := 1250;

signal strt_test      : std_logic := '0';
signal lvalid         : std_logic := '0';
signal fvalid         : std_logic := '0';
signal lval_frm_lfsr  : std_logic := '0';
signal fval_frm_lfsr  : std_logic := '0';
signal pix_frm_lfsr   : std_logic_vector(15 downto 0) := (others => '0');

signal gp_cnt         : std_logic_vector(27 downto 0) := (others => '0');

begin


process(i_clk)
begin
  if(i_clk'event and i_clk = '1') then
    if(i_rst = '1') then
      gp_cnt <= (others => '0');
    else
      if(gp_cnt(27) = '0') then
        gp_cnt <= gp_cnt + '1';
      end if;
    end if;
  end if;
end process;

strt_test <=  '1' when gp_cnt = conv_std_logic_vector(ONE_SECOND, 28) else
              '0';


i_pix_lfsr: lfsr
generic map(
         seed => 293
)
port map(
         i_rst   =>  i_rst,
         clk     =>  i_clk,

         i_place_seed => strt_test,       
         i_lvalid     => lvalid,
         i_fvalid     => fvalid,

         o_lvalid    => lval_frm_lfsr,
         o_fvalid    => fval_frm_lfsr,
         o_pix       => pix_frm_lfsr
);

 
i_lvalid_fvalid_gen: lvalid_fvalid_gen
generic map(
               PIXEL_NO     => 751, -- : integer := 751;   -- 752-1
               LINE_NO      =>   4  -- : integer := 479    -- 480-1
)
port map(
               i_rst        => i_rst,         -- : in  std_logic;
               clk          => i_clk,           -- : in  std_logic; 
   
               i_strt_pulse => strt_test,     -- : in std_logic;  
                                                                                    
                                                                                    
               o_Fvalid     => fvalid,        -- : out std_logic;
               o_Lvalid     => lvalid         -- : out std_logic;
);      

-- Assign outputs
o_lval  <= lval_frm_lfsr;
o_fval  <= fval_frm_lfsr;
o_pix   <= pix_frm_lfsr(7 downto 0) & pix_frm_lfsr & pix_frm_lfsr ;


end rtl;    
