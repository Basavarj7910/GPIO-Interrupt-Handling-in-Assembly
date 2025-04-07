.extern _etext
.extern _sdata
.extern _edata
.extern _sbss
.extern _ebss

.equ RCC_AHB1ENR,0x40023830
.equ GPIOD_MODER,0x40020C00
.equ GPIOD_OTYPER,0x40020C04
.equ GPIOD_OSPEEDR,0x40020C08
.equ GPIOD_PUPDR,0x40020C0C
.equ GPIOD_ODR,0x40020C14

.equ SYSCFG_EXTI0,0x40013808
.equ EXTI_IMR,0x40013C00
.equ EXTI_RTSR,0x40013C08
.equ EXTI_PR,0x40013C14
.equ NVIC_ISRE0R,0xE000E100
.equ APB2_RCCEN,0x40023844
.equ SYS_EXCE_CNTRL,0xe000ed24

.section .bss
  array: .space 10

.section .data
  .align 2
  current_task: .word 0
  task_sp: .word 0x2001FC00, 0x2001F800,0x2001F400, 0x2001F000


.section .vector
    vector_table:
          .word 0x20020000
          .word reset_handler
          .org 0x0C
          .word HardFault_Handler
          .word MemManage_Handler
          .word BusFault_Handler
          .word UsageFault_Handler
          .org 0x58
          .word EXTI0_IRQHandler
          .zero 400
.section .text
  .align 2
  .type Default_Handler,%function
  Default_Handler:
                   b .

.section .text
   .align 2
   .type reset_handler, %function
   reset_handler:
          ldr r1, =_etext
          ldr r2, =_sdata
          ldr r3, =_edata
       up:mov r0,#0
          ldrb r0,[r1] 
          strb r0,[r2]
          add r1,r1,#1
          add r2,r2,#1 
          cmp r2, r3
          bne up
          ldr r1,=_sbss
          ldr r2,=_ebss
          mov r3,#0
     next:strb r3,[r1]
          add r1,r1,#1
          cmp r1,r2
          bne next
          b main

.section .text
    .align 2
    .type main,%function
    main:
          bl excep_init
          bl led_init
          bl init_exti
          b .
                    
.section .text
   .align 2
   .type init_exti,%function
   init_exti:
              ldr r0,=APB2_RCCEN
              ldr r1,[r0]
              ldr r2,=0x00004000
              orr r1,r1,r2
              str r1,[r0]
              ldr r0,=EXTI_IMR
              ldr r1,=0x00000001
              ldr r2,[r0]
              orr r2,r2,r1
              str r2,[r0]
              ldr r0,=EXTI_RTSR
              ldr r2,[r0]
              ldr r1,=0x00000001
              orr r2,r2,r1
              str r2,[r0]
              ldr r0,=NVIC_ISRE0R
              ldr r1,=0x00000040
              ldr r2,[r0]
              orr r2,r2,r1
              str r2,[r0]
              bx lr
 
.section .text
     .align 2
     .type led_init,%function
     led_init:mov r0,#8
             ldr r1,=RCC_AHB1ENR
             ldr r2,[r1]
             orr r2,r2,r0
             str r2,[r1]
             ldr r1,=GPIOD_MODER 
             ldr r2,[r1]
             ldr r0, =0xfcffffff
             and r2,r2,r0
             ldr r0, =0x01000000
             orr r2,r2,r0
             str r2,[r1]
             ldr r1, =GPIOD_OTYPER
             ldr r2, [r1]
             ldr r0, =0xffffefff
             and r2,r2,r0
             str r2, [r1]
             ldr r1,=GPIOD_OSPEEDR
             ldr r2,[r1]
             ldr r0, =0xfcffffff
             and r2,r2,r0
             str r2,[r1]
             ldr r1,=GPIOD_PUPDR
             ldr r2,[r1]
             ldr r0, =0xfcffffff
             and r2,r2,r0
	     str r2,[r1]
	     ldr r1,=GPIOD_ODR
	     ldr r0, =0x00001000
	     ldr r2,[r1]
	     orr r0,r0,r2
	     str r0,[r1]
	     bx lr

.section .text 
         .align 2
         .type EXTI0_IRQHandler,%function
    EXTI0_IRQHandler:
                     ldr r1,=GPIOD_ODR
                       mov r0,#0x01
                       lsl r0,r0,#12
                       ldr r2,[r1]
                       eor r2,r2,r0
                       str r2,[r1]
                       ldr r6,=0x000fff00
                      rep:sub r6,r6,#1
                      cmp r6,#0
                      bne rep
                       ldr r1,=EXTI_PR
                       ldr r0,=0x00000001
                       ldr r2,[r1]
                       orr r2,r2,r0
                       str r2,[r1]
                       bx lr

.section .text
         .align 2
         .type excep_init,%function
         excep_init:
                   ldr r0,=SYS_EXCE_CNTRL
                   ldr r1,=0x00070000
                   ldr r2,[r0]
                   orr r2,r2,r1
                   str r2,[r0]
                   bx lr

.section .text
         .align 2
         .type HardFault_Handler,%function
         HardFault_Handler:
                           bl .
        
.section .text
         .align 2
         .type MemManage_Handler,%function
          MemManage_Handler:
                            bl .


.section .text
         .align 2
         .type BusFault_Handler,%function
          BusFault_Handler:
                           bl .



.section .text
         .align 2
         .type UsageFault_Handler,%function
          UsageFault_Handler:
                             bl .

