INCLUDE Irvine32.inc

; Программа выводит один символ в 100 случайных мест окна.
; Задержка между выводом символов изменяется случайным образом
; в диапазоне от 10 до 300 мс.

.data
	bufferInfo CONSOLE_SCREEN_BUFFER_INFO <>    ; Необходимо для хранения промежуточных данных.
	windowXSize WORD ?                          ; Ширина окна консоли.
	windowYSize WORD ?                          ; Высота окна консоли.
	symbol BYTE 'F'                             ; Символ, который отображается на экране.
	
.code
main PROC

	; Получаем размеры окна консоли.
	call getWindowSize
	
	; Записываем соответсвующие размеры.
	mov windowXSize, ax
	mov windowYSize, bx
	
	; Подготовка рандома.
	call Randomize
	
	; Очистка экрана.
	call ClrScr
	
	; Символ будет напечатан 100 раз.
	mov ecx, 100
	
L1:

	; Устанавливаем "случайные" координаты для вывода символа.
	call SetRandCoord
	
	; Выводим символ.
	mov al, symbol
	call WriteChar
	
	; Задержка до следующей итерации.
	call RandDelay
	loop L1
	
	exit
main ENDP

; Процедура получения размеров окна консоли.
; Результат: в ax - ширина, в bx - высота окна.
GetWindowSize PROC

	; Получаем в eax дескриптор стандартного устройства вывода.
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE

	; Получаем информацию о текущем состоянии окна терминала.
	INVOKE GetConsoleScreenBufferInfo, eax, ADDR bufferInfo

	; Вычисляем ширину окна.
	mov ax, bufferInfo.srWindow.Right
	sub ax, bufferInfo.srWindow.Left
	add ax, 1
	
	; Вычисляем высоту окна.
	mov bx, bufferInfo.srWindow.Bottom
	sub bx, bufferInfo.srWindow.Top
	add bx, 1
	
	ret
GetWindowSize ENDP

; Процедура, устанавливающая "случайные" координаты для вывода символа.
SetRandCoord PROC

	; Получаем "случайное" число в диапазоне от 0 до (windowYSize - 1).
	movzx eax, windowYSize
	call RandomRange
	
	; Сохраняем новую позицию курсора по оси OY.
	mov dh, al
	
	; Получаем позицию курсора по оси OX.
	movzx eax, windowXSize
	call RandomRange
	mov dl, al
	
	; Перемещение курсора на координаты, записанные в dh и dl.
	call GotoXY
	
	ret
SetRandCoord ENDP

; Процедура, создающая задержку между выводом символов
; в диапазоне от 10 до 300 мс.
RandDelay PROC

	; Получаем "случайное" число от 10 до 300.
	mov	eax, 291
	call RandomRange
	add eax, 10
	
	; "Засыпаем" на (eax) мс.
	call Delay
	
	ret
RandDelay ENDP

END main