
#include "main.h"
#include "tv_lcd.h"
#include "stm32f1xx_hal.h"
#include "tv_dht11.h"

uint8_t tem_th=98;
uint8_t hum_th=98;

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
/* Private user code ---------------------------------------------------------*/

int main(void)
{

DHT11_DATA_TypeDef DHT11_DATA ;

  

  /* MCU Configuration--------------------------------------------------------*/
  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();
  /* Configure the system clock */
  SystemClock_Config();
  /* Initialize all configured peripherals */
  MX_GPIO_Init();
	
	lcd_init();
	//HANG 0
	lcd_gotoxy(0,0);
	lcd_putc("NHIET DO:");
	lcd_gotoxy(0,18);
	lcd_putchar(0xDF);
	lcd_putc("C");
	//HANG 1
	lcd_gotoxy(1,0);
	lcd_putc("DO AM:             %");
	//HANG 2
	lcd_gotoxy(2,0);
	lcd_putc("N/do nguong:");
	lcd_gotoxy(2,18);
	lcd_putchar(0xDF);
	lcd_putc("C");
	//HANG 3
	lcd_gotoxy(3,0);
	lcd_putc("Do am nguong:      %");
	//hien thi gia tri nguong
	lcd_gotoxy(2,15);
	lcd_putchar(tem_th/10+48);
	lcd_putchar(tem_th%10+48);
	lcd_gotoxy(3,15);
	lcd_putchar(hum_th/10+48);
	lcd_putchar(hum_th%10+48);

	HAL_GPIO_WritePin(BUZZER_GPIO_Port,BUZZER_Pin,0);
	HAL_GPIO_WritePin(LED1_GPIO_Port,LED1_Pin,0);
	HAL_GPIO_WritePin(LED2_GPIO_Port,LED2_Pin,0);
  while (1)
  {		
		Request();
		Response();
    if(Read_TempAndHum ( & DHT11_DATA)==SUCCESS)
		{
			// HIEN THI GIA TRI
			lcd_gotoxy(0,15);
			lcd_putchar(DHT11_DATA.temp_int/10+48);
			lcd_putchar(DHT11_DATA.temp_int%10+48);
			lcd_gotoxy(1,15);
			lcd_putchar(DHT11_DATA.humi_int/10+48);
			lcd_putchar(DHT11_DATA.humi_int%10+48);
		}	
	if (DHT11_DATA.temp_int >= tem_th)
			{
				HAL_GPIO_WritePin(BUZZER_GPIO_Port,BUZZER_Pin,1);
				HAL_GPIO_WritePin(LED1_GPIO_Port,LED1_Pin,1);
			}
		
	if (DHT11_DATA.humi_int >= hum_th)
			{
				HAL_GPIO_WritePin(BUZZER_GPIO_Port,BUZZER_Pin,1); 
				HAL_GPIO_WritePin(LED2_GPIO_Port,LED2_Pin,1);
			}
		
  }
}


void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Initializes the CPU, AHB and APB busses clocks 
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.HSEPredivValue = RCC_HSE_PREDIV_DIV1;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLMUL = RCC_PLL_MUL9;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }
  /** Initializes the CPU, AHB and APB busses clocks 
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOD_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, D4_Pin|D5_Pin|D6_Pin|D7_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOB, RS_Pin|RW_Pin|E_Pin|LED2_Pin 
                          |LED1_Pin|BUZZER_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pins : D4_Pin D5_Pin D6_Pin D7_Pin */
  GPIO_InitStruct.Pin = D4_Pin|D5_Pin|D6_Pin|D7_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pins : RS_Pin RW_Pin E_Pin LED2_Pin 
                           LED1_Pin BUZZER_Pin */
  GPIO_InitStruct.Pin = RS_Pin|RW_Pin|E_Pin|LED2_Pin 
                          |LED1_Pin|BUZZER_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */

  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{ 
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     tex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
