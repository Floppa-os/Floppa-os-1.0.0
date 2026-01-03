keyboard_handler:
    pusha
    in al, 0x60                  ; Читаем скан‑код
    ; Преобразование в ASCII (упрощённо)
    mov ah, 0x07                 ; атрибут символа
    mov word [vid_mem + cx*2], ax ; Выводим на экран
    add cx, 1                   ; сдвигаем позицию
    ; Отправляем EOI в PIC
    mov al, 0x20
    out 0x20, al
    popa
    iret

set_idt_entry:
    mov [idt_base + 0x21*8], word keyboard_handler & 0xFFFF
    mov [idt_base + 0x21*8 + 2], word 0x08  ; Селектор кода ядра
    mov [idt_base + 0x21*8 + 4], byte 0x8E ; Тип: прерывание
    mov [idt_base + 0x21*8 + 5], byte (keyboard_handler >> 16) & 0xFF
