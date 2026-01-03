; Найти USB-контроллер через PCI
find_ehci:
    mov eax, 0x80000000
    cpuid
    ; ... поиск устройства по классу 0x0C03 (USB)
    ; Получить BAR (Base Address Register) контроллера

; Настроить регистры EHCI
init_ehci:
    mov edx, [ehci_bar]
    mov dword [edx + 0x04], 0x00000001 ; Set USBSTS to 1 (reset)
    ; ... ожидание сброса
    mov dword [edx + 0x08], 0x00000001 ; Включить асинхронную очередь
