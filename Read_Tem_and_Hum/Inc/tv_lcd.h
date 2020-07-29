#ifndef	_TV_LCD_
#define _TV_LCD_

#include "stm32f1xx_hal.h"

#define LCD_GPIO_CONTROL	GPIOB
#define LCD_RS				GPIO_PIN_0
#define LCD_RW				GPIO_PIN_1
#define LCD_EN				GPIO_PIN_10

#define LCD_GPIO_DATA		GPIOA
#define LCD_D4				GPIO_PIN_4
#define LCD_D5				GPIO_PIN_5
#define LCD_D6				GPIO_PIN_6
#define LCD_D7				GPIO_PIN_7

void lcd_enable(void);
void lcd_send4bits(unsigned char data);
void lcd_init(void);
void lcd_command(unsigned char command);
void lcd_putchar(unsigned char data);
void lcd_putc(char *s);
void lcd_gotoxy(unsigned char x, unsigned char y);
#endif
