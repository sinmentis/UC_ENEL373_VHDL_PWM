----------------------------------------------------------------------------------
-- Engineer: Shun Lyu(48395052) && Ke Gao(89467388)
-- 
-- Create Date: 12.05.2018
-- Design Name: Divider
-- Module Name: IO_controller - Behavioral
-- Project Name: PWM generator with 16 bit-downcounter
-- Target Devices: Nexys-4DDR(Artix-7 FPGA)
-- Tool Versions: Vivado 2016.2
-- Description: 
--      This component use to read button and controll the output signal
--      between 1000HZ, 100HZ and 5HZ
-- Additional Comments:
--      It's GUD
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IO_controller is
    Port ( data_in : in UNSIGNED (15 downto 0);
           clk, reset :in STD_LOGIC;
           enable_L : in STD_LOGIC;
           enable_R : in STD_LOGIC;
           enable_U : in STD_LOGIC;
           clk_5 : in STD_LOGIC;
           clk_100 : in STD_LOGIC;
           clk_1000 : in STD_LOGIC;
           clk_to_counter : out STD_LOGIC;
           data_out_L : out UNSIGNED (15 downto 0);
           data_out_R : out unsigned (7 downto 0);
           LED_out : out Unsigned(15 downto 0);
           reset_counter : out STD_LOGIC);
end IO_controller;

architecture Behavioral of IO_controller is
signal data_register : UNSIGNED (15 downto 0);
signal clk_mode : UNSIGNED (3 downto 0);
signal period_out: unsigned(15 downto 0);
signal duty_out: unsigned(7 downto 0);
begin
process(clk, enable_L, enable_R, reset)
begin
     if(reset = '1') then
        data_register <= X"0000";
     elsif(clk'Event and clk = '1') then
          if(data_register = X"0000") then
             data_register <= X"8000";
          end if;
          
          -- mode switch
           if clk_mode = 1 then
               clk_to_counter <= clk_5;
           elsif(clk_mode = 2) then
               clk_to_counter <= clk_100;
           else
               clk_to_counter <= clk_1000;
           end if;
           
           -- Debug LED only light when PWM mode
          if(enable_L = '1') then
             data_register <= data_in;
             period_out <= data_register;
             LED_out <= data_register;
          elsif(enable_R = '1') then
             data_register <= data_in;
             duty_out <= data_register(7 downto 0);
             LED_out <= data_register;
          elsif(enable_U = '1') then
             clk_mode <= (clk_mode + 1) mod 3;
          end if;

     end if;
     data_out_L <= period_out;
     data_out_R <= duty_out;
     end process;
        
end Behavioral;
