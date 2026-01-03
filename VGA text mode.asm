putchar:
    pusha
    mov di, [cursor_pos]
    mov word [0xB8000 + di*2], ax  ; ax = символ + атрибут
    inc word [cursor_pos]
    popa
    ret

set_cursor:
    pusha
    mov dx, 0x3D4
    mov al, 0x0F
    out dx, al
    mov al, [cursor_pos] & 0xFF
    out dx+1, al
    mov al, 0x0E
    out dx, al
    mov al, ([cursor_pos] >> 8) & 0xFF
    out dx+1, al
    popa
    ret
