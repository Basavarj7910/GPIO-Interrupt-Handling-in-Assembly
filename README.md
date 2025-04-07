# STM32F407VG EXTI0 Interrupt – LED Toggle (ARM Assembly)

This project demonstrates configuring an external interrupt on pin `PA0` (EXTI0) to toggle an LED on `PD12` using ARM assembly language on the STM32F407VG microcontroller (STM32F4Discovery board).

---

##  Project Structure

| File                   | Description                                                         |
|------------------------|---------------------------------------------------------------------|
| `main.s`               | Main ARM assembly file containing all initialization and handlers   |
| `linker.ld`            | Linker script defining memory layout for STM32F407VG                |
| `Makefile`             | Automates build (assemble, link, and convert to binary)             |
| `stm32f4discovery.cfg` | OpenOCD config for flashing/debugging the STM32F4Discovery board    |

---

##  Features

- Written entirely in **ARM Cortex-M4 assembly**
- External interrupt (EXTI0) on `PA0` to toggle an LED on `PD12`
- Direct register-level control, **no C or HAL**
- Runs on **STM32F4Discovery** board

