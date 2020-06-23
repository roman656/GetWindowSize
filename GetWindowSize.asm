INCLUDE Irvine32.inc

; В eax - ширина, в ebx - высота.

.data
	buffInfo CONSOLE_SCREEN_BUFFER_INFO <>
	
.code
main PROC

	; Получаем в eax дескриптор стандартного устройства вывода.
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE

	; Получаем информацию о текущем состоянии окна терминала.
	INVOKE GetConsoleScreenBufferInfo, eax, ADDR buffInfo

	; Вычисляем ширину окна.
	movzx eax, buffInfo.srWindow.Right
	sub ax, buffInfo.srWindow.Left
	add ax, 1
	
	; Вычисляем высоту окна.
	movzx ebx, buffInfo.srWindow.Bottom
	sub bx, buffInfo.srWindow.Top
	add bx, 1
	
	call DumpRegs
	exit
main ENDP
END main