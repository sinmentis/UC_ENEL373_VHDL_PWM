----------------------------------------------------------------------------------
-- Engineer: Shun Lyu(48395052) && Ke Gao(89467388)
-- 
-- Create Date: 12.03.2018
-- Design Name: Divider
-- Module Name: duty_set - Behavioral
-- Project Name: PWM generator with 16 bit-downcounter
-- Target Devices: Nexys-4DDR(Artix-7 FPGA)
-- Tool Versions: Vivado 2016.2
-- Description: 
--      This component use to calculate count number for input duty cycle
-- Additional Comments:
--      It's GUD
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity duty_set is
  Port (  clk : in STD_LOGIC;
          period: in UNSIGNED(15 downto 0);
		  duty: in UNSIGNED(7 downto 0);
		  counter_out : out integer);
end duty_set;

architecture Behavioral of duty_set is
begin
process(clk)is
begin
    if clk'event and clk = '1' then
    counter_out <= to_integer(unsigned(period)* unsigned(duty) / 255);
    end if;
end process;
end Behavioral;
