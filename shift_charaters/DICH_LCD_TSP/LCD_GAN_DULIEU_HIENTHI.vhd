library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

entity LCD_GAN_DULIEU_HIENTHI is
    Port ( 	data0,data1,data2,data3,data4,data5,data6,data7: in std_logic_vector(7 downto 0);
			data8,data9,data10,data11,data12,data13,data14,data15: in std_logic_vector(7 downto 0);
				LCD_HANG_1: out  STD_LOGIC_VECTOR (127 downto 0);
	         LCD_HANG_2: out  STD_LOGIC_VECTOR (127 downto 0));
end LCD_GAN_DULIEU_HIENTHI;

architecture Behavioral of LCD_GAN_DULIEU_HIENTHI is
begin
-- HANG 1  
	 LCD_HANG_1(7 DOWNTO 0)			<= CONV_STD_LOGIC_VECTOR(character'pos('D'),8);
	 LCD_HANG_1(15 DOWNTO 8)		<= CONV_STD_LOGIC_VECTOR(character'pos('I'),8);
	 LCD_HANG_1(23 DOWNTO 16)		<= CONV_STD_LOGIC_VECTOR(character'pos('C'),8);
	 LCD_HANG_1(31 DOWNTO 24)		<= CONV_STD_LOGIC_VECTOR(character'pos('H'),8);
	 LCD_HANG_1(39 DOWNTO 32)		<= CONV_STD_LOGIC_VECTOR(character'pos(' '),8);
	 LCD_HANG_1(47 DOWNTO 40)		<= CONV_STD_LOGIC_VECTOR(character'pos('K'),8);
	 LCD_HANG_1(55 DOWNTO 48)		<= CONV_STD_LOGIC_VECTOR(character'pos('I'),8);
	 LCD_HANG_1(63 DOWNTO 56)		<= CONV_STD_LOGIC_VECTOR(character'pos(' '),8);
	 LCD_HANG_1(71 DOWNTO 64)		<= CONV_STD_LOGIC_VECTOR(character'pos('T'),8);	 
	 LCD_HANG_1(79 DOWNTO 72)		<= CONV_STD_LOGIC_VECTOR(character'pos('U'),8);
	 LCD_HANG_1(87 DOWNTO 80)		<= CONV_STD_LOGIC_VECTOR(character'pos(':'),8);
	 LCD_HANG_1(95 DOWNTO 88)		<= CONV_STD_LOGIC_VECTOR(character'pos(' '),8);
	 LCD_HANG_1(103 DOWNTO 96)		<= CONV_STD_LOGIC_VECTOR(character'pos(' '),8);
	 LCD_HANG_1(111 DOWNTO 104)	<= X"20";
	 LCD_HANG_1(119 DOWNTO 112)	<= X"20";
	 LCD_HANG_1(127 DOWNTO 120)	<= X"20";
-- HANG 2	 
	 LCD_HANG_2(7 DOWNTO 0)			<= data15;
	 LCD_HANG_2(15 DOWNTO 8)		<= data14;
	 LCD_HANG_2(23 DOWNTO 16)		<= data13;
	 LCD_HANG_2(31 DOWNTO 24)		<= data12; 
	 LCD_HANG_2(39 DOWNTO 32)		<= data11;
	 LCD_HANG_2(47 DOWNTO 40)		<= data10;
	 LCD_HANG_2(55 DOWNTO 48)		<= data9;
	 LCD_HANG_2(63 DOWNTO 56)		<= data8;
	 LCD_HANG_2(71 DOWNTO 64)		<= data7;
	 LCD_HANG_2(79 DOWNTO 72)		<= data6;
	 LCD_HANG_2(87 DOWNTO 80)		<= data5;
	 LCD_HANG_2(95 DOWNTO 88)		<= data4;
	 LCD_HANG_2(103 DOWNTO 96)		<= data3;
	 LCD_HANG_2(111 DOWNTO 104)	<= data2;
	 LCD_HANG_2(119 DOWNTO 112)	<= data1;
	 LCD_HANG_2(127 DOWNTO 120)	<= data0;	

end Behavioral;

