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

entity lvalid_fvalid_gen is
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
end lvalid_fvalid_gen;


architecture rtl of lvalid_fvalid_gen is

--CONSTANT PIXEL_NO    : integer := 751;  -- 752-1 = 751
--CONSTANT LINE_NO     : integer := 479;  -- 480-1 = 479

type states is (ST_IDLE, ST_FRAME_STRT_BLANK, ST_ACTIVE_LINE, ST_HORIZANTAL_BLANK,
                ST_FRAME_END_BLANK, ST_VERTICAL_BLANKING);

signal state_reg     : states;
signal state_next    : states;

signal gp_counter    : std_logic_vector(11 downto 0) := conv_std_logic_vector(0,12);
signal row_cnt       : std_logic_vector(8 downto 0) := conv_std_logic_vector(0, 9);

signal clear_gp      : std_logic := '0';
signal run_gp        : std_logic := '0';

signal L_valid       : std_logic := '0';
signal L_valid_d1    : std_logic := '0';
signal L_valid_d2    : std_logic := '0';
signal L_valid_d3    : std_logic := '0';

signal F_valid       : std_logic := '0';
signal F_valid_d1    : std_logic := '0';
signal F_valid_d2    : std_logic := '0';
signal F_valid_d3    : std_logic := '0';

signal end_of_line   : std_logic := '0';
signal end_of_frame  : std_logic := '0';


begin
-- general purpose counter
process(clk, i_rst)
begin
  if(i_rst = '1') then
    gp_counter <= (others => '0');
  elsif(clk'event and clk = '1') then
    if(clear_gp = '1') then
      gp_counter <= (others => '0');
    elsif(run_gp = '1') then
      gp_counter <= gp_counter + '1';
    end if;
  end if;
end process;

-- get new value of state_reg
process(clk, i_rst)
begin
  if(i_rst = '1') then
    state_reg <= ST_IDLE;
  elsif(clk'event and clk = '1') then
    state_reg <= state_next;
  end if;
end process;


-- next state logic
process(state_reg, i_strt_pulse, gp_counter, i_rst, row_cnt)
begin
  if( i_rst = '1') then
    state_next <= ST_IDLE;
  else
    state_next <= state_reg;

    case state_reg is

      when ST_IDLE =>
        if(i_strt_pulse = '1') then
          state_next <= ST_FRAME_STRT_BLANK;
        end if;

      when ST_FRAME_STRT_BLANK =>
        if(gp_counter = conv_std_logic_vector(70,12)) then  -- 71-1 = 70
          state_next <= ST_ACTIVE_LINE;
        end if;

      when ST_ACTIVE_LINE =>
        if(gp_counter = conv_std_logic_vector(PIXEL_NO, 12)) then
          if(row_cnt = conv_std_logic_vector(LINE_NO, 9)) then
            state_next <= ST_FRAME_END_BLANK;
          else
            state_next <= ST_HORIZANTAL_BLANK;
          end if;
        end if;

      when ST_HORIZANTAL_BLANK =>
        if(gp_counter = conv_std_logic_vector(46,12)) then  -- 94-1 = 93,    94/2 - 1 = 46
          state_next <= ST_ACTIVE_LINE;
        end if;

      when ST_FRAME_END_BLANK =>
        if(gp_counter = conv_std_logic_vector(22,12)) then  -- 23-1 = 22
          state_next <= ST_VERTICAL_BLANKING;
        end if;

      when ST_VERTICAL_BLANKING =>
        if(gp_counter = conv_std_logic_vector(2000,12)) then  -- this is a random number, normally 
          state_next <= ST_FRAME_STRT_BLANK;                -- vertical blanking continues for 45 lines
        end if;

      when others =>
        state_next <= ST_IDLE;

    end case;
  end if;
end process;



-- output logic
process(state_reg, gp_counter)
begin
  clear_gp   <= '0'; 
  run_gp     <= '0'; 
  L_valid    <= '0'; 
  F_valid    <= '0'; 
                     
  case state_reg is  
                     
    when ST_IDLE =>  
      null;          
                     
    when ST_FRAME_STRT_BLANK =>
      F_valid  <= '1';
      if(gp_counter = conv_std_logic_vector(70,12)) then
        clear_gp <= '1';
        run_gp   <= '0';
      else
        clear_gp <= '0';
        run_gp   <= '1';
      end if;

    when ST_ACTIVE_LINE =>
      F_valid  <= '1';
      L_valid  <= '1';
      if(gp_counter = conv_std_logic_vector(PIXEL_NO,12)) then
        clear_gp <= '1';
        run_gp   <= '0';
      else
        clear_gp <= '0';
        run_gp   <= '1'; 
      end if;

    when ST_HORIZANTAL_BLANK =>
      F_valid <= '1';
      if(gp_counter = conv_std_logic_vector(46,12)) then
        clear_gp <= '1';
        run_gp   <= '0';
      else
        clear_gp <= '0';
        run_gp   <= '1';
      end if;

    when ST_FRAME_END_BLANK =>
      F_valid <= '1';
      if(gp_counter = conv_std_logic_vector(22,12)) then
        clear_gp <= '1';
        run_gp   <= '0';
      else 
        clear_gp <= '0';
        run_gp   <= '1';
      end if;

    when ST_VERTICAL_BLANKING =>
      if(gp_counter = conv_std_logic_vector(2000,12)) then
        clear_gp <= '1';
        run_gp   <= '0';
      else
        clear_gp <= '0';
        run_gp   <= '1';
      end if;

    when others =>
      null;
		
  end case;
end process;


-- Frame valid signal, register to ease routing
process(clk, i_rst)
begin
  if(i_rst = '1') then
    F_valid_d1 <= '0';
  elsif(clk'event and clk = '1') then
    F_valid_d1 <= F_valid;
  end if;
end process;

end_of_frame <=  not(F_valid) and F_valid_d1;


-- Line valid signal, register to ease routing
process(clk, i_rst)
begin
  if(i_rst = '1') then
    L_valid_d1 <= '0';
  elsif(clk'event and clk = '1') then
    L_valid_d1 <= L_valid;
  end if;
end process;

end_of_line <= not(L_valid) and L_valid_d1;


-- keep track of row cnt
process(clk, i_rst)
begin
  if(i_rst = '1') then
    row_cnt <= (others => '0');
  elsif(clk'event and clk = '1') then
    if(end_of_frame = '1') then
      row_cnt <= (others => '0');
    elsif(end_of_line = '1') then
      row_cnt <= row_cnt + '1';
    end if;
  end if;
end process;


-- L_valid_d1 aligns with buffer 1 read addr 0
-- L_valid_d2 aligns with read buffer 1 data from addr0
process(clk, i_rst)
begin
  if(i_rst = '1') then
    L_valid_d2  <= '0';
    L_valid_d3  <= '0';
  elsif(clk'event and clk = '1') then
    L_valid_d2  <= L_valid_d1;
    L_valid_d3  <= L_valid_d2;
  end if;
end process;

process(clk, i_rst)
begin
  if(i_rst = '1') then
    F_valid_d2  <= '0';
    F_valid_d3  <= '0';
  elsif(clk'event and clk = '1') then
    F_valid_d2  <= F_valid_d1;
    F_valid_d3  <= F_valid_d2;
  end if;
end process;


-- Assign outputs

o_Fvalid      <= F_valid_d3;  -- these two signals will be registered one more time
o_Lvalid      <= L_valid_d3;  -- in IOB block


end rtl;
