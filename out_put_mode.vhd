----------------------------------------------------------------------------------
-- Engineer: Shun Lyu(48395052) && Ke Gao(89467388)
-- 
-- Create Date: 12.03.2018
-- Design Name: Divider
-- Module Name: out_put_mode - Behavioral
-- Project Name: PWM generator with 16 bit-downcounter
-- Target Devices: Nexys-4DDR(Artix-7 FPGA)
-- Tool Versions: Vivado 2016.2
-- Description: 
--      This component use select the output signal between
--      High-Low-PWM
-- Additional Comments:
--      It's GUD
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity out_put_mode is
 Port ( button : in std_logic;
        high_count : in integer;
        current_count: in unsigned (15 downto 0);
        period : in unsigned(15 downto 0);
        clk : in std_logic;
        wave_out : out std_logic;
        mode_debug_LED : out std_logic;
        counter_reset : out std_logic
       );
end out_put_mode;

architecture Behavioral of out_put_mode is
signal mode_flag : unsigned(1 downto 0);

    begin
    process(button, clk, mode_flag) is
        begin
        if (clk'event and clk = '1') then

            -- change mode if buttonC pressed
            if button = '1' then
                mode_flag <= (mode_flag + 1) mod 3;
            end if;
            
            -- generate PWM
            if mode_flag = 0 then
                mode_debug_LED <= '1';
                if current_count <= high_count then
                    wave_out <= '1';
                else
                    wave_out <= '0';
                end if;
            -- generate LOW
            else if mode_flag = 1 then
                mode_debug_LED <= '0';
                wave_out <= '0';
            -- generate HIGH
            else
                mode_debug_LED <= '0';
                wave_out <= '1';
            end if;
        end if;
        end if;
    end process;
end Behavioral;
