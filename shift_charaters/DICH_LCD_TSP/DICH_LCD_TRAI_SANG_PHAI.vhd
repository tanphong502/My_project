--CAC KI TU CHAR15-CHAR0 LA KI TU CAC BAN MUON CHAY, SO LUONG CAC CHAR LA KHONG BAT BUOC
--NHUNG CHO CAN CHINH SUA CO DAU --#######
library  ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DICH_LCD_TRAI_SANG_PHAI is 
	port( ckht: in std_logic;
			rst,ena_db,ena_ss,oe: in std_logic;
			data0,data1,data2,data3,data4,data5,data6,data7: out std_logic_vector(7 downto 0);
			data8,data9,data10,data11,data12,data13,data14,data15: out std_logic_vector(7 downto 0));
end DICH_LCD_TRAI_SANG_PHAI;
architecture behavioral of DICH_LCD_TRAI_SANG_PHAI is 
CONSTANT N:INTEGER:=16;                                                             --##### so ki tu
constant char15: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('D'),8);
constant char14: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('A'),8);
constant char13: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('N'),8);
constant char12: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('G'),8);
constant char11: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS(' '),8);
constant char10: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('T'),8);
constant char9: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('A'),8);
constant char8: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('N'),8);
constant char7: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS(' '),8);
constant char6: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('P'),8);
constant char5: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('H'),8);
constant char4: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('O'),8);
constant char3: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('N'),8);
constant char2: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('G'),8);
constant char1: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS(' '),8);
constant char0: std_logic_vector:=CONV_STD_LOGIC_VECTOR(CHARACTER'POS('W'),8);

constant char_len: integer:=N*8;					
constant n_step: integer:=16+N;						
signal char_one: std_logic_vector(127 downto 0):=X"20"&X"20"&X"20"&X"20"&X"20"&X"20"&X"20"&X"20"&X"20"&X"20"&X"20"&X"20"&X"20"&X"20"&X"20"&X"20";
signal char_ext_org, char_ext_next,char_ext_reg: std_logic_vector(char_len+127 downto 0);
signal count_next, count_reg: integer range 0 to n_step:=0;
begin
	char_ext_org<=char15 & char14 & char13 & char12 & char11 & char10 & char9 & char8 & char7 & char6 & char5 & char4 & char3 & char2 & char1 & char0 & char_one ;
	--register
	process(ckht,rst)
	begin
		if rst ='1' then 	char_ext_reg	<=	char_ext_org;
								count_reg<=0;
		elsif falling_edge(ckht) then char_ext_reg<= char_ext_next;
												count_reg<=count_next;
		end if;
	end process;
	--next state
	char_ext_next<=X"20" & char_ext_reg(char_len+127 downto 8) when count_reg<n_step and ena_db='1' and ena_ss='1' else
						char_ext_org when count_reg=n_step else
						char_ext_reg;
	count_next<= count_reg+1 when count_reg<n_step and ena_db='1' and ena_ss='1' else
						0 when count_reg=n_step else
						count_reg;
						
	data15<= char_ext_reg(127 downto 120) when oe='1' else (others=>'0');
	data14<= char_ext_reg(119 downto 112) when oe='1' else (others=>'0');					
	data13<= char_ext_reg(111 downto 104) when oe='1' else (others=>'0');
	data12<= char_ext_reg(103 downto 96)  when oe='1' else (others=>'0');					
	data11<= char_ext_reg(95 downto 88)   when oe='1' else (others=>'0');
	data10<= char_ext_reg(87 downto 80)   when oe='1' else (others=>'0');					
	data9<= char_ext_reg(79 downto 72)    when oe='1' else (others=>'0');
	data8<= char_ext_reg(71 downto 64)    when oe='1' else (others=>'0');					
	data7<= char_ext_reg(63 downto 56)    when oe='1' else (others=>'0');
	data6<= char_ext_reg(55 downto 48)    when oe='1' else (others=>'0');				
	data5<= char_ext_reg(47 downto 40)    when oe='1' else (others=>'0');
	data4<= char_ext_reg(39 downto 32)    when oe='1' else (others=>'0');				
	data3<= char_ext_reg(31 downto 24)    when oe='1' else (others=>'0');
	data2<= char_ext_reg(23 downto 16)    when oe='1' else (others=>'0');				
   data1<= char_ext_reg(15 downto 8)     when oe='1' else (others=>'0');
	data0<= char_ext_reg(7 downto 0)      when oe='1' else (others=>'0');
end behavioral;