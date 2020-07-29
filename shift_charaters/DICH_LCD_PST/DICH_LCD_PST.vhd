library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
ENTITY DICH_LCD_PST IS 
PORT(
	CKHT,SW0: IN STD_LOGIC;
	BTN_N:IN STD_LOGIC_VECTOR(1 dowNTO 0) ;
	LCD_E, LCD_RS, LCD_RW,LCD_ON: OUT STD_LOGIC;
	LCD_DB: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END DICH_LCD_PST;

ARCHITECTURE BEHAVIORAL OF DICH_LCD_PST IS
SIGNAL LCD_HANG_1: STD_LOGIC_VECTOR(127 DOWNTO 0);
SIGNAL LCD_HANG_2: STD_LOGIC_VECTOR(127 DOWNTO 0);
SIGNAL RST,ena_ss,ena_db,btn1: STD_LOGIC;
signal data0,data1,data2,data3,data4,data5,data6,data7: std_logic_vector(7 downto 0);
signal data8,data9,data10,data11,data12,data13,data14,data15: std_logic_vector(7 downto 0);
BEGIN
	LCD_RW <= '0';
	RST <= NOT BTN_N(0) ;
	btn1<= not btn_n(1);
	LCD_ON <= '1';
CHIA_10ENA_1HZ_1MHZ:  entity work.CHIA_10ENA_1HZ_1MHZ
 port map (ckht=>ckht,
			  ena1hz=>ena_db);
DEM_1BIT_BTN:  entity work.DEM_1BIT_BTN
 port map (ckht=>ckht,
			  rst=>rst,
			  btn=>btn1,
			  q=>ena_ss);
DICH_LCD_PHAI_SANG_TRAI: ENTITY WORK.DICH_LCD_PHAI_SANG_TRAI
PORT MAP( ckht=>ckht,
			 ena_db=>ena_db,
			 rst=>rst,
			 oe=>sw0,
			 ena_ss=>ena_ss,
			 data0 => data0,
			 data1 => data1,
			 data2 => data2,
			 data3 => data3,
			 data4 => data4,
			 data5 => data5,
			 data6 => data6,
			 data7 => data7,
			 data8 => data8,
			 data9 => data9,
			 data10=> data10,
			 data11=> data11,
			 data12=> data12,
			 data13=> data13,
			 data14=> data14,
			 data15=> data15);
LCD_GAN_DULIEU_HIENTHI: ENTITY WORK.LCD_GAN_DULIEU_HIENTHI
PORT MAP( data0 => data0,
			 data1 => data1,
			 data2 => data2,
			 data3 => data3,
			 data4 => data4,
			 data5 => data5,
			 data6 => data6,
			 data7 => data7,
			 data8 => data8,
			 data9 => data9,
			 data10=> data10,
			 data11=> data11,
			 data12=> data12,
			 data13=> data13,
			 data14=> data14,
			 data15=> data15,
			 LCD_HANG_1 => LCD_HANG_1,
			 LCD_HANG_2 => LCD_HANG_2);
LCD_KHOITAO_HIENTHI: ENTITY WORK.LCD_KHOITAO_HIENTHI
PORT MAP(LCD_DB => LCD_DB,
			LCD_RS => LCD_RS,
			LCD_E => LCD_E,
			LCD_RST => RST,
			LCD_CK => CKHT,
			LCD_HANG_1 => LCD_HANG_1,
			LCD_HANG_2 => LCD_HANG_2);
END BEHAVIORAL;