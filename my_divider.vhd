----------------------------------------------------------------------------------
-- Engineer: Shun Lyu(48395052) && Ke Gao(89467388)
-- 
-- Create Date: 18.03.2018 13:30:23
-- Design Name: Divider
-- Module Name: clock_divider - Behavioral
-- Project Name: PWM generator with 16 bit-downcounter
-- Target Devices: Nexys-4DDR(Artix-7 FPGA)
-- Tool Versions: Vivado 2016.2
-- Description: 
--      This component use to divider in put signal into 3 different output with
--      frquency 1000 HZ, 100 HZ and 5 HZ
-- Additional Comments:
--      It's GUD
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is
    Port ( Clk_in : in  STD_LOGIC;
           clr : in STD_LOGIC;
           Clk_out1000 : out  STD_LOGIC;
           Clk_out5 : out  STD_LOGIC;
           Clk_out100 : out STD_LOGIC);
end divider;

architecture Behavioral of divider is
constant limit_1k : std_logic_vector(19 downto 0) := X"0C350";
constant limit_5 : std_logic_vector(27 downto 0) := X"0989680";
constant limit_100 : std_logic_vector(19 downto 0) := X"01388";
signal clk_ctr : std_logic_vector(19 downto 0);
signal clk_ctr_1k : std_logic_vector(27 downto 0);
signal clk_ctr_100 : std_logic_vector(19 downto 0);
signal temp_clk : std_logic;
signal temp_clk_100 : std_logic;
signal temp_clk_1k : std_logic;
begin

 clock_1: process (Clk_in)
 begin
	if Clk_in = '1' and Clk_in'Event then
	   if clk_ctr = limit_1k then
		  temp_clk <= not temp_clk;				
		  clk_ctr <= X"00000";					
	   else								
		  clk_ctr <= clk_ctr + X"00001";
	   end if;
	end if;
 end process clock_1;
	
 clock_2: process (Clk_in)   
 begin
    if Clk_in = '1' and Clk_in'Event then
       if clk_ctr_1k = limit_5 then
          temp_clk_1k <= not temp_clk_1k;                
          clk_ctr_1k <= X"0000000";                    
       else                                
          clk_ctr_1k <= clk_ctr_1k + X"0000001";
       end if;
    end if;
 end process clock_2;
 
 clock_3: process (Clk_in)
 begin
    if Clk_in = '1' and Clk_in'Event then
       if clk_ctr_100 = limit_100 then
          temp_clk_100 <= not temp_clk_100;                
          clk_ctr_100 <= X"00000";                    
       else                                
          clk_ctr_100 <= clk_ctr_100 + X"00001";
       end if;
    end if;
 end process clock_3;
 Clk_out1000 <= temp_clk;	
 Clk_out5 <= temp_clk_1k;
 Clk_out100 <= temp_clk_100;

 
end Behavioral;