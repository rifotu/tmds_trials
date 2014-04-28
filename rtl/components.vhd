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

package sub_module_components is


  component encode is
    port(

     clkin          : in std_logic;
     rstin          : in std_logic;
     din            : in std_logic_vector(7 downto 0);
     c0             : in std_logic;
     c1             : in std_logic;
     de             : in std_logic;
     dout           : out std_logic_vector(9 downto 0)
   );
  end component;

component top_encoder_tst is 
port(

      i_clk         : in std_logic;
      i_rst         : in std_logic;

      o_pipe_data   : out std_logic_vector(9 downto 0);
      o_pipe_verilog : out std_logic_vector(9 downto 0);
      o_single_data : out std_logic_vector(9 downto 0)
);  
end component;


component camera is
port(
      i_clk        : in  std_logic;
      i_rst        : in  std_logic;

      o_lval       : out std_logic;
      o_fval       : out std_logic;
      o_pix        : out std_logic_vector(39 downto 0)
);
end component;


component lfsr is
generic(
       seed          : integer := 783   -- random number
);
port(
       i_rst         : in  std_logic;
       clk           : in  std_logic;

       i_lvalid      : in  std_logic;
       i_fvalid      : in  std_logic;
       i_place_seed  : in  std_logic;
       
       o_lvalid      : out std_logic;
       o_fvalid      : out std_logic;
       o_pix         : out std_logic_vector(15 downto 0)
);
end component;

component lvalid_fvalid_gen is
generic(
           PIXEL_NO        : integer := 751;   -- 752-1
           LINE_NO         : integer := 479    -- 480-1
);
port(
           i_rst           : in    std_logic;
           clk             : in    std_logic; 
   
           i_strt_pulse    : in    std_logic;  
                                               
                                               

           o_Fvalid        : out   std_logic;
           o_Lvalid        : out   std_logic 

);      
end component;

component enc_tmds_pipe is
port(
      i_clk      : in  std_logic;
      i_data     : in  std_logic_vector(7 downto 0);
      i_audio    : in  std_logic_vector(3 downto 0);
      i_cntrl    : in  std_logic_vector(1 downto 0);

      i_vid_de   : in  std_logic;
      i_aud_de   : in  std_logic;

      o_data     : out std_logic_vector(9 downto 0)
);
end component;

component enc_tmds is
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
end component;



end sub_module_components;
