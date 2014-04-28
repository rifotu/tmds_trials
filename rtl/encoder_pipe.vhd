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
use ieee.numeric_std.all;

entity enc_tmds_pipe is
port(
      i_clk      : in  std_logic;
      i_data     : in  std_logic_vector(7 downto 0);
      i_audio    : in  std_logic_vector(3 downto 0);
      i_cntrl    : in  std_logic_vector(1 downto 0);

      i_vid_de   : in  std_logic;
      i_aud_de   : in  std_logic;

      o_data     : out std_logic_vector(9 downto 0)
);
end enc_tmds_pipe;


architecture rtl of enc_tmds_pipe is

CONSTANT EIGHT              : unsigned(3 downto 0) := "1000";

signal word7_d1             : std_logic_vector(7 downto 0);
signal word7_d2             : std_logic_vector(7 downto 0);
signal word7_d3             : std_logic_vector(7 downto 0);
signal word7_d4             : std_logic_vector(7 downto 0);
signal word7_d5             : std_logic_vector(7 downto 0);

signal sum1_8a              : unsigned(2 downto 0);
signal sum1_8b              : unsigned(2 downto 0);
signal sum1_8a_r            : unsigned(2 downto 0);
signal sum1_8b_r            : unsigned(2 downto 0);
signal sum1_din             : unsigned(3 downto 0);
signal sum1_din_r           : unsigned(3 downto 0);
signal select1              : std_logic := '0';
signal select1_r            : std_logic := '0';

signal word8_A              : std_logic_vector(8 downto 0);
signal word8_B              : std_logic_vector(8 downto 0);
signal word8                : std_logic_vector(8 downto 0);
signal word8_d1             : std_logic_vector(8 downto 0);
signal word8_d2             : std_logic_vector(8 downto 0);
signal word8_d3             : std_logic_vector(8 downto 0);
signal word8_d4             : std_logic_vector(8 downto 0);
signal word8_d5             : std_logic_vector(8 downto 0);
signal word8_d6             : std_logic_vector(8 downto 0);
signal word8_d7             : std_logic_vector(8 downto 0);
signal word8_d8             : std_logic_vector(8 downto 0);
signal word8_d9             : std_logic_vector(8 downto 0);
signal word8_d10            : std_logic_vector(8 downto 0);
signal sum1_9a              : unsigned(2 downto 0);
signal sum1_9b              : unsigned(2 downto 0);
signal sum1_9a_r            : unsigned(2 downto 0);
signal sum1_9b_r            : unsigned(2 downto 0);
signal sum1_word8           : unsigned(3 downto 0);
signal sum1_word8_d1        : unsigned(3 downto 0);
signal sum1_word8_d2        : unsigned(3 downto 0);
signal sum0_word8           : unsigned(3 downto 0);
signal sum0_word8_r         : unsigned(3 downto 0);
signal sum1_word8_d3        : unsigned(3 downto 0);
signal sum0_word8_d3        : unsigned(3 downto 0);
signal sum1_word8_d3_clone  : unsigned(3 downto 0);
signal sum0_word8_d3_clone  : unsigned(3 downto 0);


  signal ones_greater_than_zeros      : std_logic;
  signal ones_equal_to_zeros          : std_logic;
  signal ones_greater_than_zeros_d1   : std_logic;
  signal ones_equal_to_zeros_d1       : std_logic;
  signal ones_greater_than_zeros_d2   : std_logic;
  signal ones_equal_to_zeros_d2       : std_logic;
  signal excess_ones                  : signed(4 downto 0);
  signal excess_zeros                 : signed(4 downto 0);
  signal mult2                        : signed(4 downto 0);
  signal mult2_cmpl                   : signed(4 downto 0);
  signal excess_ones_r                : signed(4 downto 0);
  signal excess_zeros_r               : signed(4 downto 0);
  signal mult2_r                      : signed(4 downto 0);
  signal mult2_cmpl_r                 : signed(4 downto 0);

  signal dc_bias_preA                 : signed(5 downto 0);
  signal dc_bias_preB                 : signed(5 downto 0);
  signal dc_bias_preC                 : signed(5 downto 0);
  signal dc_bias_preD                 : signed(5 downto 0);

  signal dc_bias_preA_r               : signed(5 downto 0);
  signal dc_bias_preB_r               : signed(5 downto 0);
  signal dc_bias_preC_r               : signed(5 downto 0);
  signal dc_bias_preD_r               : signed(5 downto 0);

  signal dc_bias_A                    : signed(6 downto 0);
  signal dc_bias_B                    : signed(6 downto 0);
  signal dc_bias_C                    : signed(6 downto 0);
  signal dc_bias_D                    : signed(6 downto 0);

  signal dc_bias                      : signed(6 downto 0);

  signal zero_dc_bias                 : std_logic := '0';
  signal positive_dc_bias             : std_logic := '0';
  signal negative_dc_bias             : std_logic := '0';
  signal select2                      : std_logic := '0';
  signal select3                      : std_logic := '0';
  signal select2_r                    : std_logic := '0';
  signal select3_r                    : std_logic := '0';

  signal word9_A                      : std_logic_vector(9 downto 0);
  signal word9_B                      : std_logic_vector(9 downto 0);
  signal word9_C                      : std_logic_vector(9 downto 0);
  signal word9_D                      : std_logic_vector(9 downto 0);
  signal word9_vid                    : std_logic_vector(9 downto 0);
  signal video                        : std_logic_vector(9 downto 0);

  signal vid_de          : std_logic_vector(17 downto 0);
  signal aud_de          : std_logic_vector(17 downto 0);
  signal audio_d1        : std_logic_vector( 3 downto 0);
  signal audio_d2        : std_logic_vector( 3 downto 0);
  signal audio_d3        : std_logic_vector( 3 downto 0);
  signal audio_d4        : std_logic_vector( 3 downto 0);
  signal audio_d5        : std_logic_vector( 3 downto 0);
  signal audio_d6        : std_logic_vector( 3 downto 0);
  signal audio_d7        : std_logic_vector( 3 downto 0);
  signal audio_d8        : std_logic_vector( 3 downto 0);
  signal audio_d9        : std_logic_vector( 3 downto 0);
  signal audio_d10       : std_logic_vector( 3 downto 0);
  signal audio_d11       : std_logic_vector( 3 downto 0);
  signal audio_d12       : std_logic_vector( 3 downto 0);
  signal audio_d13       : std_logic_vector( 3 downto 0);
  signal audio_d14       : std_logic_vector( 3 downto 0);
  signal audio_d15       : std_logic_vector( 3 downto 0);
  signal audio_d16       : std_logic_vector( 3 downto 0);
  signal cntrl_d1        : std_logic_vector( 1 downto 0);
  signal cntrl_d2        : std_logic_vector( 1 downto 0);
  signal cntrl_d3        : std_logic_vector( 1 downto 0);
  signal cntrl_d4        : std_logic_vector( 1 downto 0);
  signal cntrl_d5        : std_logic_vector( 1 downto 0);
  signal cntrl_d6        : std_logic_vector( 1 downto 0);
  signal cntrl_d7        : std_logic_vector( 1 downto 0);
  signal cntrl_d8        : std_logic_vector( 1 downto 0);
  signal cntrl_d9        : std_logic_vector( 1 downto 0);
  signal cntrl_d10       : std_logic_vector( 1 downto 0);
  signal cntrl_d11       : std_logic_vector( 1 downto 0);
  signal cntrl_d12       : std_logic_vector( 1 downto 0);
  signal cntrl_d13       : std_logic_vector( 1 downto 0);
  signal cntrl_d14       : std_logic_vector( 1 downto 0);
  signal cntrl_d15       : std_logic_vector( 1 downto 0);
  signal cntrl_d16       : std_logic_vector( 1 downto 0);
                   
  signal audio_9        : std_logic_vector(9 downto 0);
  signal audio          : std_logic_vector(9 downto 0);
  signal cntrl_9        : std_logic_vector(9 downto 0);
  signal cntrl          : std_logic_vector(9 downto 0);
  signal data           : std_logic_vector(9 downto 0);


begin

  -- cycle 1,2,3,4,5
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      word7_d1 <= i_data;
      word7_d2 <= word7_d1;
      word7_d3 <= word7_d2;
      word7_d4 <= word7_d3;
      word7_d5 <= word7_d4;
    end if;
  end process;


  --sum1_8b <= unsigned("00" & word7_d2(0)) + unsigned("00" & word7_d2(1)) + unsigned("00" & word7_d2(2)) + unsigned("00" & word7_d2(3));
  --sum1_8b <= unsigned("00" & word7_d2(4)) + unsigned("00" & word7_d2(5)) + unsigned("00" & word7_d2(6)) + unsigned("00" & word7_d2(7));
  sum1_8a <= (resize(('0'&word7_d2(0)), sum1_8a'length)) +
             (resize(('0'&word7_d2(1)), sum1_8a'length)) +
             (resize(('0'&word7_d2(2)), sum1_8a'length)) + 
             (resize(('0'&word7_d2(3)), sum1_8a'length));

  sum1_8b <= (resize(('0'&word7_d2(4)), sum1_8b'length)) +
             (resize(('0'&word7_d2(5)), sum1_8b'length)) +
             (resize(('0'&word7_d2(6)), sum1_8b'length)) +
             (resize(('0'&word7_d2(7)), sum1_8b'length));

  -- cycle 3
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      sum1_8a_r <= sum1_8a;
      sum1_8b_r <= sum1_8b;
    end if;
  end process;

  sum1_din <= ('0'&sum1_8a_r) + ('0'&sum1_8b_r); -- 4bits, since 8 can't be represented with 3 bits

  -- cycle 4
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      sum1_din_r <= sum1_din;
    end if;
  end process;

  select1 <= '1' when (sum1_din_r > "0100") OR ((sum1_din_r = "0100") AND word7_d4(0) = '0') else
             '0';

  -- cycle 5
  -- Select1_r aligns with word7_d5
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      select1_r <= select1;
    end if;
  end process;

  
  word8_A(0) <= word7_d5(0);
  word8_A(1) <= word8_A(0) XOR word7_d5(1);
  word8_A(2) <= word8_A(1) XOR word7_d5(2);
  word8_A(3) <= word8_A(2) XOR word7_d5(3);
  word8_A(4) <= word8_A(3) XOR word7_d5(4);
  word8_A(5) <= word8_A(4) XOR word7_d5(5);
  word8_A(6) <= word8_A(5) XOR word7_d5(6);
  word8_A(7) <= word8_A(6) XOR word7_d5(7);
  word8_A(8) <= '1';
  
  word8_B(0) <= word7_d5(0);
  word8_B(1) <= word8_B(0) XNOR word7_d5(1);
  word8_B(2) <= word8_B(1) XNOR word7_d5(2);
  word8_B(3) <= word8_B(2) XNOR word7_d5(3);
  word8_B(4) <= word8_B(3) XNOR word7_d5(4);
  word8_B(5) <= word8_B(4) XNOR word7_d5(5);
  word8_B(6) <= word8_B(5) XNOR word7_d5(6);
  word8_B(7) <= word8_B(6) XNOR word7_d5(7);
  word8_B(8) <= '0';

  -- cycle 6
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      if(select1_r = '1') then
        word8 <= word8_B;
      else
        word8 <= word8_A;
      end if;
    end if;
  end process;

  -- cycle 7
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      word8_d1  <= word8;
      word8_d2  <= word8_d1;    -- cycle 8
      word8_d3  <= word8_d2;    -- cycle 9
      word8_d4  <= word8_d3;    -- cycle 10
      word8_d5  <= word8_d4;    -- cycle 11
      word8_d6  <= word8_d5;    -- cycle 12
      word8_d7  <= word8_d6;    -- cycle 13
      word8_d8  <= word8_d7;    -- cycle 14
      word8_d9  <= word8_d8;    -- cycle 15
      word8_d10 <= word8_d9;    -- cycle 16
    end if;
  end process;

  sum1_9a <= resize('0' & word8_d1(0), sum1_9a'length) +
             resize('0' & word8_d1(1), sum1_9a'length) + 
             resize('0' & word8_d1(2), sum1_9a'length) +
             resize('0' & word8_d1(3), sum1_9a'length);

  sum1_9b <= resize('0' & word8_d1(4), sum1_9b'length) +
             resize('0' & word8_d1(5), sum1_9b'length) + 
             resize('0' & word8_d1(6), sum1_9b'length) + 
             resize('0' & word8_d1(7), sum1_9b'length);

  -- cycle 8
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      sum1_9a_r <= sum1_9a;
      sum1_9b_r <= sum1_9b;
    end if;
  end process;

  sum1_word8 <= unsigned('0'&sum1_9a_r) + unsigned('0'&sum1_9b_r);

  -- cycle 9,10
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      sum1_word8_d1 <= sum1_word8;
      sum1_word8_d2 <= sum1_word8_d1;
    end if;
  end process;

  sum0_word8 <= EIGHT - unsigned(sum1_word8_d1);

  -- cycle 10
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      sum0_word8_r <= sum0_word8;
    end if;
  end process;
 
  -- cycle 11
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      sum1_word8_d3 <= sum1_word8_d2;
      sum0_word8_d3 <= sum0_word8_r;

      sum1_word8_d3_clone <= sum1_word8_d2;
      sum0_word8_d3_clone <= sum0_word8_r;
    end if;
  end process;

  ones_greater_than_zeros <= '1' when sum1_word8_d3 > sum0_word8_d3 else
                             '0';

  ones_equal_to_zeros     <= '1' when sum1_word8_d3 = sum0_word8_d3 else
                             '0';


  excess_ones  <= signed('0'& sum1_word8_d3_clone) - signed('0'&sum0_word8_d3_clone); -- 5 bits
  excess_zeros <= signed('0'& sum0_word8_d3_clone) - signed('0'&sum1_word8_d3_clone);
  mult2        <= "000" &     word8_d5(8) & '0';
  mult2_cmpl   <= "000" & not(word8_d5(8))& '0';

  -- cycle 12 releated
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      excess_ones_r  <= excess_ones;
      excess_zeros_r <= excess_zeros;
      mult2_r        <= mult2;
      mult2_cmpl_r   <= mult2_cmpl;

      ones_equal_to_zeros_d1       <= ones_equal_to_zeros;
      ones_greater_than_zeros_d1   <= ones_greater_than_zeros;
    end if;
  end process;

  dc_bias_preA <=  resize(excess_ones_r,  dc_bias_preA'length)  - resize(mult2_cmpl_r, dc_bias_preA'length); 
  dc_bias_preB <=  resize(excess_zeros_r, dc_bias_preB'length)  + resize(mult2_r,      dc_bias_preA'length) ;
  dc_bias_preC <=  resize(excess_zeros_r, dc_bias_preC'length);
  dc_bias_preD <=  resize(excess_ones_r,  dc_bias_preD'length );

  -- cycle 13
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      dc_bias_preA_r <= dc_bias_preA;
      dc_bias_preB_r <= dc_bias_preB;
      dc_bias_preC_r <= dc_bias_preC;
      dc_bias_preD_r <= dc_bias_preD;

      ones_equal_to_zeros_d2       <= ones_equal_to_zeros_d1;
      ones_greater_than_zeros_d2   <= ones_greater_than_zeros_d1;
    end if;
  end process;
  
  dc_bias_A <= dc_bias + resize(dc_bias_preA_r, dc_bias_A'length);
  dc_bias_B <= dc_bias + resize(dc_bias_preB_r, dc_bias_B'length);
  dc_bias_C <= dc_bias + resize(dc_bias_preC_r, dc_bias_C'length);
  dc_bias_D <= dc_bias + resize(dc_bias_preD_r, dc_bias_D'length);
  


  --zero_dc_bias      <= '1' when dc_bias = conv_std_logic_vector(0, 7) else
  zero_dc_bias      <= '1' when dc_bias = to_signed(0, 7) else
                       '0';
  positive_dc_bias  <= not dc_bias(6);
  negative_dc_bias  <=     dc_bias(6);


  select2 <= zero_dc_bias OR ones_equal_to_zeros_d2;
             

  select3 <= (positive_dc_bias and     ones_greater_than_zeros_d2 ) OR
             (negative_dc_bias and not(ones_greater_than_zeros_d2));

  -- cycle 14
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      if(vid_de(14) = '1') then
        if(select2 = '1') then
          if(word8_d7(8) = '0') then
            dc_bias <= dc_bias_C;
          else
            dc_bias <= dc_bias_D;
          end if;
        else
          if(select3 = '1') then
            dc_bias <= dc_bias_B;
          else
            dc_bias <= dc_bias_A;
          end if;
        end if;
      else
        dc_bias <= (others => '0');
      end if;
    end if;
  end process;


  -- cycle 14
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      select2_r <= select2;
      select3_r <= select3;
    end if;
  end process;

  
  -- cycle 15
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      if(select2_r = '1') then
        if(word8_d8(8) = '1') then
          word9_vid <= word9_C;
        else
          word9_vid <= word9_D;
        end if;
      else
        if(select3_r = '1') then
          word9_vid <= word9_B;
        else
          word9_vid <= word9_A;
        end if;
      end if;
    end if;
  end process;

  word9_A(9) <= '0';
  word9_A(8) <= word8_d8(8);
  word9_A(7 downto 0) <= word8_d8(7 downto 0);
  
  word9_B(9) <= '1';
  word9_B(8) <= word8_d8(8);
  word9_B(7 downto 0) <= not(word8_d8(7 downto 0));
  
  word9_C(9) <= not(word8_d8(8));
  word9_C(8) <= word8_d8(8);
  word9_C(7 downto 0) <= word8_d8(7 downto 0);
  
  word9_D(9) <= not(word8_d8(8));
  word9_D(8) <= word8_d8(8);
  word9_D(7 downto 0) <= not(word8_d8(7 downto 0));

  ---------------------------

  -- delay line for video de
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      vid_de(0) <= i_vid_de;

      for I in 0 to 16 loop
        vid_de(I+1) <= vid_de(I);
      end loop;
    end if;
  end process;

  -- delay line for audio de
  process(i_clk)
  begin
    if(i_clk'event and i_clk = '1') then
      aud_de(0) <= i_aud_de;

      for I in 0 to 16 loop 
        aud_de(I+1) <= aud_de(I);
      end loop;
    end if;
  end process;

 -- delay line for audio data
 process(i_clk)
 begin
   if(i_clk'event and i_clk = '1') then
     audio_d1  <= i_audio;
     audio_d2  <= audio_d1;
     audio_d3  <= audio_d2;
     audio_d4  <= audio_d3;
     audio_d5  <= audio_d4;
     audio_d6  <= audio_d5;
     audio_d7  <= audio_d6;
     audio_d8  <= audio_d7;
     audio_d9  <= audio_d8;
     audio_d10 <= audio_d9;
     audio_d11 <= audio_d10;
     audio_d12 <= audio_d11;
     audio_d13 <= audio_d12;
     audio_d14 <= audio_d13;
     audio_d15 <= audio_d14;
   end if;
 end process;

 -- delay line for cntrl data
 process(i_clk)
 begin
   if(i_clk'event and i_clk = '1') then
     cntrl_d1  <= i_cntrl;
     cntrl_d2  <= cntrl_d1;
     cntrl_d3  <= cntrl_d2;
     cntrl_d4  <= cntrl_d3;
     cntrl_d5  <= cntrl_d4;
     cntrl_d6  <= cntrl_d5;
     cntrl_d7  <= cntrl_d6;
     cntrl_d8  <= cntrl_d7;
     cntrl_d9  <= cntrl_d8;
     cntrl_d10 <= cntrl_d9;
     cntrl_d11 <= cntrl_d10;
     cntrl_d12 <= cntrl_d11;
     cntrl_d13 <= cntrl_d12;
     cntrl_d14 <= cntrl_d13;
     cntrl_d15 <= cntrl_d14;
   end if;
 end process;
      

 audio_9  <= "1010011100" when audio_d15 = "0000" else
             "1001100011" when audio_d15 = "0001" else
             "1011100100" when audio_d15 = "0010" else
             "1011100010" when audio_d15 = "0011" else
             "0101110001" when audio_d15 = "0100" else
             "0100011110" when audio_d15 = "0101" else
             "0110001110" when audio_d15 = "0110" else
             "0100111100" when audio_d15 = "0111" else
             "1011001100" when audio_d15 = "1000" else
             "0100111001" when audio_d15 = "1001" else
             "0110011100" when audio_d15 = "1010" else
             "1011000110" when audio_d15 = "1011" else
             "1010001110" when audio_d15 = "1100" else
             "1001110001" when audio_d15 = "1101" else
             "0101100011" when audio_d15 = "1110" else
             "1011000011" when audio_d15 = "1111" else
             "0000000000";


 cntrl_9 <= "1101010100"  when cntrl_d15 = "00" else
            "0010101011"  when cntrl_d15 = "01" else
            "0101010100"  when cntrl_d15 = "10" else
            "1010101011"  when cntrl_d15 = "11" else
            "0000000000";

 -- should be cycle 16
 process(i_clk)
 begin
   if(i_clk'event and i_clk = '1') then
     video <= word9_vid;
     audio <= audio_9;
     cntrl <= cntrl_9;
   end if;
 end process;

 process(i_clk)
 begin
   if(i_clk'event and i_clk = '1') then
     if( vid_de(15) = '1') then
       data <= video;
     elsif( aud_de(15) = '1') then
       data <= audio;
     else
       data <= cntrl;
     end if;
   end if;
 end process;

 process(i_clk)
 begin
   if(i_clk'event and i_clk = '1') then
     o_data <= data;
   end if;
 end process;
     

end rtl;
