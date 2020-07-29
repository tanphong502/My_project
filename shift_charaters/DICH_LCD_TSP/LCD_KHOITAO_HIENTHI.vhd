library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;


entity LCD_KHOITAO_HIENTHI is
PORT(
		 LCD_CK,LCD_RST: IN STD_LOGIC;
       LCD_HANG_1: IN STD_LOGIC_VECTOR(127 DOWNTO 0);
		 LCD_HANG_2: IN STD_LOGIC_VECTOR(127 DOWNTO 0);
		 LCD_DB: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 LCD_RS,LCD_E: OUT STD_LOGIC
);
end LCD_KHOITAO_HIENTHI;

architecture Behavioral of LCD_KHOITAO_HIENTHI is
TYPE LCD_MACHINE IS(
                      LCD_INITIAL,
							 LCD_ADDRESS_L1,
							 LCD_DATA_L1,
							 LCD_ADDRESS_L2,
							 LCD_DATA_L2,
							 LCD_STOP
);
SIGNAL LCD_STATE: LCD_MACHINE:=LCD_INITIAL;
TYPE LCD_CMD_TABLE IS ARRAY (INTEGER RANGE 0 TO 5) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
CONSTANT LCD_CMD: LCD_CMD_TABLE:=(0=> X"00",
                                  1=> X"3C",--FUNCTION SET
											 2=> X"0C",--DISLAY CONTROL
											 3=> X"01",--CLEAR
											 4=> X"02",--RETURN HOME
											 5=> X"06");--ENTRY MODE SET
SIGNAL PTR: INTEGER RANGE 0 TO 15:=0;
TYPE LCD_DIS_L1 IS ARRAY (INTEGER RANGE 0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL LCD_DIS1:LCD_DIS_L1;
TYPE LCD_DIS_L2 IS ARRAY (INTEGER RANGE 0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL LCD_DIS2:LCD_DIS_L2;

SIGNAL SLX : INTEGER RANGE 0 TO 1000000:=0;


begin
  PROCESS(LCD_HANG_1,LCD_HANG_2)
  BEGIN
    FOR I IN 0 TO 15
	 LOOP
	     LCD_DIS1(I) <=LCD_HANG_1((I*8+7) DOWNTO I*8);
        LCD_DIS2(I) <=LCD_HANG_2((I*8+7) DOWNTO I*8);
	 END LOOP;
  END PROCESS;
  
  PROCESS(LCD_CK,SLX,LCD_RST)
  BEGIN
  IF LCD_RST='1' THEN LCD_STATE<=LCD_INITIAL;
                      SLX <= 0;
							 PTR<=0;
							
	ELSIF FALLING_EDGE(LCD_CK) THEN
	   CASE LCD_STATE IS
		  WHEN LCD_INITIAL=>  														LCD_RS <= '0';
																							SLX<=SLX+1;
		                      IF SLX = 164000 THEN SLX<=0;
									    IF PTR = 5 THEN 
										                                       LCD_STATE<=LCD_ADDRESS_L1;
											ELSE	
                                    											PTR<=PTR+1;
											END IF;
									ELSIF(SLX=30) THEN LCD_E<='0';
									ELSIF(SLX=5)  THEN LCD_E<='1';
									ELSE                     LCD_DB<=LCD_CMD(PTR);
									END IF;
		 WHEN LCD_ADDRESS_L1=> 						LCD_RS <= '0';
															SLX<=SLX+1;
		                       IF SLX=5000 THEN SLX<=0;
									                         LCD_STATE<=LCD_DATA_L1;
																	 PTR<=0;
									  ELSIF SLX=30 THEN LCD_E<='0';
								     ELSIF SLX=5  THEN LCD_E<='1';
									  ELSE                     LCD_DB<= X"80";
									  END IF;
		WHEN LCD_DATA_L1=>    					LCD_RS <= '1';
														SLX<=SLX+1;
		                      IF SLX=5000 THEN SLX<=0;
									    IF PTR=15 THEN LCD_STATE<=LCD_ADDRESS_L2;
										 ELSE                     PTR<=PTR+1;
										 END IF;
									ELSIF  SLX=30 THEN LCD_E<='0';
									ELSIF SLX=5  THEN LCD_E<='1';
									ELSE                     LCD_DB<= LCD_DIS1(PTR);
									END IF;
		WHEN LCD_ADDRESS_L2=> 					LCD_RS <= '0';
		
														SLX<=SLX+1;
		                       IF SLX=5000 THEN SLX<=0;
									                         LCD_STATE<=LCD_DATA_L2;
																	 PTR<=0;
									  ELSIF SLX=30 THEN LCD_E<='0';
								     ELSIF SLX=5  THEN LCD_E<='1';
									  ELSE                     LCD_DB<= X"C0";
									  END IF;
		WHEN LCD_DATA_L2=>    			LCD_RS <='1';
												SLX<=SLX+1;
		                      IF SLX=5000 THEN SLX<=0;
									    IF PTR=15 THEN LCD_STATE<=LCD_STOP;
										 ELSE                     PTR<=PTR+1;
										 END IF;
									ELSIF SLX=30 THEN LCD_E<='0';
									ELSIF SLX=5  THEN LCD_E<='1';
									ELSE                     LCD_DB<= LCD_DIS2(PTR);
									END IF;
	    
	   WHEN LCD_STOP=>    SLX<=SLX+1;
				
				IF SLX=1000000 THEN SLX<=0;
								        LCD_STATE<=LCD_ADDRESS_L1;
								
				END IF;
		END CASE;
	END IF;
  END PROCESS;

end Behavioral;

