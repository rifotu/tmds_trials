------------------------------------------------------------------------------
-- Copyright (c) 2009 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.0
--  \   \        Filename: tb_s6_axiom.vhd
--  /   /        Date Last Modified:  November 5 2009
-- /___/   /\    Date Created: June 1 2009
-- \   \  /  \
--  \___\/\___\
-- 
--Device: 	Spartan 6
--Purpose:  	Test Bench
--Reference:
--    
--Revision History:
--    Rev 1.0 - First created (nicks)
--
------------------------------------------------------------------------------
--
--  Disclaimer: 
--
--		This disclaimer is not a license and does not grant any rights to the materials 
--              distributed herewith. Except as otherwise provided in a valid license issued to you 
--              by Xilinx, and to the maximum extent permitted by applicable law: 
--              (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, 
--              AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
--              INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
--              FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether in contract 
--              or tort, including negligence, or under any other theory of liability) for any loss or damage 
--              of any kind or nature related to, arising under or in connection with these materials, 
--              including for any direct, or any indirect, special, incidental, or consequential loss 
--              or damage (including loss of data, profits, goodwill, or any type of loss or damage suffered 
--              as a result of any action brought by a third party) even if such damage or loss was 
--              reasonably foreseeable or Xilinx had been advised of the possibility of the same.
--
--  Critical Applications:
--
--		Xilinx products are not designed or intended to be fail-safe, or for use in any application 
--		requiring fail-safe performance, such as life-support or safety devices or systems, 
--		Class III medical devices, nuclear facilities, applications related to the deployment of airbags,
--		or any other applications that could lead to death, personal injury, or severe property or 
--		environmental damage (individually and collectively, "Critical Applications"). Customer assumes 
--		the sole risk and liability of any use of Xilinx products in Critical Applications, subject only 
--		to applicable laws and regulations governing limitations on product liability.
--
--  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


library work;
use work.sub_module_components.all;


entity tb_s6_axiom is end tb_s6_axiom ;

architecture sim of tb_s6_axiom is


signal rst	        : std_logic := '1' ;
signal enc_pipelined    : std_logic_vector(9 downto 0);
signal enc_pipe_verilog : std_logic_vector(9 downto 0);
signal enc              : std_logic_vector(9 downto 0);
signal board_clk        : std_logic := '0';

begin

board_clk <= not board_clk after 4 nS ;		-- local clock

rst <= '0' after 150 nS;


i_top_encoder_tst: top_encoder_tst 
port map(

      i_clk         => board_clk, --: in std_logic;
      i_rst         => rst, --: in std_logic;

      o_pipe_data   => enc_pipelined, --: out std_logic_vector(9 downto 0);
      o_pipe_verilog => enc_pipe_verilog, -- out std_logic_vector(9 downto 0);
      o_single_data => enc  --: out std_logic_vector(9 downto 0)
);  



end sim ;
