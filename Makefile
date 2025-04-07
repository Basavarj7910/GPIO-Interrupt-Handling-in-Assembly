
ll:
	arm-none-eabi-as -mthumb -mcpu=cortex-m4 main.s -o main.o
	arm-none-eabi-ld -Map=main.map -Tlinker.ld  main.o -o main.elf
	arm-none-eabi-readelf -a main.elf >main.debug	
	arm-none-eabi-objcopy -O binary main.elf main.bin	
	arm-none-eabi-nm main.elf >main.nm

clean:
	rm -rf *.elf *.o *.debug *.bin *.nm *.map
