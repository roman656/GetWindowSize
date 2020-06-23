; Все необходимые прототипы процедур и библиотеки находятся тут.
INCLUDE Irvine32.inc

.data
	bufferInfo CONSOLE_SCREEN_BUFFER_INFO <>    ; Необходимо для хранения промежуточных данных.
	
.code
main PROC
	call GetWindowSize
	exit
main ENDP

; Процедура получения размеров окна консоли. Не путать окно и буффер!
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

END main
