library ieee;
use ieee.std_logic_1164.all;
entity lam_hep_xung is
port(ckht,d:in std_logic;
		q:out std_logic);
end lam_hep_xung;
architecture behavioral of lam_hep_xung is
signal qff: std_logic;
begin
 process(ckht)
 begin
	if falling_edge(ckht) then qff<=d;
	end if;
	end process;
	q<=(not qff) and d;
end behavioral;