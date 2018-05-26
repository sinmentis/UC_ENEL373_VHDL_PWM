----------------------------------------------------------------------------------
-- Engineer: Shun Lyu(48395052) && Ke Gao(89467388)
-- 
-- Create Date: 12.03.2018
-- Design Name: Divider
-- Module Name: counter - Behavioral
-- Project Name: PWM generator with 16 bit-downcounter
-- Target Devices: Nexys-4DDR(Artix-7 FPGA)
-- Tool Versions: Vivado 2016.2
-- Description: 
--      This component use to downcount from a input number
--      Update the current number to output port
-- Additional Comments:
--      It's GUD
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    Port ( clk, reset : in STD_LOGIC;
           max_number : in UNSIGNED (15 downto 0);
           q_count : out UNSIGNED (15 downto 0) );
           
end counter;

architecture Behavioral of counter is
signal current_count : UNSIGNED (15 downto 0);
begin
process(reset, clk)is
begin
  if(clk'event and clk ='1')then
    if(current_count=X"0000")then
       current_count <= max_number;
    else
       current_count <= current_count - 1;
    end if;
  end if;
  end process;
   q_count <= current_count;
end Behavioral;
