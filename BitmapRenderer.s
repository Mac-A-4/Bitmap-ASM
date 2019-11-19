	.text
	.global BitmapDrawLine

	.equ BitmapDrawLine_DX, -4
	.equ BitmapDrawLine_DY, -8
	.equ BitmapDrawLine_DError, -12
	.equ BitmapDrawLine_Error, -16
	.equ BitmapDrawLine_X0, -20
	.equ BitmapDrawLine_X1, -24
	.equ BitmapDrawLine_Y0, -28
	.equ BitmapDrawLine_Y1m -32:

BitmapDrawLine:
	
