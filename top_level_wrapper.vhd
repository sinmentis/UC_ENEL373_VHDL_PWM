----------------------------------------------------------------------------------
-- Engineer: Shun Lyu(48395052) && Ke Gao(89467388)
-- 
-- Create Date: 18.03.2018 13:30:23
-- Design Name: Divider
-- Project Name: PWM generator with 16 bit-downcounter
-- Target Devices: Nexys-4DDR(Artix-7 FPGA)
-- Tool Versions: Vivado 2016.2
-- Description: 
--      Bind everything together
--      Output signal Port JA(1) and LED17_R
--      Button L: Read from switch (0 to 15) and set the Period
--      Button R: Read from switch(0 to 7) and set the duty percentage
--      Button C: Changeing mode between HIGH-LOW-PMW
--      Button U: Changeing counting Rate between 1000HZ-100HZ-5HZ
--      Switch: Use to set up the input number
--      LED: Once the buttonL or button R pressed, update current switch number
--      LED17_R: Same as the output Port JA(1), Light when the signal is high
--      LED16_B: Only on when PWM mode is on.
--      JA(1) : Provided the output port for debug
-- Additional Comments:
--      It's GUD
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main_function is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW : in UNSIGNED (15 downto 0);
           BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNU : in STD_LOGIC;           
           LED  : out UNSIGNED (15 downto 0);
           LED17_R : out STD_LOGIC;
           LED16_B : out STD_LOGIC;
           JA : out UNSIGNED (1 to 10)
           );
end main_function;

architecture Behavioral of main_function is

component divider
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out1000 : out  STD_LOGIC;
           Clk_out5 : out  STD_LOGIC;
           Clk_out100 : out  STD_LOGIC);
    end component;

component IO_controller
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
           data_out_R : out UNSIGNED (7 downto 0);
           LED_out : out Unsigned(15 downto 0);
           reset_counter : out STD_LOGIC);
    end component;
    
component counter
    Port ( clk, reset : in STD_LOGIC;
           max_number : in UNSIGNED (15 downto 0);
           q_count : out UNSIGNED (15 downto 0));
    end component;
      
component duty_set 
    Port ( clk : in STD_LOGIC;
           period: in UNSIGNED(15 downto 0);
           duty: in UNSIGNED(7 downto 0);
           counter_out : out integer);
    end component;
      
component out_put_mode is
    Port ( button : in std_logic;
           high_count : in integer;
           current_count: in unsigned (15 downto 0);
           period : in unsigned(15 downto 0);
           clk : in std_logic;
           wave_out : out std_logic;
           mode_debug_LED : out std_logic;
           counter_reset : out std_logic);
      end component;
      
signal divider_to_counter: std_logic;
signal re: std_logic;
signal period_read: UNSIGNED(15 downto 0);
signal duty_read : UNSIGNED (7 downto 0);
signal clk_5_s : std_logic;
signal clk_100_s : std_logic;
signal clk_1000_s : std_logic;
signal count_p : unsigned (15 downto 0);
signal high_time_limit : integer;
signal output_wave : std_logic;

begin
u1: divider
    port map(Clk_in => CLK100MHZ, Clk_out5 => clk_5_s, Clk_out100 => clk_100_s, Clk_out1000 => Clk_1000_s);
    
u2: IO_controller
    port map(reset_counter => re, data_in => SW, clk => CLK100MHZ, reset => re, data_out_L => period_read , data_out_R => duty_read, enable_L => BTNL, enable_R => BTNR, enable_U => BTNU, LED_out => LED, clk_5 =>clk_5_s, clk_100 => clk_100_s, clk_1000 => clk_1000_s, clk_to_counter => divider_to_counter);

u3: counter
    port map(clk => divider_to_counter, reset => re, max_number => period_read, q_count => count_p);

u4: out_put_mode
    port map(button => BTNC, high_count => high_time_limit, current_count => count_p, period => period_read,clk => clk_5_s, wave_out => output_wave, mode_debug_LED => LED16_B, counter_reset => re); -- pwm_bus
      
u5: duty_set
    port map(clk => CLK100MHZ, period => period_read, duty => duty_read, counter_out => high_time_limit);


JA(1) <= output_wave;
LED17_R <= output_wave;
end Behavioral;
