######################################
# target
######################################
TARGET = GD32F407VET6


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization for size
OPT = -Os


#######################################
# paths
#######################################
# Build path
BUILD_DIR = Build

######################################
# source
######################################
# C sources
C_SOURCES =  \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_adc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_can.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_crc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_ctc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_dac.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_dbg.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_dci.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_dma.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_enet.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_exmc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_exti.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_fmc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_fwdgt.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_gpio.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_i2c.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_ipa.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_iref.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_misc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_pmu.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_rcu.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_rtc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_sdio.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_spi.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_syscfg.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_timer.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_tli.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_trng.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_usart.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_wwdgt.c \
Firmware/CMSIS/GD/GD32F4xx/Source/system_gd32f4xx.c \
Utilities/FreeRTOS/portable/GCC/ARM_CM4F/port.c \
Utilities/FreeRTOS/portable/MemMang/heap_4.c \
Utilities/FreeRTOS/croutine.c \
Utilities/FreeRTOS/event_groups.c \
Utilities/FreeRTOS/list.c \
Utilities/FreeRTOS/queue.c \
Utilities/reeRTOS/stream_buffer.c \
Utilities/FreeRTOS/tasks.c \
Utilities/FreeRTOS/timers.c \
APP/gd32f4xx_it.c \
APP/main.c \
APP/systick.c

# ASM sources
ASM_SOURCES = Firmware/CMSIS/GD/GD32F4xx/Source/GCC/startup_gd32f407_427.S


#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m4

# fpu
FPU = -mfpu=fpv4-sp-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \
-DUSE_STDPERIPH_DRIVER \
-DGD32F407


# AS includes
AS_INCLUDES = 

# C includes
C_INCLUDES =  \
-IFirmware/GD32F4xx_standard_peripheral/Include \
-IFirmware/CMSIS/Include \
-IFirmware/CMSIS/GD/GD32F4xx/Include/ \
-IFirmware/CMSIS \
-IUtilities/FreeRTOS/portable/GCC/ARM_CM4F \
-IUtilities/FreeRTOS/include \
-IAPP 

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = Firmware/Ld/Link.ld

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -u_printf_float -specs=nosys.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.S=.o)))
vpath %.S $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.S Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) -A $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@

#######################################
# program
#######################################

program:
	pyocd erase -c -t gd32f407ve --config pyocd.yaml
	pyocd load build/$(TARGET).hex -t gd32f407ve --config pyocd.yaml

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)

#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***
