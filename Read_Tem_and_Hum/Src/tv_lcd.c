#include "tv_lcd.h"
const char LCD_SO_X[13][6] ={
                  0,1,2,5,3,4,               // SO 0
                  1,2,32,3,7,3,              // SO 1
                  6,6,2,5,3,3,               // SO 2
                  6,6,2,3,3,4,               // SO 3
                  7,3,7,32,32,7,             // SO 4
                  7,6,6,3,3,4,               // SO 5
                  0,6,6,5,3,4,               // SO 6
                  1,1,7,32,32,7,             // SO 7
                  0,6,2,5,3,4,               // SO 8
                  0,6,2,3,3,4,                // SO 9
                  32,32,32,32,32,32,
                  0,1,32,5,3,32, 
                  32,32,32,0,1,2
                  };   
const char LCD_MA_8DOAN[] = {
   0x07,0x0F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,  //DOAN F - 0
   0x1F,0x1F,0x1F,0X00,0X00,0X00,0X00,0X00,  //DOAN A - 1
   0x1C,0x1E,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,  //DOAN B - 2
   0X00,0X00,0X00,0X00,0X00,0x1F,0x1F,0x1F,  //DOAN D - 3
   0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1E,0x1C,  //DOAN C - 4
   0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x0F,0x07,  //DOAN E - 5
   0x1F,0x1F,0x1F,0X00,0X00,0X00,0x1F,0x1F,  //DOAN G+D-6 
   0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F}; //DOAN I  -7

void lcd_enable()
{
   LCD_GPIO_CONTROL->BSRR = LCD_EN;
   LCD_GPIO_CONTROL->BRR = LCD_EN;
   HAL_Delay(1);
}

void lcd_send4bits(unsigned char data)
{
   HAL_GPIO_WritePin(LCD_GPIO_DATA, LCD_D4, ((data & 0x01) == 0) ? GPIO_PIN_RESET : GPIO_PIN_SET);
   HAL_GPIO_WritePin(LCD_GPIO_DATA, LCD_D5, (((data >> 1) & 0x01) == 0) ? GPIO_PIN_RESET : GPIO_PIN_SET);
   HAL_GPIO_WritePin(LCD_GPIO_DATA, LCD_D6, (((data >> 2) & 0x01) == 0) ? GPIO_PIN_RESET : GPIO_PIN_SET);
   HAL_GPIO_WritePin(LCD_GPIO_DATA, LCD_D7, (((data >> 3) & 0x01) == 0) ? GPIO_PIN_RESET : GPIO_PIN_SET);
}

void lcd_init()
{   
	uint8_t i=0;
   LCD_GPIO_CONTROL->BRR = LCD_RS;
   LCD_GPIO_CONTROL->BRR = LCD_RW;
   
   HAL_Delay(20);
   lcd_send4bits(0x03);
   lcd_enable();
   HAL_Delay(10);
   lcd_send4bits(0x03);
   lcd_enable();
   HAL_Delay(10);
   lcd_send4bits(0x03);
   lcd_enable();
   HAL_Delay(10);
   lcd_send4bits(0x02);
   lcd_enable();
   HAL_Delay(10);
   
   lcd_command(0x28); //4-bits 2 lines
   lcd_command(0x0C); //Display on Cursor off
   lcd_command(0x06); //Entry Mode
	 
		lcd_command(0x40);		
		for(i=0;i<64;i++) lcd_putchar(LCD_MA_8DOAN[i]);
	
   lcd_command(0x01); //Clear Display
   HAL_Delay(10);
}

void lcd_command(unsigned char command)
{
   lcd_send4bits(command >> 4);
   lcd_enable();
   lcd_send4bits(command);
   lcd_enable();
}

void lcd_putchar(unsigned char data)
{
   LCD_GPIO_CONTROL->BSRR = LCD_RS;
   lcd_command(data);
   LCD_GPIO_CONTROL->BRR = LCD_RS;
}

void lcd_putc(char *s)
{
   while(*s)
   {
      LCD_GPIO_CONTROL->BSRR = LCD_RS;
      lcd_command(*s);
      LCD_GPIO_CONTROL->BRR = LCD_RS;
      s++;
   }
}

void lcd_gotoxy(unsigned char x, unsigned char y)
{
		unsigned char address;
		switch(x)
			{
				 case 0: address = 0x80; break; //Starting address of 1st line
				 case 1: address = 0xC0; break; //Starting address of 2nd line
				 case 2: address = 0x94; break; //Starting address of 3rd line
				 case 3: address = 0xD4; break; //Starting address of 4th line
				 default: ; 
			}
   
			address +=y;
			lcd_command(address);
			HAL_Delay(1);
}
void sl(unsigned char so, unsigned char x, unsigned char y)
{
      uint8_t n;
      lcd_gotoxy(x,y);
      
      for(n=0;n<6;n++)
      {
            if(n==3) lcd_gotoxy(x+1,y);
            lcd_putchar(LCD_SO_X[so][n]);  
      }
}