##############################################################################################
# Makefile for STM32F103 (Blue Pill) CMSIS directory structure extracated from STM32CubeIDE
# project.
#
# Mike Shegedin, 2023
#     Version 1.0     7/24/2023   Updated Makefile "TARGET"
##############################################################################################

TARGET=build
SOURCE=main 
MCPU=cortex-m3
CFG=system_stm32f1xx
STARTUP=startup_stm32f103x6
LOADER=STM32F103X6_FLASH.ld

CC=arm-none-eabi-gcc

CFLAGS=-mcpu=$(MCPU) -g3 --specs=nano.specs -Os -mthumb -mfloat-abi=soft -Wall

INCLUDE1=STM32CubeF1/Drivers/CMSIS/Device/ST/STM32F1xx/Include
INCLUDE2=STM32CubeF1/Drivers/CMSIS/Include
ST_INCL=STM32CubeF1/Core/Startup

$(TARGET).elf: main.o startup_stm32f103x6.o linker/STM32F103X6_FLASH.ld system_stm32f1xx.o handlers.o  Makefile
	$(CC) -o $@ main.o startup_stm32f103x6.o system_stm32f1xx.o -mcpu=$(MCPU) --specs=nosys.specs -T"linker/STM32F103X6_FLASH.ld" -Wl,-Map=$(TARGET).map -Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	arm-none-eabi-size $(TARGET).elf

startup_stm32f103x6.o: $(ST_INCL)/startup_stm32f103x6.s Makefile
	$(CC) $(CFLAGS) -DDEBUG -c -x assembler-with-cpp -o $@ $<

main.o: main.c Makefile
	$(CC) $< $(CFLAGS) -I$(INCLUDE1) -I$(INCLUDE2) -std=gnu11 -DDEBUG -c -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -o $@

handlers.o: handlers.c Makefile
	$(CC) $< $(CFLAGS) -I$(INCLUDE1) -I$(INCLUDE2) -std=gnu11 -DDEBUG -c -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -o $@

system_stm32f1xx.o: system_stm32f1xx.c Makefile
	$(CC) $< $(CFLAGS) -I$(INCLUDE1) -I$(INCLUDE2) -std=gnu11 -DDEBUG -c -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -o $@

clean:
	rm *.o *.elf *.map *.su
