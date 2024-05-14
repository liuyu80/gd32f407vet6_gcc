/*
  LiangShan Pi has four LED: E3/D7/G3/A5
*/

#include "gd32f4xx.h"
#include "systick.h"
#include "FreeRTOS.h"
#include "task.h"

void ledMain(void *pvParameters)
{
    /* configure systick */

    /* enable the LEDs GPIO clock */
    rcu_periph_clock_enable(RCU_GPIOE);
    /* configure LED GPIO port */
    gpio_mode_set(GPIOE, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_0);

    gpio_output_options_set(GPIOE, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO_PIN_0);

    for (;;)
    {
        gpio_bit_toggle(GPIOE, GPIO_PIN_0);
        vTaskDelay(1000 / portTICK_RATE_MS);
        gpio_bit_toggle(GPIOE, GPIO_PIN_0);
        vTaskDelay(300 / portTICK_PERIOD_MS);
    }
}

int main(void)
{
    // 创建任务taskMain
    xTaskCreate(ledMain, "ledMain", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2, NULL);

    // 启动任务调度
    vTaskStartScheduler();
    while (1)
    {
    }

    return 0;
}