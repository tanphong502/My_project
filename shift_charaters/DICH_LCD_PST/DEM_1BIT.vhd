library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity dem_1bit is
port(ena_db,ckht,rst:in std_logic;
		q:out std_logic);
end dem_1bit;
architecture behavioral of dem_1bit is
signal q_reg, q_next: std_logic;
begin
	 process(ckht,rst)
	 begin
		if rst='1' then q_reg<='0';
		elsif falling_edge(ckht) then q_reg <= q_next;
		end if;
	end process;
	q_next<=NOT q_reg when ena_db='1' else
				q_reg;
	q<=q_reg;
end behavioral;