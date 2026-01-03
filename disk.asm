с[bits 16]
read_sector:
    pusha                  ; сохраняем регистры
    mov ah, 0x02          ; функция чтения
    mov al, 1             ; количество секторов
    mov ch, 0             ; цилиндр
    mov cl, 2             ; сектор (1-based)
    mov dh, 0             ; головка
    mov dl, [BOOT_DRIVE]  ; диск (из MBR)
    mov bx, buffer        ; буфер для данных
    int 0x13              ; вызов BIOS
    jc error_disk         ; если ошибка — переход
    popa                  ; восстанавливаем регистры
    ret
error_disk:
    ; ошибка
    ret
