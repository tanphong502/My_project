
#include "tv_dht11.h"

static void GPIO_DHT11_OUT(void) ;
static void GPIO_DHT11_IN(void) ;
static uint8_t  READ_DATA_8BIT(void) ;


/***************************** DHT11 khoi tao***********************/
void Request(void)
{
	//GPIO che dau dau ra
	GPIO_DHT11_OUT() ;	
	//Khoi tao pin DHT11
	DHT11_DOUT_0 ;
	//delay 18ms
	HAL_Delay(20);
	//GPIO_DHT11_IN() ;
}
void Response(void)
{
	delay_us(40);
	/*	Cho pin =0	*/
	DHT11_DOUT_0 ;
	/*	Delay 80us*/
	delay_us(80) ;
	/*	delay pin len 1 trong 80us	*/
	DHT11_DOUT_1 ;
	delay_us(80) ;
	/*	Chuyen sang che do input	*/
	GPIO_DHT11_IN() ;
}

/********************************Config GPIO output***************************/
static void GPIO_DHT11_OUT(void)
{
	GPIO_InitTypeDef GPIO_InitStruct ;
	
// cho phep port
	GPIO_DHT11_CLK;
	
	GPIO_InitStruct.Pin = GPIO_DHT11_PIN ; 
	GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP ; //res pull
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH ;
	
	HAL_GPIO_Init( GPIO_DHT11_PORT , &GPIO_InitStruct ) ;	
}

/********************************config GPIO input***************************/
static void GPIO_DHT11_IN(void)
{
	GPIO_InitTypeDef GPIO_InitStruct ;

	GPIO_InitStruct.Pin	= GPIO_DHT11_PIN ; 
	GPIO_InitStruct.Mode = GPIO_MODE_INPUT ;//mode input
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH ;
	HAL_GPIO_Init( GPIO_DHT11_PORT	, &GPIO_InitStruct ) ;
}

/**********************************Doc 8 bit dau vao DHT11**********************************/
static uint8_t  READ_DATA_8BIT(void)
{
	uint8_t  i , data=0;
	//Doc 8bit
	for(i=0;i<8;i++)
	{	
		// 50us moi lan gui du lieu
		while( DHT11_DATA_IN()==0) ;	
		//thoi gian kiem tra =1 or 0
		delay_us(50);
		//Neu bang 1 thi da truyen di
		if( DHT11_DATA_IN() == 1 )
		{
			//cho cho truyen du lieu ket thuc
			while( DHT11_DATA_IN() == 1 );
			//chuyen du lieu tiep theo vao data
			data |= (uint8_t)(0x01 << (7-i)) ;
		}
		else 
			//Du lieu 0 duoc truyen toi bit cao
		data &= (uint8_t)~(0x01 << (7-i));
	}
	//Truyen 1 byte du lieu di
	return data ;
}

/****************************Doc DHT11*************************************/
uint8_t Read_TempAndHum (DHT11_DATA_TypeDef *DHT11_DATA)
{
	//Kiem tra nhan duoc tin hieu tu DHT11 ko , neu ko nhan duoc bao error
	if(DHT11_DATA_IN() == 0)
	{
		//Cho ket thuc tin lieu =0 
		while(DHT11_DATA_IN() == 0) ;
		//Cho cho ket thuc muc cao
		while(DHT11_DATA_IN() == 1) ;
		//bat dau chuyen du lieu
		DHT11_DATA->humi_int = READ_DATA_8BIT() ; 
		DHT11_DATA->humi_deci = READ_DATA_8BIT() ; 
		DHT11_DATA->temp_int = READ_DATA_8BIT() ; 
		DHT11_DATA->temp_deci = READ_DATA_8BIT() ;
    DHT11_DATA->check_sum = READ_DATA_8BIT() ;
		//Ket thuc qua trinh nhan du lieu thay doi dau sensor la dau ra
		GPIO_DHT11_OUT();
		//Dong pin lai
		DHT11_DOUT_1 ;
		//Kiem tra sum truyen dung tra lai SUCCESS, neu sai tra lai ERROR ;
		if(DHT11_DATA->check_sum == DHT11_DATA->humi_int + DHT11_DATA->humi_deci + DHT11_DATA->temp_int + 
			DHT11_DATA->temp_deci)
			return SUCCESS ;
		else
			return ERROR ;
	}		
	else
		return ERROR ;
	
}

void delay_us(uint8_t time)
{

    while (time--)
    {


       
        __nop();
        __nop();

        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();

        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();

        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();

        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();

        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();

        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();

        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
        __nop();
    }

}

















