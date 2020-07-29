library ieee;
use ieee.std_logic_1164.all;
entity  cd_lam_hep_btn is
 port ( ckht,btn: in std_logic;
		  btn_cdlh: out std_logic);
end cd_lam_hep_btn;
architecture behavioral of cd_lam_hep_btn is
signal ena_d: std_logic;
begin
debounce_btn:  entity work.debounce_btn
 port map (ckht=>ckht,
			  btn=>btn,
			  db_tick=> ena_d);
lam_hep_xung:  entity work.lam_hep_xung
 port map (ckht=>ckht,
			  d=>ena_d,
			  q=>btn_cdlh);
end behavioral;