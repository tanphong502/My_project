library ieee;
use ieee.std_logic_1164.all;
entity  DEM_1BIT_BTN is
 port ( ckht,rst,btn: in std_logic;
		  q: out std_logic);
end DEM_1BIT_BTN;
architecture behavioral of DEM_1BIT_BTN is
signal ena_db: std_logic;
begin
CD_LAM_HEP_BTN:  entity work.CD_LAM_HEP_BTN
 port map (ckht=>ckht,
			  btn=>btn,
			  btn_cdlh=> ena_db);
dem_1bit:  entity work.dem_1bit
 port map (ckht=>ckht,
			  rst=>rst,
			  ena_db=> ena_db,
			  q=>q);
end behavioral;