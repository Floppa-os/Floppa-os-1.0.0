; Минимальное ядро ОС с консолью
; Компиляция: nasm -f bin kernel.asm -o kernel.bin
; Загрузка: поместить kernel.bin в первый сектор диска (или использовать загрузчик)
%include "disk.asm"

org 0x7C00  ; Стандартное смещение загрузчика BIOS

start:
    ; Инициализация сегментов
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00  ; Stack внизу загрузчика

    ; Очистка экрана
    call clear_screen

    ; Вывод приглашения
    mov si, prompt
    call print_string

    ; Основной цикл консоли
console_loop:
    ; Ожидание ввода символа
    call get_char
    mov byte [input_buf + bx], al  ; Сохраняем в буфер
    inc bx                          ; Увеличиваем индекс

    ; Отображаем символ
    mov ah, 0x0E
    mov bh, 0
    mov bl, 0x07
    int 0x10

    ; Проверка на Enter (0x0D)
    cmp al, 0x0D
    je process_command
    jmp console_loop

; Обработка команды (после Enter)
process_command:
    ; Добавляем завершающий ноль
    mov byte [input_buf + bx], 0

    ; Переводим курсор на новую строку
    call new_line

    ; Проверяем команду
    mov si, input_buf
    mov di, cmd_help
    call compare_string
    jc .is_help

    mov si, input_buf
    mov di, cmd_echo
    call compare_string
    jc .is_echo

    ; Неизвестная команда
    mov si, unknown_cmd
    call print_string
    jmp reset_buffer

.is_help:
    mov si, help_msg
    call print_string
    jmp reset_buffer

.is_echo:
    ; Выводим всё после "echo "
    mov si, input_buf
    add si, 5  ; Пропускаем "echo "
    call print_string
    call new_line
    jmp reset_buffer

reset_buffer:
    xor bx, bx  ; Обнуляем индекс буфера
    mov si, prompt
    call print_string
    jmp console_loop

; Функции

; Очистка экрана
clear_screen:
    mov ax, 0x0600  ; Scroll entire screen
    mov bh, 0x07    ; Атрибут: белый на чёрном
    mov cx, 0       ; Координаты верхнего левого угла (0,0)
    mov dx, 0x184F  ; Координаты нижнего правого угла (24,79)
    int 0x10
    ret

; Вывод строки (SI = адрес строки)
print_string:
    lodsb           ; Загружаем байт из SI в AL
    or al, al       ; Проверяем на ноль
    jz .done
    mov ah, 0x0E    ; Функция BIOS: вывести символ
    mov bh, 0
    mov bl, 0x07
    int 0x10
    jmp print_string
.done:
    ret

; Получение символа с клавиатуры
get_char:
    mov ah, 0x00
    int 0x16  ; BIOS INT 16h: ожидание символа
    ret

; Новая строка
new_line:
    mov al, 0x0D
    mov ah, 0x0E
    int 0x10
    mov al, 0x0A
    mov ah, 0x0E
    int 0x10
    ret

; Сравнение строк (SI и DI, устанавливает CF при совпадении)
compare_string:
    lodsb
    cmp al, byte [di]
    jne .no_match
    or al, al
    jz .match
    inc di
    jmp compare_string
.match:
    clc  ; CF=0: совпадение
    ret
.no_match:
    stc  ; CF=1: нет совпадения
    ret

; Данные
prompt db "> ", 0
cmd_help db "help", 0
cmd_echo db "echo ", 0
unknown_cmd db "Unknown command. Type 'help' for info.", 13, 10, 0
help_msg db "Available commands:", 13, 10
       db "  help - Show this message", 13, 10
       db "  echo <text> - Repeat the text", 13, 10, 0

input_buf times 256 db 0  ; Буфер ввода

; Заполнитель до 512 байт (размер сектора)
times 510-($-$$) db 0
dw 0xAA55  ; Сигнатура загрузчика

; extern "C" функции для C++
print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    mov bh, 0
    mov bl, 0x07
    int 0x10
    jmp print_string
.done:
    ret

get_char:
    mov ah, 0x00
    int 0x16
    ret

new_line:
    mov al, 0x0D
    mov ah, 0x0E
    int 0x10
    mov al, 0x0A
    mov ah, 0x0E
    int 0x10
    ret

console_loop:
    call get_char
    mov byte [input_buf + bx], al
    inc bx

    mov ah, 0x0E
    mov bh, 0
    mov bl, 0x07
    int 0x10

    cmp al, 0x0D  ; Enter
    je process_command
    jmp console_loop

process_command:
    mov byte [input_buf + bx], 0
    call new_line

    ; Проверяем команду calc
    mov si, input_buf
    mov di, cmd_calc
    call compare_string
    jc .is_calc

    ; Остальные команды (help, echo и т. д.)
    ...

.is_calc:
    ; Вызываем калькулятор на C++
    mov si, input_buf + 5  ; Пропускаем "calc "
    call calculator  ; Вызов функции из calculator.cpp
    jmp reset_buffer

...

; Данные
cmd_calc db "calc ", 0
call load_kernel
mov bx, KERNEL_OFFSET
mov dh, 2
mov dl, [BOOT_DRIVE]
call disk_load
