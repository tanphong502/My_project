library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity  chia_10ena_1hz_1mhz is
 port ( ckht: in std_logic;
		  ena1hz,ena2hz,ena5hz,ena10hz,ena20hz,ena25hz,ena50hz,ena100hz,ena1khz,ena1mhz: out std_logic);
end chia_10ena_1hz_1mhz;
architecture behavioral of chia_10ena_1hz_1mhz is
constant n: integer:=50000000; --tan so xung ck 50Mz
signal d1mhz_reg, d1mhz_next: integer range 0 to N/1000000:=1;
signal d1khz_reg, d1khz_next: integer range 0 to N/1000:=1;
signal d100hz_reg, d100hz_next: integer range 0 to N/100:=1;
signal d50hz_reg, d50hz_next: integer range 0 to N/50:=1;
signal d25hz_reg, d25hz_next: integer range 0 to N/25:=1;
signal d20hz_reg, d20hz_next: integer range 0 to N/20:=1;
signal d10hz_reg, d10hz_next: integer range 0 to N/10:=1;
signal d5hz_reg, d5hz_next: integer range 0 to N/5:=1;
signal d2hz_reg, d2hz_next: integer range 0 to N/2:=1;
signal d1hz_reg, d1hz_next: integer range 0 to N/1:=1;
begin 
 --register
  process(ckht)
  begin
		if falling_edge(ckht) then d1mhz_reg <= d1mhz_next;
											d1khz_reg <= d1khz_next;
											d100hz_reg <= d100hz_next;
											d50hz_reg <= d50hz_next;
											d25hz_reg <= d25hz_next;
											d20hz_reg <= d20hz_next;
											d10hz_reg <= d10hz_next;
											d5hz_reg <= d5hz_next;
											d2hz_reg <= d2hz_next;
											d1hz_reg <= d1hz_next;
											
		end if;
	end process;	
	
	
 --next state logic
 d1hz_next<=1 when d1hz_reg=N/1 else d1hz_reg+1;
 d2hz_next<=1 when d2hz_reg=N/2 else d2hz_reg+1;
 d5hz_next<=1 when d5hz_reg=N/3 else d5hz_reg+1;
 d10hz_next<=1 when d10hz_reg=N/10 else d10hz_reg+1;
 d20hz_next<=1 when d20hz_reg=N/20 else d20hz_reg+1;
 d25hz_next<=1 when d25hz_reg=N/25 else d25hz_reg+1;
 d50hz_next<=1 when d50hz_reg=N/50 else d50hz_reg+1;
 d100hz_next<=1 when d100hz_reg=N/100 else d100hz_reg+1;
 d1khz_next<=1 when d1khz_reg=N/1000 else d1khz_reg+1;
 d1mhz_next<=1 when d1mhz_reg=N/1000000 else d1mhz_reg+1;
 
 
 -- output logic
	ena1hz<='1' when d1hz_reg=N/(1*2) else '0';
	ena2hz<='1' when d2hz_reg=N/(2*2) else '0';
	ena5hz<='1' when d5hz_reg=N/(5*2) else '0';
	ena10hz<='1' when d10hz_reg=N/(10*2) else '0';
	ena20hz<='1' when d20hz_reg=N/(20*2) else '0';
	ena25hz<='1' when d25hz_reg=N/(25*2) else '0';
	ena50hz<='1' when d50hz_reg=N/(50*2) else '0';
	ena100hz<='1' when d100hz_reg=N/(100*2) else '0';
	ena1khz<='1' when d1khz_reg=N/(1000*2) else '0';
	ena1mhz<='1' when d1mhz_reg=N/(1000000*2) else '0';


end behavioral;