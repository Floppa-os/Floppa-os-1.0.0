
bits 32


section .text
    ; Multiboot заголовок (обязателен для GRUB)
    align 4
    dd 0x1BADB002      ; magic number
    dd 0x00            ; flags
    dd -(0x1BADB002 + 0x00)  ; checksum (magic + flags + checksum = 0)


    global start        ; Точка входа в ядро
    extern kmain        ; Функция на C, которую мы вызовем

start:
    cli                 
    mov esp, stack_space  
    call kmain          ; Вызвать функцию kmain
    hlt                 ; Остановить процессор

section .bss
    resb 8192         ; 8 KB для стека
stack_space:
