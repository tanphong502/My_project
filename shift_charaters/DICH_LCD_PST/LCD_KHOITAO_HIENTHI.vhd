library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;


entity LCD_KHOITAO_HIENTHI is
PORT(
       LCD_HANG_1: IN STD_LOGIC_VECTOR(127 DOWNTO 0);
		 LCD_HANG_2: IN STD_LOGIC_VECTOR(127 DOWNTO 0);
		 LCD_DB: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 LCD_RS,LCD_E: OUT STD_LOGIC;
		 LCD_CK,LCD_RST: IN STD_LOGIC
);
end LCD_KHOITAO_HIENTHI;

architecture Behavioral of LCD_KHOITAO_HIENTHI is
TYPE LCD_MACHINE IS(
                      LCD_INITIAL,
							 LCD_CGRAM_ADDRESS,
							 LCD_CGRAM_DATA,
							 LCD_ADDRESS_L1,
							 LCD_DATA_L1,
							 LCD_ADDRESS_L2,
							 LCD_DATA_L2,
							 LCD_STOP
);
SIGNAL LCD_STATE: LCD_MACHINE:=LCD_INITIAL;
TYPE LCD_CMD_TABLE IS ARRAY (INTEGER RANGE 0 TO 5) OF STD_LOGIC_VECTOR(8 DOWNTO 0);
CONSTANT LCD_CMD: LCD_CMD_TABLE:=(0=> '0'&X"00",
                                  1=> '0'&X"3C",--FUNCTION SET
											 2=> '0'&X"0C",--DISLAY CONTROL
											 3=> '0'&X"01",--CLEAR
											 4=> '0'&X"02",--RETURN HOME
											 5=> '0'&X"06");--ENTRY MODE SET
SIGNAL LCD_CMD_PTR: INTEGER RANGE 0 TO 15:=0;

TYPE LCD_CGRAM_TABLE IS ARRAY (INTEGER RANGE 0 TO 63) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
CONSTANT LCD_CGRAM: LCD_CGRAM_TABLE:= (
	X"07", X"0F", X"1F", X"1F", X"1F", X"1F", X"1F", X"1F",---F-0
	X"1F", X"1F", X"1F", X"00", X"00", X"00", X"00", X"00",---A-1
	X"1C", X"1E", X"1F", X"1F", X"1F", X"1F", X"1F", X"1F",---B-2
	X"00", X"00", X"00", X"00", X"00", X"1F", X"1F", X"1F",---D-3
	X"1F", X"1F", X"1F", X"1F", X"1F", X"1F", X"1E", X"1C",---C-4
	X"1F", X"1F", X"1F", X"1F", X"1F", X"1F", X"0F", X"07",---E-5
	X"1F", X"1F", X"1F", X"00", X"00", X"00", X"1F", X"1F",---G+D-6
	X"1F", X"1F", X"1F", X"1F", X"1F", X"1F", X"1F", X"1F"---I-7
); 


SIGNAL LCD_CGRAM_PTR: INTEGER RANGE 0 TO LCD_CGRAM'HIGH:=0;

TYPE LCD_DIS_L1 IS ARRAY (INTEGER RANGE 0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL LCD_DIS1:LCD_DIS_L1;
TYPE LCD_DIS_L2 IS ARRAY (INTEGER RANGE 0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL LCD_DIS2:LCD_DIS_L2;
SIGNAL LCD_DIS_PTR: INTEGER RANGE 0 TO 15:=0;
SIGNAL LCD_DELAY: INTEGER RANGE 0 TO 1000000:=0;
SIGNAL LCD_RS_DB: STD_LOGIC_VECTOR(8 DOWNTO 0):='0'&X"00";
SIGNAL LCD_ENABLE: STD_LOGIC:='0';
begin
  PROCESS(LCD_HANG_1,LCD_HANG_2)
  BEGIN
    FOR I IN 0 TO 15
	 LOOP
	     LCD_DIS1(I) <=LCD_HANG_1((I*8+7) DOWNTO I*8);
        LCD_DIS2(I) <=LCD_HANG_2((I*8+7) DOWNTO I*8);
	 END LOOP;
  END PROCESS;
  
  PROCESS(LCD_CK,LCD_DELAY,LCD_RST)
  BEGIN
  IF LCD_RST='1' THEN LCD_STATE<=LCD_INITIAL;
                      LCD_DELAY<=0;
							 LCD_CMD_PTR<=0;
							 LCD_DIS_PTR<=0;
							 LCD_CGRAM_PTR <= 0;
	ELSIF FALLING_EDGE(LCD_CK) THEN
	   CASE LCD_STATE IS
		  WHEN LCD_INITIAL=>  LCD_DELAY<=LCD_DELAY+1;
		                      IF LCD_DELAY = 164000 THEN LCD_DELAY<=0;
									    IF (LCD_CMD_PTR= LCD_CMD'HIGH) THEN 
										                                       LCD_STATE<=LCD_CGRAM_ADDRESS;
											ELSE	
                                    											LCD_CMD_PTR<=LCD_CMD_PTR+1;
											END IF;
									ELSIF(LCD_DELAY=30) THEN LCD_ENABLE<='0';
									ELSIF(LCD_DELAY=5)  THEN LCD_ENABLE<='1';
									ELSE                     LCD_RS_DB<=LCD_CMD(LCD_CMD_PTR);
									END IF;
			WHEN LCD_CGRAM_ADDRESS => LCD_DELAY<=LCD_DELAY+1;
		                       IF LCD_DELAY=5000 THEN LCD_DELAY<=0;
									                         LCD_STATE<=LCD_CGRAM_DATA;
																	 LCD_DIS_PTR<=0;
									  ELSIF (LCD_DELAY=30)THEN LCD_ENABLE<='0';
								     ELSIF(LCD_DELAY=5)  THEN LCD_ENABLE<='1';
									  ELSE                     LCD_RS_DB<='0'&X"40";
									  END IF;
			WHEN LCD_CGRAM_DATA=>    LCD_DELAY<=LCD_DELAY+1;
		                      IF LCD_DELAY=5000 THEN LCD_DELAY<=0;
									    IF (LCD_CGRAM_PTR= LCD_CGRAM'HIGH) THEN 
										                                       LCD_STATE<=LCD_ADDRESS_L1;
											ELSE	
                                    											LCD_CGRAM_PTR<=LCD_CGRAM_PTR+1;
											END IF;
									ELSIF(LCD_DELAY=30) THEN LCD_ENABLE<='0';
									ELSIF(LCD_DELAY=5)  THEN LCD_ENABLE<='1';
									ELSE                     LCD_RS_DB<='1'& LCD_CGRAM(LCD_CGRAM_PTR);
									END IF;				
		 WHEN LCD_ADDRESS_L1=> LCD_DELAY<=LCD_DELAY+1;
		                       IF LCD_DELAY=5000 THEN LCD_DELAY<=0;
									                         LCD_STATE<=LCD_DATA_L1;
																	 LCD_DIS_PTR<=0;
									  ELSIF (LCD_DELAY=30)THEN LCD_ENABLE<='0';
								     ELSIF(LCD_DELAY=5)  THEN LCD_ENABLE<='1';
									  ELSE                     LCD_RS_DB<='0'&X"80";
									  END IF;
		WHEN LCD_DATA_L1=>    LCD_DELAY<=LCD_DELAY+1;
		                      IF LCD_DELAY=5000 THEN LCD_DELAY<=0;
									    IF (LCD_DIS_PTR=15) THEN LCD_STATE<=LCD_ADDRESS_L2;
										 ELSE                     LCD_DIS_PTR<=LCD_DIS_PTR+1;
										 END IF;
									ELSIF(LCD_DELAY=30) THEN LCD_ENABLE<='0';
									ELSIF(LCD_DELAY=5)  THEN LCD_ENABLE<='1';
									ELSE                     LCD_RS_DB<='1'& LCD_DIS1(LCD_DIS_PTR);
									END IF;
		WHEN LCD_ADDRESS_L2=> LCD_DELAY<=LCD_DELAY+1;
		                       IF LCD_DELAY=5000 THEN LCD_DELAY<=0;
									                         LCD_STATE<=LCD_DATA_L2;
																	 LCD_DIS_PTR<=0;
									  ELSIF (LCD_DELAY=30)THEN LCD_ENABLE<='0';
								     ELSIF(LCD_DELAY=5)  THEN LCD_ENABLE<='1';
									  ELSE                     LCD_RS_DB<='0'&X"C0";
									  END IF;
		WHEN LCD_DATA_L2=>    LCD_DELAY<=LCD_DELAY+1;
		                      IF LCD_DELAY=5000 THEN LCD_DELAY<=0;
									    IF (LCD_DIS_PTR=15) THEN LCD_STATE<=LCD_STOP;
										 ELSE                     LCD_DIS_PTR<=LCD_DIS_PTR+1;
										 END IF;
									ELSIF(LCD_DELAY=30) THEN LCD_ENABLE<='0';
									ELSIF(LCD_DELAY=5)  THEN LCD_ENABLE<='1';
									ELSE                     LCD_RS_DB<='1'& LCD_DIS2(LCD_DIS_PTR);
									END IF;
	   WHEN LCD_STOP=>    LCD_DELAY<=LCD_DELAY+1;
		                   IF LCD_DELAY=1000000 THEN LCD_DELAY<=0;
								                           LCD_STATE<=LCD_ADDRESS_L1;
								END IF;
		END CASE;
	END IF;
  END PROCESS;
  LCD_DB<=LCD_RS_DB( 7 DOWNTO 0);
  LCD_RS<=LCD_RS_DB(8);
  LCD_E<=LCD_ENABLE;
end Behavioral;

