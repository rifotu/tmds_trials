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


library work;
use work.sub_module_components.all;


entity top_encoder_tst is 
port(

      i_clk         : in std_logic;
      i_rst         : in std_logic;

      o_pipe_data    : out std_logic_vector(9 downto 0);
      o_pipe_verilog : out std_logic_vector(9 downto 0);
      o_single_data  : out std_logic_vector(9 downto 0)
);  
end top_encoder_tst ;

architecture rtl of top_encoder_tst is


signal rst	     : std_logic := '1' ;
signal lval          : std_logic := '0';
signal fval          : std_logic := '0';
signal pix           : std_logic_vector(39 downto 0);
signal enc_pipelined : std_logic_vector(9 downto 0);
signal enc           : std_logic_vector(9 downto 0);
signal enc_d1        : std_logic_vector(9 downto 0);
signal enc_d2        : std_logic_vector(9 downto 0);
signal enc_d3        : std_logic_vector(9 downto 0);
signal enc_d4        : std_logic_vector(9 downto 0);
signal enc_d5        : std_logic_vector(9 downto 0);
signal enc_d6        : std_logic_vector(9 downto 0);
signal enc_d7        : std_logic_vector(9 downto 0);
signal enc_d8        : std_logic_vector(9 downto 0);
signal enc_d9        : std_logic_vector(9 downto 0);
signal enc_d10       : std_logic_vector(9 downto 0);
signal enc_d11       : std_logic_vector(9 downto 0);
signal enc_d12       : std_logic_vector(9 downto 0);
signal enc_d13       : std_logic_vector(9 downto 0);
signal enc_d14       : std_logic_vector(9 downto 0);
signal enc_d15       : std_logic_vector(9 downto 0);
signal enc_d16       : std_logic_vector(9 downto 0);
signal enc_d17       : std_logic_vector(9 downto 0);
signal board_clk     : std_logic := '0';
signal enc_verilog   : std_logic_vector(9 downto 0);
signal enc_verilog_d1   : std_logic_vector(9 downto 0);
signal enc_verilog_d2   : std_logic_vector(9 downto 0);
signal enc_verilog_d3   : std_logic_vector(9 downto 0);
signal enc_verilog_d4   : std_logic_vector(9 downto 0);
signal enc_verilog_d5   : std_logic_vector(9 downto 0);
signal enc_verilog_d6   : std_logic_vector(9 downto 0);
signal enc_verilog_d7   : std_logic_vector(9 downto 0);
signal enc_verilog_d8   : std_logic_vector(9 downto 0);
signal enc_verilog_d9   : std_logic_vector(9 downto 0);
signal enc_verilog_d10  : std_logic_vector(9 downto 0);
signal enc_verilog_d11  : std_logic_vector(9 downto 0);
signal enc_verilog_d12  : std_logic_vector(9 downto 0);
signal enc_verilog_d13  : std_logic_vector(9 downto 0);
signal enc_verilog_d14  : std_logic_vector(9 downto 0);
signal enc_verilog_d15  : std_logic_vector(9 downto 0);



begin

board_clk <= i_clk;
rst       <= i_rst;

i_camera: camera
port map(
          i_clk      => board_clk,  -- : in  std_logic;
          i_rst      => rst,        -- : in  std_logic;
          o_lval     => lval,       --                                     
          o_fval     => fval,       -- : out std_logic;
          o_pix      => pix         -- : out std_logic;
);                                  -- : out std_logic_vector(39 downto 0)


i_enc_tmds_pipe: enc_tmds_pipe
port map(
      i_clk       => board_clk, --: in  std_logic;
      i_data      => pix(7 downto 0), --: in  std_logic_vector(7 downto 0);
      i_audio     => "0000", --: in  std_logic_vector(3 downto 0);
      i_cntrl     => "00", --: in  std_logic_vector(1 downto 0);

      i_vid_de    => lval, --: in  std_logic;
      i_aud_de    => '0', --: in  std_logic;

      o_data      => enc_pipelined  --: out std_logic_vector(9 downto 0)
);

  i_encode_verilog: encode 
    port map(

     clkin          => board_clk, -- : in std_logic;
     rstin          => rst, -- : in std_logic;
     din            => pix(7 downto 0), -- : in std_logic_vector(7 downto 0);
     c0             => '0', -- : in std_logic;
     c1             => '0', -- : in std_logic;
     de             => lval, -- : in std_logic;
     dout           => enc_verilog  -- : out std_logic_vector(9 downto 0)
   );



i_enc_tdms: enc_tmds
port map(
      clk   => board_clk,  -- : in std_logic;
      --
      din   => pix(7 downto 0),  -- : in std_logic_vector (7 downto 0);
      ain   => "0000",  -- : in std_logic_vector (3 downto 0);
      cin   => "00",  -- : in std_logic_vector (1 downto 0);
      --
      vde   => lval,  -- : in std_logic;
      ade   => '0',  -- : in std_logic;
      --
      dout  => enc   -- : out std_logic_vector (9 downto 0)
);


process(i_clk)
begin
  if(i_clk'event and i_clk = '1') then
    enc_verilog_d1  <= enc_verilog;
    enc_verilog_d2  <= enc_verilog_d1;
    enc_verilog_d3  <= enc_verilog_d2;
    enc_verilog_d4  <= enc_verilog_d3;
    enc_verilog_d5  <= enc_verilog_d4;
    enc_verilog_d6  <= enc_verilog_d5;
    enc_verilog_d7  <= enc_verilog_d6;
    enc_verilog_d8  <= enc_verilog_d7;
    enc_verilog_d9  <= enc_verilog_d8;
    enc_verilog_d10 <= enc_verilog_d9;
    enc_verilog_d11 <= enc_verilog_d10;
    enc_verilog_d12 <= enc_verilog_d11;
    enc_verilog_d13 <= enc_verilog_d12;
    enc_verilog_d14 <= enc_verilog_d13;
    enc_verilog_d15 <= enc_verilog_d14;
  end if;
end process;

process(i_clk)
begin
  if(i_clk'event and i_clk = '1') then
    enc_d1  <= enc;
    enc_d2  <= enc_d1;
    enc_d3  <= enc_d2;
    enc_d4  <= enc_d3;
    enc_d5  <= enc_d4;
    enc_d6  <= enc_d5;
    enc_d7  <= enc_d6;
    enc_d8  <= enc_d7;
    enc_d9  <= enc_d8;
    enc_d10  <= enc_d9;
    enc_d11 <= enc_d10;
    enc_d12 <= enc_d11;
    enc_d13 <= enc_d12;
    enc_d14 <= enc_d13;
    enc_d15 <= enc_d14;
    enc_d16 <= enc_d15;
    enc_d17 <= enc_d16;
  end if;
end process;

o_pipe_data    <= enc_pipelined;
o_single_data  <= enc_d17;
o_pipe_verilog <= enc_verilog_d15; 

end rtl;
