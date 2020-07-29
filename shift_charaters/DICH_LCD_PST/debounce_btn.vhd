library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity debounce_btn is
port(ckht,btn:in std_logic;
		db_tick:out std_logic);
end debounce_btn;
architecture behavioral of debounce_btn is
constant n: integer:=20;
type db_state is (zero,wait0,one,wait1);
signal db_reg, db_next: db_state;
signal delay_reg,delay_next: unsigned(n-1 downto 0);
begin
	process(ckht)
	begin
		if falling_edge(ckht) then db_reg<= db_next;
								   delay_reg<=delay_next;
		end if;
	end process;
	
	process(delay_reg,db_reg,btn)
	begin
		delay_next<=delay_reg;
		db_next<=db_reg;
	case db_reg is
		when zero => db_tick <= '0';
					if (btn='1') then db_next<=wait1;
									 delay_next<=(others=>'1');
					end if;
		when wait1 => db_tick <= '0';
					if (btn='1') then delay_next<=delay_reg-1;
						if (delay_reg=0) then db_next<= one;
						end if;
					else  db_next<=zero;
					end if;
		when one => db_tick <= '1';
					if (btn='0') then db_next<=wait0;
									delay_next<=(others=>'1');
					end if;
		when wait0 => db_tick <= '1';
					if (btn='0') then delay_next<=delay_reg-1;
						if (delay_reg=0) then db_next<= zero;
						end if;
					else  db_next<=one;
					end if;
	end case;
	end process;
end behavioral;