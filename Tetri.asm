;x86 asm Tetris
;Microprocessors Project
;--------------------------- 
INCLUDE macros.inc
.MODEL HUGE 
.STACK 512
.DATA
;INSERT DATA HERE

;--------External-------
LeftFrameTopWidth EQU  219
LeftFrameTopHeight EQU 54
LeftFrameTopFilename DB 'icetop.bin', 0
LeftFrameTopX		 EQU 90
LeftFrameTopY		 EQU 0
LeftFrameTopFilehandle DW ?

LeftFrameLeftWidth EQU  51
LeftFrameLeftHeight EQU 426
LeftFrameLeftFilename DB 'iceleft.bin', 0
LeftFrameLeftX		 EQU 51
LeftFrameLeftY		 EQU 54
LeftFrameLeftFilehandle DW ?

LeftFrameRightWidth EQU  43
LeftFrameRightHeight EQU 426
LeftFrameRightFilename DB 'iceright.bin', 0
LeftFrameRightX		 EQU 297
LeftFrameRightY		 EQU 54
LeftFrameRightFilehandle DW ?

LeftFrameBottomWidth EQU  197
LeftFrameBottomHeight EQU 54
LeftFrameBottomFilename DB 'icebot.bin', 0
LeftFrameBottomX		 EQU 101
LeftFrameBottomY		 EQU 451
LeftFrameBottomFilehandle DW ?

RightFrameTopWidth EQU  248
RightFrameTopHeight EQU 53
RightFrameTopFilename DB 'firetop.bin', 0
RightFrameTopX		 EQU 576
RightFrameTopY		 EQU 1
RightFrameTopFilehandle DW ?

RightFrameLeftWidth EQU  41
RightFrameLeftHeight EQU 458
RightFrameLeftFilename DB 'fireleft.bin', 0
RightFrameLeftX		 EQU 561
RightFrameLeftY		 EQU 54
RightFrameLeftFilehandle DW ?

RightFrameRightWidth EQU  49
RightFrameRightHeight EQU 461
RightFrameRightFilename DB 'firer.bin', 0
RightFrameRightX		 EQU 797
RightFrameRightY		 EQU 54
RightFrameRightFilehandle DW ?

RightFrameBottomWidth EQU  199
RightFrameBottomHeight EQU 63
RightFrameBottomFilename DB 'firebot.bin', 0
RightFrameBottomX		 EQU 598
RightFrameBottomY		 EQU 452
RightFrameBottomFilehandle DW ?

WideFrameWIDTH	EQU	250
WideFrameHEIGHT EQU	60
WideFrameData	DB	WideFrameHEIGHT*WideFrameWIDTH DUP(0)

TallFrameWIDTH	EQU	60
TallFrameHEIGHT EQU	465
TallFrameData	DB	TallFrameHEIGHT*TallFrameWIDTH DUP(0)

;; Main screen logo data

LogoWidth 			EQU 297D
LogoHeight 			EQU 200D

LogostX				EQU 170D
LogostY				EQU 30D
LogofnX				EQU LogostX + LogoWidth
LogofnY				EQU LogostY + LogoHeight	

Logofilename 		DB 'Logo.bin', 0
LogoFilehandle 		DW ?
positionInLogoFile 	DW 0	
LogoData			DB  0

;--------Powerups-------

PowerupEveryPoint				EQU 4

Player1Score					DB 0			;score of first player
leftPowerupFreezeCount			DB 0
leftPowerupSpeedUpCount			DB 0
leftPowerupRemoveLinesCount		DB 0
leftPowerupChangePieceCount		DB 0
leftPowerupInsertTwoLinesCount	DB 0
leftPieceRotationLock 			DB 0 	;lock the rotation of the piece 0:locked 1:free

Player2Score					DB 0
rightPowerupFreezeCount			DB 0
rightPowerupSpeedUpCount		DB 0
rightPowerupRemoveLinesCount	DB 0
rightPowerupChangePieceCount	DB 0
rightPowerupInsertTwoLinesCount	DB 0
rightPieceRotationLock			DB 0	;lock the rotation of the piece 0:locked 1:free


;--------GameData-------

FRAMEWIDTH        	EQU  10      ;width of each frame in blocks
FRAMEHEIGHT       	EQU  20     ;height of each frame in blocks

GAMESCRWIDTH        EQU  FRAMEWIDTH * BLOCKSIZE     ;width of each screen in pixels
GAMESCRHEIGHT       EQU  FRAMEHEIGHT * BLOCKSIZE     ;height of each screen in pixels

BLOCKSIZE			EQU 20		;size of block is BLOCKSIZE x BLOCKSIZE pixels

								;Tetris grid is 20X10, so each block is 20X20 pixels
GAMELEFTSCRX        DW  100     ;top left corner X of left screen
GAMELEFTSCRY        DW  54      ;top left corner Y of left screen
GAMERIGHTSCRX       DW  600     ;top left corner X of right screen
GAMERIGHTSCRY       DW  54      ;top left corner Y of right screen


FRAMETEXTOFFSET		EQU 50

DeltaScore			EQU 1		;amount of score a player gains by clearing a line

;; Position of player names 

RightPlyLocX		EQU RightScoreLocX-10
RightPlyLocY		EQU RightScoreLocY
LeftPlyLocX			EQU LeftScoreLocX-10
LeftPlyLocY			EQU LeftScoreLocY

;------Pieces Data------

;; Constant pieces data

firstPiece 					DB 0,0,0,0,11,11,11,11,0,0,0,0,0,0,0,0	;Line shape
firstPiece1					DB 0,11,0,0,0,11,0,0,0,11,0,0,0,11,0,0	;Line shape after one rotation
firstPiece2					DB 0,0,0,0,11,11,11,11,0,0,0,0,0,0,0,0	;Line shape after two rotations
firstPiece3					DB 0,11,0,0,0,11,0,0,0,11,0,0,0,11,0,0	;Line shape after Three rotations

secondPiece					DB 1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0	;J shape
secondPiece1				DB 0,1,1,0,0,1,0,0,0,1,0,0,0,0,0,0	;J shape after one rotation
secondPiece2				DB 0,0,0,0,1,1,1,0,0,0,1,0,0,0,0,0	;J shape after two rotations
secondPiece3				DB 0,1,0,0,0,1,0,0,1,1,0,0,0,0,0,0	;J shape after three rotations

thirdPiece 					DB 0,0,0,0,6,6,6,0,6,0,0,0,0,0,0,0	;L shape 
thirdPiece1					DB 6,6,0,0,0,6,0,0,0,6,0,0,0,0,0,0	;L shape after one rotation
thirdPiece2					DB 0,0,6,0,6,6,6,0,0,0,0,0,0,0,0,0	;L shape after two rotations
thirdPiece3					DB 0,6,0,0,0,6,0,0,0,6,6,0,0,0,0,0	;L shape after three rotations

fourthPiece 				DB 0,14,14,0,0,14,14,0,0,0,0,0,0,0,0,0	;square
fourthPiece1				DB 0,14,14,0,0,14,14,0,0,0,0,0,0,0,0,0	;square after one rotation
fourthPiece2				DB 0,14,14,0,0,14,14,0,0,0,0,0,0,0,0,0	;square after two rotations
fourthPiece3				DB 0,14,14,0,0,14,14,0,0,0,0,0,0,0,0,0	;square after three rotation

fifthPiece					DB 0,0,0,0,0,2,2,0,2,2,0,0,0,0,0,0	;S shape
fifthPiece1					DB 0,2,0,0,0,2,2,0,0,0,2,0,0,0,0,0	;S shape after one rotation
fifthPiece2					DB 0,0,0,0,0,2,2,0,2,2,0,0,0,0,0,0	;S shape after two rotations
fifthPiece3					DB 0,2,0,0,0,2,2,0,0,0,2,0,0,0,0,0	;S shape after three rotations

sixthPiece					DB 0,0,0,0,5,5,5,0,0,5,0,0,0,0,0,0	;T shape
sixthPiece1					DB 0,5,0,0,5,5,0,0,0,5,0,0,0,0,0,0	;T shape after one rotation
sixthPiece2					DB 0,5,0,0,5,5,5,0,0,0,0,0,0,0,0,0	;T shape after two rotations
sixthPiece3					DB 0,5,0,0,0,5,5,0,0,5,0,0,0,0,0,0	;T shape after three rotations

seventhPiece 				DB 0,0,0,0,4,4,0,0,0,4,4,0,0,0,0,0	;Z shape
seventhPiece1				DB 0,0,4,0,0,4,4,0,0,4,0,0,0,0,0,0	;Z shape after one rotation
seventhPiece2				DB 0,0,0,0,4,4,0,0,0,4,4,0,0,0,0,0	;Z shape after two rotations
seventhPiece3				DB 0,0,4,0,0,4,4,0,0,4,0,0,0,0,0,0	;Z shape after three rotation

;;PLayer pieces data 

leftPieceId					DB	?			;contains the ID of the current piece
leftPieceOrientation		DB	?			;contains the current orientation of the piece
leftPieceLocX				DB	?			;the Xcoord of the top left corner
leftPieceLocY				DB	?			;the Ycoord of the top left corner
leftPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)
leftPieceSpeed				DB	1			;contains the falling speed of the left piece

rightPieceId				DB	?			;contains the ID of the current piece
rightPieceOrientation		DB	?			;contains the current orientation of the piece
rightPieceLocX				DB	?			;the Xcoord of the top left corner
rightPieceLocY				DB	?			;the Ycoord of the top left corner
rightPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)
rightPieceSpeed				DB	1			;contains the falling speed of the right piece

tempPieceOffset				DW	?			;contains the address of the current piece

;;Coliision piece info

collisionPieceId				DB	?			;contains the ID of the current piece
collisionPieceOrientation		DB	?			;contains the current orientation of the piece
collisionPieceLocX				DB	?			;the Xcoord of the top left corner
collisionPieceLocY				DB	?			;the Ycoord of the top left corner
collisionPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)
collisionPieceSpeed				DB	1			;contains the falling speed of the left piece

;;Next piece info

nextLeftPieceId					DB	?			;contains the ID of the current piece
nextLeftPieceOrientation		DB	?			;contains the next orientation of the piece
nextLeftPieceLocX				DB	?			;the Xcoord of the top left corner
nextLeftPieceLocY				DB	?			;the Ycoord of the top left corner
nextLeftPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)

nextRightPieceId				DB	?			;contains the ID of the current piece
nextRightPieceOrientation		DB	?			;contains the current orientation of the piece
nextRightPieceLocX				DB	?			;the Xcoord of the top left corner
nextRightPieceLocY				DB	?			;the Ycoord of the top left corner
nextRightPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)

tempNextPieceOffset				DW	?			;contains the address of the next piece

;--------Controls-------

;Controls for left screen
leftDownCode			DB	1Fh		;S key
leftLeftCode			DB	1Eh		;A key
leftRightCode			DB	20h		;D key
leftRotCode				DB	11h		;W key
leftPower1				DB  02h		;1 key
leftPower2				DB  03h		;2 key
leftPower3				DB  04h		;3 key
leftPower4				DB  05h		;4 key
leftPower5				DB  06h		;5 key

;Controls for right screen
rightDownCode			DB	50h		;downArrow key
rightLeftCode			DB	4Bh 	;leftArrow key
rightRightCode			DB	4Dh		;rightArrow key
rightRotCode			DB	48h 	;upArrow key
rightPower1				DB	31h		;N key
rightPower2				DB	32h		;M key
rightPower3				DB	33h 	;, key
rightPower4				DB	34h		;. key
rightPower5				DB	35h		;/ key

;General ScanCodes
EnterCode  DB 1CH
F1Code     DB 3BH
F2Code     DB 3CH
F10Code    DB 44H 
EscCode	   DB 01H

;--------Strings--------

;; Next and Score Strings

NEXTPIECETEXTLENGTH EQU 4
NEXTPIECETEXT		DB	"Next"
LEFTNEXTPIECELOCX	EQU 45
LEFTNEXTPIECELOCY	EQU 4
RIGHTNEXTPIECELOCX	EQU 108
RIGHTNEXTPIECELOCY	EQU 4

SCORETEXTLENGTH		EQU 6
SCORETEXT			DB	"Score:"
LeftScoreLocX		EQU 23
LeftScoreLocY		EQU 33
RightScoreLocX		EQU 87
RightScoreLocY		EQU 33

LeftScoreTextLength EQU 2
LeftScoreText		DB "00"
LeftScoreStringLocX	EQU LeftScoreLocX+7
LeftScoreStringLocY	EQU LeftScoreLocY

RightScoreTextLength 	EQU 2
RightScoreText			DB "00"
RightScoreStringLocX	EQU RightScoreLocX+7
RightScoreStringLocY	EQU RightScoreLocY

;; Aux screen strings

UnderlineStringLength 	EQU 128
UnderlineString			DB	"________________________________________________________________________________________________________________________________"

PressEscToExitStringLength 	EQU 24
PressEscToExitString 		DB "Press ESC Key to exit..."

;; Main screen strings

Menu11 	DB "Please enter your name:"
M11sz	EQU 23
Menu12 	DB "Press Enter Key to Continue"
M12sz	EQU 27
Menu21 	DB ", Press F2 to play"
M21sz	EQU 18
Menu22 	DB ", Press F10 to play"
M22sz	EQU 19 

Logo2     DB "*To play tetris press F2"
L2sz   	  EQU 24
Logo3     DB "*To end the program press Esc"
L3sz   	  EQU 29
Logo4	  DB "*To main menu press Enter"
L4sz	  EQU 25	

GameEnded1	DB "Game ended"
GE1sz		EQU 10
GE1X 		EQU 53
GE1Y		EQU 32
		
GameEnded2 	DB "To continue press any key"
GE2sz		EQU 25
GE2X 		EQU 47
GE2Y		EQU 34

Ready  DB 'R'
RPly1  DB  0
RPly2  DB  0

SPACE 		DB ' '
NAME1		DB 15
Ply1Sz		DB ?
Player1		DB 10 DUP(' ')
NAME2 		DB 15
Ply2Sz		DB ?
Player2		DB 10 DUP(' ')
NameSz		EQU 6

;-------General vars-------
Seconds						DB 99			;Contains the previous second value
GameFlag					DB 1			;Status of the game
GRAYBLOCKCLR				EQU	 8		;color of gray solid blocks
;---------------------------
.CODE         
MAIN    PROC    FAR
		MOV AX, @DATA   ;SETUP DATA ADDRESS
		MOV DS, AX      ;MOV DATA ADDRESS TO DS
		MOV ES, AX
		
		CALL GetName
NewGame:
		CALL InitializeNewGame
		CALL DisplayMenu 
;-----------------------------------------------
		mov     AX, 4F02H
        mov     BX, 0105H
        INT     10H

		CALL DrawGameScr
		CALL DrawGUIText

		MOV SI,0
		MOV BX,0
		CALL GetTempNextPiece
		CALL SetNextPieceData
		CALL GenerateRandomPiece

		MOV SI,4
		MOV BX,0
		CALL GetTempNextPiece
		CALL SetNextPieceData
		CALL GenerateRandomPiece

GAMELP:	
		CALL ParseInput
		CALL PieceGravity
		MOV AL,GameFlag
		CMP AL,1
		JNZ Finished
		JMP GAMELP

Finished:
		CALL GameEnded
		CALL EndGameMenu
		JMP NewGame
		
MAIN    ENDP
;---------------------------
InitializeNewGame 	PROC	NEAR
					MOV rightPieceSpeed , 1			;contains the falling speed of the right piece
					MOV Player2Score , 0
					MOV rightPowerupFreezeCount	, 0
					MOV rightPowerupSpeedUpCount , 0
					MOV rightPowerupRemoveLinesCount , 0
					MOV rightPowerupChangePieceCount , 0
					MOV	rightPowerupInsertTwoLinesCount	, 0
					MOV	rightPieceRotationLock ,0
					
					MOV leftPieceSpeed , 1			;contains the falling speed of the left piece
					MOV Player1Score, 0			;score of first player
					MOV leftPowerupFreezeCount	,  0
					MOV leftPowerupSpeedUpCount	,  0
					MOV leftPowerupRemoveLinesCount	,0
					MOV leftPowerupChangePieceCount	, 	0
					MOV leftPowerupInsertTwoLinesCount	,	0
					MOV leftPieceRotationLock ,0
					
					MOV RPly1,0
					MOV Rply2,0
					
					MOV collisionPieceSpeed	, 1
					
					MOV PositionInLogoFile,0
					MOV Seconds,99		
					MOV GameFlag, 1
					RET
InitializeNewGame 	ENDP
;---------------------------
;This PROC draws the screens of the two players given the parameters in data segment
;@param     none
;@return    none
DrawGameScr PROC    NEAR
	MOV SI, 0				;0 for left, 4 for right
	MOV AL, 9               ;frame color
	MOV AH, 0CH             ;draw pixel command
DRAWFRAME:
	MOV CX, GAMELEFTSCRX[SI]    ;beginning of top left X
	MOV DX, GAMELEFTSCRY[SI]   	;beginning of top left Y
	ADD DX, GAMESCRHEIGHT	  	;go to bottom
	;INC DX						;draw at bottom + 1 as this is the border
	MOV BX, GAMELEFTSCRX[SI]
	ADD BX, GAMESCRWIDTH    ;set right limit

DRAWHOR:
	INT 10H                 ;draw bottom


	INC CX                  ;inc X
	CMP CX, BX              ;check if column is at limit
	JBE DRAWHOR             ;if yes, exit loop
	
	MOV CX, GAMELEFTSCRX+[SI]    ;beginning of top left X
	DEC CX						 ;go to left - 1
	MOV DX, GAMELEFTSCRY+[SI]    ;beginning of top left Y
	
	MOV BX, GAMELEFTSCRY+[SI]
	ADD BX, GAMESCRHEIGHT   	 ;set bottom limit
	
DRAWVER:
	
	INT 10H                 ;draw left


	ADD CX, GAMESCRWIDTH    ;go to right
	ADD CX, 1				;draw at right + 1
	INT 10H               ;draw right
	SUB CX, GAMESCRWIDTH    ;go back to left	
	SUB CX, 1

	

	INC DX                  ;inc Y
	CMP DX, BX              ;check if row is at limit
	JBE DRAWVER
	ADD SI, 4				;inc SI
	MOV AL, 4				;set color to red for right frame
	CMP SI, 8				;check if loop ran twice
	JNE	DRAWFRAME

	CALL DrawLeftBorder
	CALL DrawRightBorder
	RET
DrawGameScr ENDP
;---------------------------

;---------------------------
;This PROC draws the pixels surrounding the frame of the two players given the parameters in data segment
;@param     none
;@return    none
drawPixelsFrame PROC    NEAR
	MOV SI, 0				;0 for left, 4 for right
	MOV AL, 8               ;frame color
	MOV AH, 0CH             ;draw pixel command

drawPixelsFrameLoop:
	MOV CX, GAMELEFTSCRX[SI]    ;beginning of top left X
	MOV DX, GAMELEFTSCRY[SI]   	;beginning of top left Y
	ADD DX, GAMESCRHEIGHT	  	;go to bottom
	;INC DX						;draw at bottom + 1 as this is the border
	MOV BX, GAMELEFTSCRX[SI]
	ADD BX, GAMESCRWIDTH    ;set right limit
	
	ADD CX,5D
	ADD DX,5D

DRAWPIXELHOR:
	INT 10H                 ;draw bottom
	ADD CX,10D               ;inc X
	CMP CX, BX              ;check if column is at limit
	JBE DRAWPIXELHOR             ;if yes, exit loop
	

	MOV CX, GAMELEFTSCRX+[SI]    ;beginning of top left X
	DEC CX						 ;go to left - 1
	MOV DX, GAMELEFTSCRY+[SI]    ;beginning of top left Y
	
	MOV BX, GAMELEFTSCRY+[SI]
	ADD BX, GAMESCRHEIGHT   	 ;set bottom limit
	
	SUB CX, 5D
	ADD DX, 5D

DRAWPIXELVER:
	INT 10H                 ;draw left

	ADD CX, GAMESCRWIDTH    ;go to right
	ADD CX, 10D				;draw at right + 1
	INT 10H               ;draw right
	SUB CX, GAMESCRWIDTH    ;go back to left	
	SUB CX, 10D

	

	ADD DX,10D                  ;inc Y
	CMP DX, BX              ;check if row is at limit
	JBE DRAWPIXELVER

	ADD SI, 4				;inc SI
	CMP SI, 8				;check if loop ran twice
	JNE	drawPixelsFrameLoop

	RET
drawPixelsFrame ENDP
;---------------------------------
;Takes a block (X,Y) in the N*M grid of tetris and returns the color of the block
;@param		CX: X coord,
;		    DX: Y coord, 
;			SI: screen ID: 0 for left, 4 for right
;@return	AL:	color for (X,Y) grid
GetBlockClr	PROC	NEAR							;XXXXXXXXX - NEEDS TESTING
	PUSH CX
	PUSH DX
	PUSH BX
	PUSH SI
	MOV AX, CX		;top left of (X,Y) block is BLOCKSIZE*X + gridTopX
	MOV BL, BLOCKSIZE	
	MUL BL
	ADD AX, 5D
	ADD AX, GAMELEFTSCRX[SI]
	MOV	CX, AX		;CX = BLOCKSIZE*Xcoord + gridTopX + 5
	
	MOV AX, DX		;same as above
	MUL BL
	ADD AX, 5D
	ADD AX, GAMELEFTSCRY[SI]
	MOV DX, AX
	
	MOV AH, 0DH
	PUSH BX
	MOV BH, 0
	INT 10H
	POP BX

	POP SI
	POP BX
	POP DX
	POP CX
	RET
GetBlockClr	ENDP
;---------------------------
;Takes a block (X,Y) in the N*M grid of tetris and colors the block with a given color
;@param		CX:	X coord,
;			DX: Y coord,
;			SI: screen ID: 0 for left, 4 for right
;			AL: color for (X,Y) grid
;@return	none
DrawBlockClr	PROC	NEAR
	PUSHA
	MOV DI, AX		;push color to DI
					;go to top left of block
	MOV	AX, CX
	MOV BL, BLOCKSIZE
	MUL BL
	ADD AX, GAMELEFTSCRX[SI]
	MOV CX, AX		;CX = BLOCKSIZE*Xcoord + gridTopX
	
	MOV AX, DX
	MUL BL
	ADD AX, GAMELEFTSCRY[SI]
	MOV DX, AX		;DX = BLOCKSIZE*Ycoord + gridTopY
	
	MOV AX, DI		;pop color to AX
	
	MOV DI, CX		;DI = limit of CX
	ADD DI, BLOCKSIZE		;DI = CX + BLOCKSIZE (LIMIT OF CX)
	MOV BX, DX		;BX = limit of DX
	ADD	BX, BLOCKSIZE		;BX = DX + BLOCKSIZE (LIMIT OF DX)

	MOV AH, 0CH
LOOPX:
	MOV DX, BX		;Reset DX to original Y
	SUB DX, BLOCKSIZE
LOOPY:
	INT 10H			;draw pixel at (CX,DX)
	INC DX			;go to next pixel Y
	CMP DX, BX		
	JNZ LOOPY
	INC CX
	CMP CX, DI
	JNZ LOOPX
	
	POPA
	RET
DrawBlockClr	ENDP
;---------------------------
;This procedure sets the next piece data for left or right screen according to tempNextPieceOffset
;@param			BX: Piece ID			
;@return		none
SetNextPieceData	PROC	NEAR
		PUSHA
		MOV DI,	tempNextPieceOffset
		MOV SI, 0d			;initialize counter	
		MOV [DI], BX		;move id of selected piece to selectedScreenPiece
		MOV AH, 0
		MOV [DI+1], AH		;set orientation to 0
		MOV AH, 0D
		MOV [DI+3], AH		;set pieceY to 0
		MOV AH, 04D			;set pieceX to 4
		MOV [DI+2], AH
		
		ADD DI, 4d			;jump to piece data
		MOV AX, BX
		MOV BX, 64d			
		MUL BX
		MOV BX, AX
SETSCRPIECELOP:	
		MOV CL, firstPiece[BX][SI]
		MOV [DI], CL
		INC DI
		INC SI
		CMP SI, 16d
		JNZ SETSCRPIECELOP
		POPA
		RET
SetNextPieceData	ENDP
;---------------------------
;This procedure copies the piece address into tempPiece according to SI
;@param			SI: screenId: 0 for left, 4 for right
;@return		none 
GetTempPiece	PROC	NEAR
		PUSH SI
		CMP SI, 0					;If the screen is left
		JNZ	RIGHT
		LEA SI, leftPieceId			;copy the leftPieceOffset to SI
		MOV tempPieceOffset, SI		;load the leftPieceOffset to tempPieceOffset
		JMP EXT
RIGHT:										;else if the screen is right
		LEA SI, rightPieceId		;copy the rightPieceOffset to SI
		MOV tempPieceOffset, SI		;load the rightPieceOffset to tempPieceOffset
EXT:	POP SI
		RET
GetTempPiece	ENDP
;---------------------------
;This procedure copies the next piece address into tempNextPiece according to SI
;@param			SI: screenId: 0 for left, 4 for right
;@return		none 
GetTempNextPiece	PROC	NEAR
		PUSH SI
		CMP SI, 0					;If the screen is left
		JNZ	RIGHT1
		LEA SI, nextLeftPieceId			;copy the leftPieceOffset to SI
		MOV tempNextPieceOffset, SI		;load the leftPieceOffset to tempPieceOffset
		JMP EXT1
RIGHT1:										;else if the screen is right
		LEA SI, nextRightPieceId		;copy the rightPieceOffset to SI
		MOV tempNextPieceOffset, SI		;load the rightPieceOffset to tempPieceOffset
EXT1:	POP SI
		RET
GetTempNextPiece	ENDP
;---------------------------
;This procedure clears the current temp piece (used in changing direction or rotation)	;NEEDS TESTING
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
DeletePiece		PROC	NEAR
		PUSHA
		MOV BX, tempPieceOffset
		MOV DI, BX						;Load the piece 4x4 string address in pieceData
		ADD DI,	4						;Go to the string data to put in DI
		MOV CX, 0D						;iterate over the 16 cells of the piece
		;if the piece has color !black, draw it with black
		;cell location is:
		;cell_x = orig_x + id%4
		;cell_y = orig_y + id/4
LOPX:			
		MOV DL, [DI]					;copy the byte of color of current cell into DL
		CMP DL, 0D						;check if color of current piece block is black
		JZ 	ISBLACK
		
		PUSH CX
		
		MOV AX, CX
		MOV CL, 4D
		DIV CL						;AH = id%4, AL = id/4
		MOV CX, 0
		MOV DX, 0
		MOV CL, [BX+2]				;load selected piece X into CL
		MOV DL, [BX+3]				;load selected piece Y into DL
		ADD CL, AH					;CX = orig_x + id%4
		ADD DL, AL					;DX = orig_y + id/4
		
		MOV AL, 0

		CALL DrawBlockClr
		
		POP  CX
ISBLACK:		
		INC CX
		INC DI
		CMP CX, 16D
		JNZ LOPX
		POPA
		RET
DeletePiece		ENDP
;---------------------------
;This procedure draws the piece stored in temp piece
;in it's corresponding Data,(X,Y)
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
DrawPiece		PROC	NEAR
		PUSHA
		MOV BX, tempPieceOffset
		MOV DI, BX						;Load the piece 4x4 string address in pieceData
		ADD DI,	4						;Go to the string data to put in DI
		MOV CX, 0D						;iterate over the 16 cells of the piece
		;if the piece has color !black, draw it with it's color
		;cell location is:
		;cell_x = orig_x + id%4
		;cell_y = orig_y + id/4
DRAWPIECELOPX:			
		MOV DL, [DI]					;copy the byte of color of current cell into DL
		CMP DL, 0D						;check if color of current piece block is black
		JZ	 DRAWPIECEISBLACK
		
		PUSH CX
		
		MOV AX, CX
		MOV CL, 4D
		DIV CL						;AH = id%4, AL = id/4
		MOV CX, 0
		MOV DX, 0
		MOV CL, [BX+2]				;load selected piece X into CL
		MOV DL, [BX+3]				;load selected piece Y into DL
		ADD CL, AH					;CX = orig_x + id%4
		ADD DL, AL					;DX = orig_y + id/4
		
		MOV AL, [DI]

		CALL DrawBlockClr
		
		POP  CX
DRAWPIECEISBLACK:		
		INC DI
		INC CX
		CMP CX, 16D
		JNZ DRAWPIECELOPX


		POPA
		RET
DrawPiece		ENDP
;---------------------------
;This procedure takes the direction to move the piece in and re-draws it in the new location	;NOT FINISHED
;@param			
;				BX: direction{0:down, 1:left, 2:right}
;				SI: screenId: 0 for left, 4 for right
;@return		NONE
MovePiece		PROC	NEAR
		PUSHA
		PUSH BX

		;PUT TEMP PIECE IN MEMORY
		CALL GetTempPiece

		CALL DeletePiece

		;INSERT COLLISION DETECTION HERE
		CALL setCollisionPiece		;Set the offset of the collision piece from temp piece

		CMP BX, 0D					;check for direction of movement
		JZ DOWNDTEMP
		CMP BX, 1D
		JZ LEFTDTEMP
		CMP BX, 2D
		JZ RIGHTDTEMP
DOWNDTEMP:									;move collision piece downward
		MOV BX, offset collisionPieceId
		INC BYTE PTR [BX+3]
		JMP COLLPIECEBRK
LEFTDTEMP:									;move collision piece left 
		MOV BX, offset collisionPieceId
		DEC BYTE PTR [BX+2]
		JMP COLLPIECEBRK
RIGHTDTEMP:									;move collision piece right
		MOV BX, offset collisionPieceId
		INC BYTE PTR [BX+2]		
COLLPIECEBRK:
		CALL CheckCollision					;check if collisionPiece collides
											;AH will be 1 if it collides, 0 if not
		;CALL DrawPiece
		POP BX
		CMP AL, 1
		PUSHF								;Saves the flags to determine if the piece moved or stayed in place
		JZ	BREAKMOVEPIECE					;If the piece collides, break the procedure and leave

		;DELETE THE PIECE FROM THE SCREEN
		;CALL DeletePiece
		;INSERT MOVING LOGIC HERE
	
		CMP BX, 0D
		JZ DOWND
		CMP BX, 1D
		JZ LEFTD
		CMP BX, 2D
		JZ RIGHTD
DOWND:			
		MOV BX, tempPieceOffset
		INC BYTE PTR [BX+3]
		JMP MOVPIECEBRK
LEFTD:
		MOV BX, tempPieceOffset
		DEC BYTE PTR [BX+2]
		JMP MOVPIECEBRK
RIGHTD:
		MOV BX, tempPieceOffset
		INC BYTE PTR [BX+2]
MOVPIECEBRK:	;DRAW THE NEW PIECE IN NEW LOCATION

BREAKMOVEPIECE:
		CALL DrawPiece
		POPF
		POPA
		RET
MovePiece		ENDP
;---------------------------
;This procedure rotates the current piece that's pointed to by the tempPieceOffset by 90 degree from the previous rotation
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
RotatePiece		PROC NEAR
				PUSHA
				CALL DeletePiece
				CALL GetTempPiece
				MOV BX,tempPieceOffset		;Loads the address of the current piece
				LEA DI,firstPiece
				
				MOV AL,[BX]					;Checks ID of the current piece and stores the offset of the original piece's Data in DI
				CMP AL,0
				JZ	ORIEN
				ADD DI,40H
				CMP AL,1
				JZ ORIEN
				ADD DI,40H
				CMP AL,2
				JZ ORIEN
				ADD DI,40H
				CMP AL,3
				JZ ORIEN
				ADD DI,40H
				CMP AL,4
				JZ ORIEN
				ADD DI,40H
				CMP AL,5
				JZ ORIEN
				ADD DI,40H	

ORIEN:										;Checks the current piece orientation to determine which orientation of the piece to choose
				INC BX	
				MOV AL,[BX]
				CMP AL,0
				JZ ROTATE90
				CMP AL,1
				JZ ROTATE180
				CMP AL,2
				JZ ROTATE270
				CMP AL,3
				JZ ROTATE360
				
		

ROTATE90:		;Checks for collision before rotating the piece	
				MOV CX,10H
				CALL RotationCollision
				JZ BREAK
				;Piece is clear to rotate without collision so we proceed with the rotation process
				MOV CL,1					;sets the new orientation of the piece in the data
				MOV [BX],CL
				ADD BX,3					;SI now points to the left/right piece data
				ADD DI,10H					;DI now points to the data of the new orientation
				MOV CX,16
COPYDATA0:		MOV DL,[DI]
				MOV [BX],DL
				INC DI
				INC BX
				LOOP COPYDATA0
				JMP BREAK
				
ROTATE180:		
				MOV CX,20H
				CALL RotationCollision
				JZ BREAK
				;Piece is clear to rotate without collision so we proceed with the rotation process
				MOV CL,2					;sets the new orientation of the piece in the data
				MOV [BX],CL
				ADD BX,3					;SI now points to the left/right piece data
				ADD DI,20H					;DI now points to the data of the new orientation
				MOV CX,16
COPYDATA1:		MOV DL,[DI]
				MOV [BX],DL
				INC DI
				INC BX
				LOOP COPYDATA1
				JMP BREAK
				
ROTATE270:		
				MOV CX,30H
				CALL RotationCollision
				JZ BREAK
				;Piece is clear to rotate without collision so we proceed with the rotation process
				MOV CL,3					;sets the new orientation of the piece in the data
				MOV [BX],CL
				ADD BX,3					;SI now points to the left/right piece data
				ADD DI,30H					;DI now points to the data of the new orientation
				MOV CX,16
COPYDATA2:		MOV DL,[DI]
				MOV [BX],DL
				INC DI
				INC BX
				LOOP COPYDATA1
				JMP BREAK
				
ROTATE360:		
				MOV CX,00H
				CALL RotationCollision
				JZ BREAK
				;Piece is clear to rotate without collision so we proceed with the rotation process
				MOV CL,0					;sets the new orientation of the piece in the data
				MOV [BX],CL
				ADD BX,3					;SI now points to the left/right piece data
				MOV CX,16
COPYDATA3:		MOV DL,[DI]
				MOV [BX],DL
				INC DI
				INC BX
				LOOP COPYDATA3
				JMP BREAK
						
BREAK:			
				POPA
				CALL DrawPiece				
				RET
RotatePiece		ENDP	
;---------------------------
;This procedure parses input and calls corresponding procedures
;@param			none
;@return		none
ParseInput		PROC	NEAR
		MOV AH, 1
		INT 16H
		JNZ YesInput
		RET
YesInput:
		MOV AH, 0
		INT 16H
ExitGame:
		CMP AH, ESCCode
		JNZ LeftRotKey

		;------ this should be changed to return to menu instead
		CALL EndGame

		JMP BreakParseInput
LeftRotKey:
		CMP AH, leftRotCode
		JNZ LeftLeftKey

		CMP leftPieceRotationLock,1 ;check if the rotation is locked
		JZ LeftRotKeyParsed

		MOV SI, 0
		CALL GetTempPiece

		MOV SI,0
		CALL RotatePiece
LeftRotKeyParsed:
		JMP BreakParseInput
LeftLeftKey:
		CMP AH, leftLeftCode
		JNZ LeftDownKey
		MOV SI, 0
		CALL GetTempPiece

		MOV SI, 0
		MOV BX, 1
		CALL MovePiece

		JMP BreakParseInput
LeftDownKey:
		CMP AH, leftDownCode
		JNZ LeftRightKey
		MOV SI, 0
		CALL GetTempPiece

		MOV SI,0
		MOV BX,0
		CALL MovePiece


		JMP BreakParseInput
LeftRightKey:
		CMP AH, leftRightCode
		JNZ RightRotKey
		MOV SI, 0
		CALL GetTempPiece

		MOV SI,0
		MOV BX,2
		CALL MovePiece

		JMP BreakParseInput
RightRotKey:
		CMP AH, rightRotCode
		JNZ RightLeftKey

		CMP rightPieceRotationLock,1 ;check if the rotation is locked
		JZ BreakRotParseInput

		MOV SI, 4
		CALL GetTempPiece

		MOV SI, 4
		CALL RotatePiece
BreakRotParseInput:
		JMP BreakParseInput
RightLeftKey:
		CMP AH, rightLeftCode
		JNZ RightDownKey
		MOV SI, 4
		CALL GetTempPiece

		MOV SI, 4
		MOV BX, 1
		CALL MovePiece

		JMP BreakParseInput
RightDownKey:
		CMP AH, rightDownCode
		JNZ RightRightKey
		MOV SI, 4
		CALL GetTempPiece

		MOV SI, 4
		MOV BX, 0
		CALL MovePiece

		JMP BreakParseInput
RightRightKey:
		CMP AH, rightRightCode
		JNZ LeftPowerup1
		MOV SI, 4
		CALL GetTempPiece
		
		MOV SI, 4
		MOV BX, 2
		CALL MovePiece
		JMP BreakParseInput

LeftPowerup1:
		CMP AH, leftPower1
		JNZ LeftPowerup2

		MOV AH, leftPowerupFreezeCount
		CMP AH, 0
		JZ	BreakPowerup1

		MOV SI, 0
		CALL FreezeRotation
		SUB leftPowerupFreezeCount, 1
		CALL UpdatePowerupsScore

BreakPowerup1:
		JMP BreakParseInput

LeftPowerup2:
		CMP AH, leftPower2
		JNZ LeftPowerup3

		MOV AH, leftPowerupSpeedUpCount
		CMP AH, 0
		JZ	BreakPowerup2

		MOV SI, 0
		CALL SpeedUpOpponentPiece
		SUB leftPowerupSpeedUpCount, 1
		CALL UpdatePowerupsScore

BreakPowerup2:
		JMP BreakParseInput
LeftPowerup3:
		CMP AH, leftPower3
		JNZ LeftPowerup4
		
		MOV AH, leftPowerupRemoveLinesCount
		CMP AH, 0
		JZ	BreakPowerup3

		MOV SI, 0
		CALL RemoveFourLines
		SUB leftPowerupRemoveLinesCount, 1
		CALL UpdatePowerupsScore
BreakPowerup3:
		JMP BreakParseInput
LeftPowerup4:
		CMP AH, LeftPower4
		JNZ LeftPowerup5

		MOV AH, leftPowerupChangePieceCount
		CMP AH, 0
		JZ	BreakPowerup4

		MOV SI,0
		CALL ChangePiece
		SUB leftPowerupChangePieceCount,1
		CALL UpdatePowerupsScore
BreakPowerup4:
		JMP BreakParseInput

LeftPowerup5:
		CMP AH, LeftPower5
		JNZ RightPowerup1

		MOV AH, leftPowerupInsertTwoLinesCount
		CMP AH, 0
		JZ	BreakPowerup5


		MOV SI,0
		CALL InsertTwoLines
		SUB leftPowerupInsertTwoLinesCount,1
		CALL UpdatePowerupsScore

BreakPowerup5:
		JMP BreakParseInput

RightPowerup1:
		CMP AH, RightPower1
		JNZ RightPowerup2

		MOV AH, rightPowerupFreezeCount
		CMP AH, 0
		JZ	BreakPowerup5

		MOV SI, 4
		CALL FreezeRotation
		SUB rightPowerupFreezeCount, 1
		CALL UpdatePowerupsScore

		JMP BreakParseInput
RightPowerup2:
		CMP AH, RightPower2
		JNZ RightPowerup3

		MOV AH, rightPowerupSpeedUpCount
		CMP AH, 0
		JZ	BreakPowerup5

		MOV SI, 4
		CALL SpeedUpOpponentPiece
		SUB rightPowerupSpeedUpCount, 1
		CALL UpdatePowerupsScore

		JMP BreakParseInput
RightPowerup3:
		CMP AH, RightPower3
		JNZ RightPowerup4

		MOV AH, rightPowerupRemoveLinesCount
		CMP AH, 0
		JZ	BreakPowerup5

		MOV SI, 4
		CALL RemoveFourLines
		SUB rightPowerupRemoveLinesCount, 1
		CALL UpdatePowerupsScore

		JMP BreakParseInput
RightPowerup4:
		CMP AH, RightPower4
		JNZ RightPowerup5

		MOV AH, rightPowerupChangePieceCount
		CMP AH, 0
		JZ	BreakPowerup5

		MOV SI,4
		CALL ChangePiece
		SUB rightPowerupChangePieceCount,1
		CALL UpdatePowerupsScore

		JMP BreakParseInput
RightPowerup5:
		CMP AH, RightPower5
		JNZ BreakParseInput

		MOV AH, rightPowerupInsertTwoLinesCount
		CMP AH, 0
		JZ	BreakParseInput

		MOV SI,4
		CALL InsertTwoLines
		SUB rightPowerupInsertTwoLinesCount,1
		CALL UpdatePowerupsScore

		JMP BreakParseInput

BreakParseInput:
		RET
ParseInput		ENDP
;---------------------------
;This Procedure is called in the gameloop to move the pieces downward each second
;@param			none
;@return		none
PieceGravity	PROC	NEAR
				PUSHA
				mov  AH, 2CH
				INT  21H 			;RETURN SECONDS IN DH.
				CMP DH,seconds		;Check if one second has passed
				JE NO_CHANGE
				MOV seconds,DH		;moves current second to the seconds variable
				MOV BX,0			;Parameter to move piece in particular direction
				MOV SI,0
				CALL GetTempPiece	;sets the TempPieceOffset with the address of the leftPiece
				MOV AX,0			;Clearing AX before using it
				MOV AX,tempPieceOffset ;gets the leftPiece's data offset
				ADD AX,14H			;Access the speed of the left piece
				MOV DI,AX			;DI=leftPieceSpeed
				MOV CX,0			;Clears the CX before looping
				MOV CL,[DI]			;moves the piece number of steps equal to it's speed
		MOVELEFT:		
				CALL MovePiece
				JZ COLL1
				LOOP MOVELEFT
				JMP CHECK2
		COLL1:	
				MOV SI,0
				CALL UnfreezeRotation
				CALL ResetPieceSpeed	;if changed reset it to its original
				CALL CheckLineClear		;check if a line has been cleared
				CALL GenerateRandomPiece
				
		CHECK2:	MOV SI,4			
				CALL GetTempPiece	;sets the TempPieceOffset with the address of the rightPiece
				MOV AX,0			;Clearing AX before using it
				MOV AX,tempPieceOffset	;gets the rightPiece's data offset
				ADD AX,14H			;Access the speed of the right piece
				MOV DI,AX			;DI=rightPieceSpeed
				MOV CX,0			;Clears the CX before looping
				MOV CL,[DI]			;moves the piece number of steps equal to it's speed
		MOVERIGHT:		
				CALL MovePiece
				JZ	COLL2
				LOOP MOVERIGHT
				JMP NO_CHANGE
		COLL2:	
				MOV SI,4
				CALL UnfreezeRotation
				CALL ResetPieceSpeed	;if chnaged reset it to its original speed
				CALL CheckLineClear		;check if a line has been cleared
				CALL GenerateRandomPiece
		NO_CHANGE:	
				POPA
				RET
PieceGravity	ENDP	
;---------------------------
;This procedure sets the collision piece by copying temp piece data to collision data
;@params	none
;@return 	none
setCollisionPiece	PROC	NEAR
			PUSHA

			MOV SI, tempPieceOffset  		;get the offset of the source data
			MOV DI, offset collisionPieceId	;offset of the destination data

			
			MOV CX, 21D						;loop 21 bytes to copy all the data
copyPieceData:		MOV BL, [SI]					;copy the data in byte to BX
			MOV [DI], BL					;paste the data in the destination byte
			INC DI							;increment destination offset
			INC SI							;increment source offset
			LOOP copyPieceData				;loop

			POPA
			RET
setCollisionPiece	ENDP
;---------------------------
;Procedure to check the collision of the collisionPiece with the blocks
;@params: NONE
;@return: AL: 1 collision, 0 no collision
CheckCollisionWithBlocks	PROC	NEAR
				PUSHA

				MOV BX, offset collisionPieceId
				MOV DI, BX						;Load the piece 4x4 string address in pieceData
				ADD DI,	4						;Go to the string data to put in DI
				MOV CX, 0						;iterate over the 16 cells of the piece
				;if the piece has color !black, draw it with it's color
				;cell location is:
				;cell_x = orig_x + id%4
				;cell_y = orig_y + id/4

		loopOverPieceData:			
				MOV DL, [DI]					;copy the byte of color of current cell into DL
				CMP DL, 0D						;check if color of current piece block is black
				JZ	 checkNextByte

				;If byte has color
				PUSH CX

				MOV AX, CX
				MOV CL, 4D
				DIV CL						;AH = id%4, AL = id/4
				MOV CX, 0
				MOV DX, 0
				MOV CL, [BX+2]				;load selected piece X into CL
				MOV DL, [BX+3]				;load selected piece Y into DL
				ADD CL, AH					;CX = orig_x + id%4
				ADD DL, AL					;DX = orig_y + id/4

				CALL GetBlockClr

				CMP AL, 0D
				POP  CX
				JNZ collisionWithBlockHappens 

				
			
			checkNextByte:
				INC CX		
				INC DI
				CMP CX, 16D
				JNZ loopOverPieceData
				
				POPA
				MOV AL,0D
				RET

				collisionWithBlockHappens:

				POPA
				MOV AL,1D
				RET

CheckCollisionWithBlocks	ENDP
;---------------------------
CheckCollisionWithFrame	PROC	NEAR
						PUSHA

		MOV BX, offset collisionPieceId
		MOV DI, BX						;Load the piece 4x4 string address in pieceData
		ADD DI,	4						;Go to the string data to put in DI
		MOV CX, 0D						;iterate over the 16 cells of the piece
		;if the piece has color !black, draw it with black
		;cell location is:
		;cell_x = orig_x + id%4
		;cell_y = orig_y + id/4
CheckCollisionWithFrameLoop:			
		MOV DL, [DI]					;copy the byte of color of current cell into DL
		CMP DL, 0D						;check if color of current piece block is black
		JZ 	blockEmpty
		
		PUSH CX
		
		MOV AX, CX
		MOV CL, 4D
		DIV CL						;AH = id%4, AL = id/4
		MOV CX, 0
		MOV DX, 0
		MOV CL, [BX+2]				;load selected piece X into CL
		MOV DL, [BX+3]				;load selected piece Y into DL
		ADD CL, AH					;CX = orig_x + id%4
		ADD DL, AL					;DX = orig_y + id/4
		
		CMP CX, FRAMEWIDTH
		JAE outOfScreen
		CMP DX, FRAMEHEIGHT
		JAE outOfScreen 
		 
		POP  CX
blockEmpty:		
		INC CX
		INC DI
		CMP CX, 16D
		JNZ CheckCollisionWithFrameLoop

		POPA
		MOV AL,0
		RET

outOfScreen:
			POP  CX
			POPA
			MOV AL,1
			RET
CheckCollisionWithFrame	ENDP
;---------------------------
;Procedure to check the collision with both the frame and blocks
;@params: SI:0 for left screen,4 for right screen
;@return: AL: 1 collision, 0 no collision
CheckCollision	PROC	NEAR
				CALL CheckCollisionWithFrame
				CMP AL, 1
				JE CollisionHappens

				CALL CheckCollisionWithBlocks
				CMP AL,1
				JE CollisionHappens

				MOV AL,0
				RET
CollisionHappens: 
				MOV AL,1
				RET
CheckCollision	ENDP
;---------------------------
;Procedure to generate a random piece and set it's data in current screen data
;@param		SI:0 for left screen,4 for right screen
;@return 	GameFlag Var = Screen that lost
GenerateRandomPiece		PROC 	NEAR
						PUSHA
						MOV AH,2CH
						INT 21H		;Returns seconds in DH
						MOV AX,0
						MOV AL,DH	;AL=Seconds
						MOV CX,7
						DIV CL
						MOV BX,0
						MOV BL,AH	;BL now contains the ID of the random piece
						CALL CopyNextPieceData
						CALL GetTempNextPiece
						CALL DeleteNextPiece
						CALL SetNextPieceData
						CALL DrawNextPiece
						CALL setCollisionPiece
						CALL CheckCollision
						CMP AL,1
						JZ COLLIDE
						CALL DrawPiece
						POPA
						RET
COLLIDE:				
						MOV BX,SI
						MOV GameFlag,BL
						POPA
						RET
GenerateRandomPiece		ENDP

;---------------------------
;Procedure to generate a random number
;@param		BL: Random Number % AL 
;@return 	BL: the random number
GenerateRandomNumber	PROC 	NEAR
						PUSH AX
						PUSH DX
						PUSH CX
						
						MOV AH,2CH
						INT 21H		;Returns seconds in DH
						MOV AX,0
						MOV AL,DH	;AL=Seconds
						DIV BL
						MOV BX,0
						MOV BL,AH	;BL now contains the ID of the random piece
						
						POP CX
						POP DX
						POP AX
						
						RET
GenerateRandomNumber	ENDP
;---------------------------
;Procedure to check for collision before rotation
;@param			CX:Added number to go the correct piece, SI:0 for left , 4 for right
;@return		ZF:if 0 then collided ,1 clear to rotate
RotationCollision	PROC	NEAR
					PUSHA
					DEC BX						;SI Points to PieceID
					ADD DI,CX					;DI Points to the data after applying the rotation
					PUSH DI					;Stack holds temporarily offset of the data after rotation
					MOV DI,offset collisionPieceId	;DI = collisionPieceID
					MOV CX,4
COPYCOLL0:			MOV AL,[BX]
					MOV [DI],AL
					INC BX
					INC DI
					LOOP COPYCOLL0
					ADD BX,16D
					ADD DI,16D
					MOV AL,[BX]
					MOV [DI],AL
					SUB DI,16D
					POP BX			;BX holds offset of the data after rotation
					MOV CX,16
COPYCOLLDATA0:		MOV AL,[BX]
					MOV [DI],AL
					INC BX
					INC DI
					LOOP COPYCOLLDATA0
					CALL CheckCollision
					CMP AL,1
					POPA
					RET
RotationCollision	ENDP
;---------------------------
;Shifts all the line up from Y = 0:14	 and X = 0:9
;@param			SI: screen ID: 0 for left, 4 for right
;@return		none
ShiftLinesUp	PROC	NEAR
				PUSHA

				CALL GetTempPiece
				CALL setCollisionPiece
				CALL DeletePiece		;we need to remove the piece before shifting, to avoid shifting the piece itself

				MOV DX, 0D				;initialize dx at 0
SHIFTUPLOOPY:
				MOV CX, 0D
SHIFTUPLOOPX:
				INC DX
				CALL GetBlockClr		;get block color at (X,Y+1)
				DEC DX
				CALL DrawBlockClr		;draw block color at (X,Y)

				INC CX
				CMP CX, FRAMEWIDTH		;check if X is 10
				JNZ SHIFTUPLOOPX		;if it is, start back from X = 0 at new Y

				INC DX	
				CMP DX, FRAMEHEIGHT-1	;check if Y is = 15
				JNZ SHIFTUPLOOPY

				CALL CheckCollisionWithBlocks
				CMP AL, 1
				JNZ ShiftUpNoCollision

				MOV AL, 1
				CALL GetTempPiece
				MOV BX, tempPieceOffset
				ADD BX, 3
				SUB [BX], AL

ShiftUpNoCollision:
				CALL DrawPiece

				POPA
				RET
ShiftLinesUp	ENDP
;---------------------------
;Shifts all the line down from Y = 0:Y_in and X = 0:9
;@param 		SI: screen ID: 0 for left, 4 for right
;				DX:	Y_in to begin shifting down at
;@return		none
ShiftLinesDown	PROC	NEAR
				PUSHA
				;DX is initially Y_in
SHIFTDOWNLOOPY:
				MOV CX, 0D
SHIFTDOWNLOOPX:
				DEC DX
				CALL GetBlockClr		;get block color at (X,Y+1)
				INC DX
				CALL DrawBlockClr		;draw block color at (X,Y)

				INC CX
				CMP CX, FRAMEWIDTH		;check if X is = FRAME WIDTH
				JNZ SHIFTDOWNLOOPX		;if it is, start back from X = 0 at new Y

				DEC DX	
				CMP DX, 0D 				;check if Y is = 0
				JNZ SHIFTDOWNLOOPY

				MOV CX, 0D
				MOV DX, 0D
				MOV AL, 0D
CLEARFIRSTLINE:	
				CALL DrawBlockClr				
				INC CX
				CMP CX, 10D
				JNZ CLEARFIRSTLINE
				POPA
				RET
ShiftLinesDown	ENDP
;---------------------------
;This procedure inserts a new gray line at the screen
;@param			SI: screen ID: 0 for left, 4 for right
;@return		none
InsertLine		PROC	NEAR
				PUSHA
				CALL ShiftLinesUp		;shift all lines up 1 block

				;draw a gray line at X = 0
				MOV DX, FRAMEHEIGHT-1
				MOV CX, 0D
				MOV AL, GRAYBLOCKCLR
INSERTLINELOOPX:						;loop from x=0:10 and draw gray block		
				CALL DrawBlockClr
				INC CX
				CMP CX, FRAMEWIDTH		
				JNZ INSERTLINELOOPX



				POPA
				RET
InsertLine		ENDP
;---------------------------
;This procedure removes the line at Y = Y_in and shifts all lines down
;@param			SI: screen ID: 0 for left, 4 for right
;				DX: Y_in to have the line removed at
;@return		none
RemoveLine		PROC	NEAR

				CALL ShiftLinesDown

				RET
RemoveLine		ENDP
;---------------------------
;This procedure checks if a full line has been completed, if it is, it gets cleared
;@param			SI: screen ID: 0 for left, 4 for right
;@return		none
CheckLineClear	PROC	NEAR
				PUSHA

				MOV DX, 0D
CHECKLINELOOPY:
				MOV CX, 0D
				MOV BX, 0D 					;counter for the number of colored blocks
CHECKLINELOOPX:
				CALL GetBlockClr
				CMP AL, 0D					;if block color is not black or gray, inc BX
				JE 	CHECKLINESKIPINC
				CMP AL, GRAYBLOCKCLR
				JE	CHECKLINESKIPINC

				INC BX
				INC CX
				CMP CX, FRAMEWIDTH
				JNZ CHECKLINELOOPX
CHECKLINESKIPINC:
				CMP BX, 10D					;check if there is 16 colored blocks
				JNZ	CHECKLINESKIPRMV		;if there is, delete that line
				CALL RemoveLine

				;now we need to insert a line at the other player
				MOV AX, SI
				CMP SI, 0D
				JNZ CHECKLINESIIS0			;if SI is 4, make it 0, if it's 0, make it 4
				ADD Player1Score, DeltaScore		;increase score
				CALL AddPowerupCheck
				CALL UpdatePlayersScore

				MOV SI, 4D
				JMP CHECKLINESIIS4
CHECKLINESIIS0:
				ADD Player2Score, DeltaScore		;increase score
				CALL AddPowerupCheck
				CALL UpdatePlayersScore
				MOV SI, 0D
CHECKLINESIIS4:
				CALL InsertLine				;insert a line at the other player
				MOV SI, AX					;reset the SI value back
CHECKLINESKIPRMV:
				INC DX
				CMP DX, FRAMEHEIGHT
				JNZ CHECKLINELOOPY

				POPA
				RET
CheckLineClear	ENDP
;---------------------------
;Procedure to End Game
;@param			none
;@return		none
EndGame		PROC 	NEAR
			;Change to Text MODE
			MOV AH,0          
			MOV AL,03h
			INT 10h 
			MOV AX, 4C00H     ;SETUP FOR EXIT
			INT 21H         ;RETURN CONTROL TO DOS
EndGame		ENDP
;---------------------------
;Procedure to wait for a key to be pressed
;@param			none
;@return 		AL(ascii-code)  AH(scancode)
Wait4Key		PROC 	NEAR
				MOV AH,00H 
				INT 16H
				RET
Wait4Key		ENDP
;---------------------------
;Procedure to get message from user at cursor position
;@param			none
;@return		none
GetMessage		PROC 	NEAR
				MOV AH,0AH 
				INT 21H
				RET
GetMessage		ENDP
;---------------------------
;Procedure to set cursor position 
;@param			DH (Y)  DL(X)
;@return		none
MoveCursor		PROC 	NEAR
				MOV AH,02H          ;Move Cursor
				XOR BH,BH
				INT 10H
				RET
MoveCursor		ENDP
;---------------------------
;Procedure to show char at cursor position  
;@param			AL(ascii-code) BL(col)
;@return		none
PrintChar		PROC 	NEAR
				MOV AH, 09H									
				XOR BH,BH ; VIDEO PAGE = 0 
				MOV CX, 1
				INT 10H
				RET
PrintChar		ENDP
;---------------------------
;Procedure to show message  
;@param			BP (offset of string) CX(size)
;				BL(color) DH (Y)  DL(X)
;@return		none
PrintMessage	PROC 	NEAR
				MOV AH, 13H ; WRITE THE STRING
				MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
				XOR BH,BH ; VIDEO PAGE = 0
				INT 10H
				RET
PrintMessage	ENDP		
;---------------------------
;Procedure to Open a binary file with image data in it
;@param			none				
;@return		none
OpenLogoFile 	PROC 	NEAR

			; Open file

			MOV AH, 3Dh
			MOV AL, 0 ; read only
			LEA DX, Logofilename
			INT 21h
			MOV [LogoFilehandle], AX
			
			RET

OpenLogoFile 	ENDP
;---------------------------
;Procedure to read data from binary file opened
;@param			none				
;@return		none
ReadLogoData	 PROC 	NEAR

			MOV AH,3Fh
			MOV BX, LogoFilehandle
			MOV CX, 1	 ; number of bytes to read
			INC PositionInLogoFile
			LEA DX, LogoData
			INT 21h
			RET
ReadLogoData	 ENDP 
;---------------------------
;Procedure to Close the opened file
;@param			none				
;@return		none
CloseLogoFile 	PROC 	NEAR
			MOV AH, 3Eh
			MOV BX, [LogoFilehandle]
			INT 21h
			RET
CloseLogoFile 	ENDP
;---------------------------
;Procedure to Draw the logo 
;@param			BX->array of pixels to draw	Make Sure in proper GFX mode			
;@return		none
DrawLogo 	PROC 	NEAR
			CALL OpenLogoFile

			LEA BX , LogoData 
			MOV CX,LogostX
			MOV DX,LogostY
			MOV AH,0ch ;Draw offset
			
drawLoop:
			;Go load from file according to PositionInLogoFile
			PUSHA ; to separate loading from drawing
			
			MOV AH,42H 				  ;SERVICE FOR SEEK.
			MOV AL,0				  ;START FROM THE BEGINNING OF FILE.
			MOV BX,LogoFilehandle	  ;FILE
			MOV CX,0				  ;THE FILE POSITION MUST BE PLACED IN
			MOV DX,PositionInLogoFile ;CX:DX, TO JUMP TO POSITION
			INT 21H
			
			CALL ReadLogoData
			
			POPA
			
			MOV AL,[BX]
			CMP AL, 0FH
			JZ SkipPixel
			INT 10h 
SkipPixel:	INC CX 
			CMP CX,LogofnX
			JNE drawLoop 
			
			MOV CX , LogostX
			INC DX
			CMP DX , LogofnY
			JNE drawLoop
			
			CALL CloseLogoFile
			
			RET
DrawLogo	ENDP			
;---------------------------
;Procedure to Draw the logo Menu
;@param			none			
;@return		none
DrawLogoMenu 	PROC	NEAR
			CALL DrawLogo
			

			MOV BP, OFFSET Logo2 ; ES: BP POINTS TO THE TEXT
			MOV CX, L2sz
			MOV DH, 18;ROW TO PLACE STRING
			MOV DL, 27 ; COLUMN TO PLACE STRING
			MOV BL, 04H ;Red
			CALL PrintMessage

			MOV BP, OFFSET Logo3 ; ES: BP POINTS TO THE TEXT
			MOV CX, L3sz
			MOV DH, 20;ROW TO PLACE STRING
			MOV DL, 27 ; COLUMN TO PLACE STRING
			MOV BL, 15 ;WHITE
			CALL PrintMessage	
			
SelectMode: CALL Wait4Key
			CMP AH,	EscCode
			JNZ Check4game
			
			MOV AH, 00H ; Set video mode
			MOV AL, 13H ; Mode 13h
			INT 10H 
			MOV AH, 4CH     ;SETUP FOR EXIT
			INT 21H         ;RETURN CONTROL TO DOS
			
Check4game:	CMP AH,F2Code		
			JNE SelectMode
			
			
			
			
			RET
DrawLogoMenu 	ENDP
;---------------------------
;Procedure to get player name
;@param		none (proper GFX mode)
;@			none
GetName		PROC 	NEAR
				;call videomode13h
				MOV AH, 00H ; Set video mode
				MOV AL, 13H ; Mode 13h
				INT 10H 
				
				MOV BP, OFFSET Menu11 ; ES: BP POINTS TO THE TEXT
				MOV CX,M11sz ;SIZE OF STRING
				MOV DH, 6 ;ROW TO PLACE STRING
				MOV DL, 10 ; COLUMN TO PLACE STRING
				MOV BL, 15 ;WHITE
				CALL PrintMessage

				MOV DH, 11 ;ROW TO PLACE CURSOR
				MOV DL, 10 ; COLUMN TO PLACE CURSOR
				CALL MoveCursor


				MOV DX,OFFSET NAME1
				CALL GetMessage


				MOV BP, OFFSET Menu12 ; ES: BP POINTS TO THE TEXT
				MOV CX, M12sz ; LENGTH OF THE STRING
				MOV DH, 14 ;ROW TO PLACE STRING
				MOV DL, 10 ; COLUMN TO PLACE STRING
				MOV BL, 15 ;WHITE				
				CALL PrintMessage

				WAIT4Enter: CALL Wait4Key			
							CMP AH,	EnterCode
							JNE WAIT4Enter
							
				;Call ClearScreen
				MOV AH, 00H ; Set video mode
				MOV AL, 13H ; Mode 13h
				INT 10H 

				MOV BP, OFFSET Menu11 ; ES: BP POINTS TO THE TEXT
				MOV CX,M11sz ;SIZE OF STRING
				MOV DH, 6 ;ROW TO PLACE STRING
				MOV DL, 10 ; COLUMN TO PLACE STRING
				MOV BL, 15 ;WHITE				
				CALL PrintMessage

				MOV DH, 11 ;ROW TO PLACE CURSOR
				MOV DL, 10 ; COLUMN TO PLACE CURSOR
				CALL MoveCursor


				MOV DX,OFFSET NAME2
				CALL GetMessage


				MOV BP, OFFSET Menu12 ; ES: BP POINTS TO THE TEXT
				MOV CX, M12sz ; LENGTH OF THE STRING
				MOV DH, 14 ;ROW TO PLACE STRING
				MOV DL, 10 ; COLUMN TO PLACE STRING
				MOV BL, 15 ;WHITE
				CALL PrintMessage
							
				WAIT4Enter2: CALL Wait4Key
							 CMP AH,	EnterCode
							 JNE WAIT4Enter2			
			RET
GetName		ENDP			
;---------------------------
;Procedure to show menu on opening the game 
;@param			none
;@return		none
DisplayMenu 	PROC     NEAR			
				
				CALL InitializeNewGame

					;Game Logo Screen
				MOV     AX, 4F02H
				MOV     BX, 0100H
				INT     10H
												
				CALL DrawLogoMenu			
				
				MOV AH, 00H ; Set video mode
				MOV AL, 13H ; Mode 13h
				INT 10H

				MOV BP, OFFSET Player1 ; ES: BP POINTS TO THE TEXT
				MOV CX, NameSz
				MOV DH, 6 ;ROW TO PLACE STRING
				MOV DL, 6 ; COLUMN TO PLACE STRING
				MOV BL, 15 ;WHITE
				CALL PrintMessage
					
				MOV BP, OFFSET Menu21 ; ES: BP POINTS TO THE TEXT
				MOV CX, M21sz ;SIZE OF STRING
				MOV DH, 6 ;ROW TO PLACE STRING
				MOV DL, 12 ; COLUMN TO PLACE STRING
				MOV BL, 15 ;WHITE
				CALL PrintMessage

				MOV BP, OFFSET Player2 ; ES: BP POINTS TO THE TEXT
				MOV CX, NameSz
				MOV DH, 10 ;ROW TO PLACE STRING
				MOV DL, 6 ; COLUMN TO PLACE STRING
				MOV BL, 15 ;WHITE
				CALL PrintMessage
					
				MOV BP, OFFSET Menu22 ; ES: BP POINTS TO THE TEXT
				MOV CX, M22sz ;SIZE OF STRING
				MOV DH, 10 ;ROW TO PLACE STRING
				MOV DL, 12 ; COLUMN TO PLACE STRING
				MOV BL, 15 ;WHITE
				CALL PrintMessage

				Wait4Ready: CALL Wait4Key
							CMP AH,	F2Code
							JE F2Pressed
							CMP AH, F10Code
							JNE WAIT4Ready
							INC AH
							MOV RPly2,AH
					MOV DH, 11 ;ROW TO PLACE STRING
					MOV DL, 6 ; COLUMN TO PLACE STRING
					CALL MoveCursor

					MOV AL, Ready; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION 
					MOV BL, 15 ;WHITE
					CALL PrintChar
					
					JMP CheckR
					
		F2Pressed:  INC AH
					MOV RPly1,AH
					MOV DH, 7 ;ROW TO PLACE STRING
					MOV DL, 6 ; COLUMN TO PLACE STRING
					CALL MoveCursor

					MOV AL, Ready; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION 
					MOV BL, 15 ;WHITE
					CALL PrintChar
					
		CheckR:     CMP AH,5H ;Dummy number to check if ready
					MOV AH, RPly1
					AND AH, RPly2
					JZ  Wait4Ready
					RET		
DisplayMenu      	ENDP
;---------------------------
;Procedure to print message that game ended
;@param			none
;@return		none
GameEnded		PROC	NEAR
				CALL Wait4Key
				CMP AH, ESCcode
				JE	ExitProg
				MOV BP, OFFSET GameEnded1 ; ES: BP POINTS TO THE TEXT
				MOV CX, GE1sz
				MOV DH, GE1Y ; ROW TO PLACE STRING
				MOV DL, GE1X ; COLUMN TO PLACE STRING
				MOV BL, 04H ;Red
				CALL PrintMessage

				
				MOV BP, OFFSET GameEnded2 ; ES: BP POINTS TO THE TEXT
				MOV CX, GE2sz
				MOV DH, GE2Y ;ROW TO PLACE STRING
				MOV DL, GE2X ; COLUMN TO PLACE STRING
				MOV BL, 04H ;Red
				CALL PrintMessage	
				
				CALL Wait4Key
				CMP AH, ESCcode	
				JNE Ret2ViewMenu
ExitProg:		CALL EndGame	
Ret2ViewMenu:	RET
GameEnded		ENDP				
;---------------------------
;Procedure to show menu on finishing the game 
;@param			none
;@return		none
EndGameMenu		PROC 	NEAR

				MOV AX, 4F02H
				MOV BX, 0100H
				INT 10H

				MOV PositionInLogoFile,0
				
				CALL DrawLogo
				
				MOV BP, OFFSET Logo4 ; ES: BP POINTS TO THE TEXT
				MOV CX, L4sz
				MOV DH, 16 ; ROW TO PLACE STRING
				MOV DL, 27 ; COLUMN TO PLACE STRING
				MOV BL, 0FH ;White
				CALL PrintMessage

				
				MOV BP, OFFSET Logo3 ; ES: BP POINTS TO THE TEXT
				MOV CX, L3sz
				MOV DH, 18 ;ROW TO PLACE STRING
				MOV DL, 27 ; COLUMN TO PLACE STRING
				MOV BL, 0FH ;WHITE
				CALL PrintMessage	
				
ControlOp:		CALL Wait4Key
				CMP AH, EnterCode
				JNE CkEsc
				RET
CkEsc:			CMP AH,EscCode
				JNE ControlOp
				CALL EndGame

				
				
EndGameMenu		ENDP
;---------------------------------------------------
;Parses score number into text to be displayed on the screen
;Params		NONE
;Returns 	NONE
ChangeScoreToText	PROC	NEAR
					PUSHA
					MOV AH, 0
					MOV AL,Player1Score
					MOV CL,10D
					DIV CL
					ADD AL,30H
					LEA SI,LeftScoreText
					MOV [SI],AL
					INC SI
					ADD AH,30H
					MOV [SI],AH

					MOV AH, 0
					MOV AL,Player2Score
					MOV CL,10D
					DIV CL
					ADD AL,30H
					LEA SI,RightScoreText
					MOV [SI],AL
					INC SI
					ADD AH,30H
					MOV [SI],AH
					
					POPA
					RET
ChangeScoreToText	ENDP
;---------------------------------------------------
;This procedure is responsible for drawing the text for the UI
;@param				none
;@return			none
DrawGUIText		PROC	NEAR
				PUSHA

				;score bars
				;top
				mov ah, 13h
				mov cx, UnderlineStringLength
				mov dh, LeftScoreLocY-2
				mov dl, 0
				lea bp, UnderlineString
				mov bx, 07h
				int 10h

				;bottom
				mov ah, 13h
				mov cx, UnderlineStringLength
				mov dh, LeftScoreLocY+1
				mov dl, 0
				lea bp, UnderlineString
				mov bx, 07h
				int 10h

				;notification bar
				mov ah, 13h
				mov cx, UnderlineStringLength
				mov dh, 46
				mov dl, 0
				lea bp, UnderlineString
				mov bx, 07h
				int 10h

				;notification text
				mov ah, 13h
				mov cx, PressEscToExitStringLength
				mov dh, 47
				mov dl, 0
				lea bp, PressEscToExitString
				mov bx, 07h
				int 10h
			

				;render the left screen next piece text
				mov ah, 13h
				mov cx, NEXTPIECETEXTLENGTH
				mov dh, LEFTNEXTPIECELOCY
				mov dl, LEFTNEXTPIECELOCX
				lea bp, NEXTPIECETEXT
				mov bx, 4d
				int 10h

				;render the right screen next piece text
				mov ah, 13h
				mov cx, NEXTPIECETEXTLENGTH
				mov dh, RIGHTNEXTPIECELOCY
				mov dl, RIGHTNEXTPIECELOCX
				lea bp, NEXTPIECETEXT
				mov bx, 4d
				int 10h
				
				;render the left screen score text
				mov ah, 13h
				mov cx, SCORETEXTLENGTH
				mov dh, LeftScoreLocY
				mov dl, LeftScoreLocX
				lea bp, SCORETEXT
				mov bx, 4d
				int 10h
				
				;render the left screen score text
				mov ah, 13h
				mov cx, NameSz
				mov dh, LeftPlyLocY
				mov dl, LeftPlyLocX
				lea bp, Player1
				mov bx, 4d
				int 10h
				
				mov ah, 13h
				mov cx, NameSz
				mov dh, RightPlyLocY
				mov dl, RightPlyLocX
				lea bp, Player2
				mov bx, 4d
				int 10h
				
				mov ah, 13h
				mov cx, SCORETEXTLENGTH
				mov dh, RightScoreLocY
				mov dl, RightScoreLocX
				lea bp, SCORETEXT
				mov bx, 4d
				int 10h

				CALL UpdatePlayersScore	;render the score itself
				
				POPA
				RET
DrawGUIText		ENDP
;---------------------------------------------------
;This procedure parses the scores of the two players and changes
;it to strings, then draws them on the screen
;@param			none
;@return		none
UpdatePlayersScore	PROC	NEAR
					PUSHA
					CALL ChangeScoreToText

					mov ah, 13h
					mov cx, LeftScoreTextLength
					mov dh, LeftScoreStringLocY
					mov dl, LeftScoreStringLocX
					lea bp, LeftScoreText
					mov bx, 4d
					int 10h

					mov ah, 13h
					mov cx, RightScoreTextLength
					mov dh, RightScoreStringLocY
					mov dl, RightScoreStringLocX
					lea bp, RightScoreText
					mov bx, 4d
					int 10h
					POPA
					RET
UpdatePlayersScore	ENDP
;---------------------------------------------------
;This procedure updates the score of the powerups for both players
;@param				none
;@return			none
UpdatePowerupsScore	PROC	NEAR
					PUSHA

					POPA
					RET
UpdatePowerupsScore ENDP
;---------------------------------------------------
;this procedure takes a 2 decimal places integer variable and parses it into a string
;@param				AL: the integer variable
;					SI: offset of string
;@return			none
ParseIntToString	PROC	NEAR
					PUSHA

					MOV AH, 0
					MOV CL,10D
					DIV CL
					ADD AL,30H
					MOV [SI],AL
					INC SI
					ADD AH,30H
					MOV [SI],AH

					POPA
					RET
ParseIntToString	ENDP
;---------------------------------------------------
;This procedure copies data of the next piece to the current piece to draw it
;@params		SI: 0 for left screen,4 for right screen
;@returns 		NONE
CopyNextPieceData	PROC	NEAR
					PUSHA
					
					CALL GetTempNextPiece
					MOV DI,tempNextPieceOffset

					CALL GetTempPiece
					MOV SI,tempPieceOffset
					
					MOV CX,20D
					
CPY:				MOV AL,[DI]
					MOV [SI],AL
					INC SI
					INC DI
					LOOP CPY
					POPA
					RET
CopyNextPieceData	ENDP
;---------------------------
;This procedure draws the piece stored in temp piece
;in it's corresponding Data,(X,Y)
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
DrawNextPiece		PROC	NEAR
					PUSHA
					MOV BX, tempNextPieceOffset
					MOV DI, BX						;Load the piece 4x4 string address in pieceData
					ADD DI,	4						;Go to the string data to put in DI
					MOV CX, 0D						;iterate over the 16 cells of the piece
					;if the piece has color !black, draw it with it's color
					;cell location is:
					;cell_x = orig_x + id%4
					;cell_y = orig_y + id/4
DRAWPIECELOPX1:			
					MOV DL, [DI]					;copy the byte of color of current cell into DL
					CMP DL, 0D						;check if color of current piece block is black
					JZ	 DRAWPIECEISBLACK1
					
					PUSH CX
					
					MOV AX, CX
					MOV CL, 4D
					DIV CL						;AH = id%4, AL = id/4
					MOV CX, 0
					MOV DX, 0
					MOV CL, 13				;load selected piece X into CL
					MOV DL, 2				;load selected piece Y into DL
					ADD CL, AH					;CX = orig_x + id%4
					ADD DL, AL					;DX = orig_y + id/4
					
					MOV AL, [DI]

					CALL DrawBlockClr
					
					POP  CX
DRAWPIECEISBLACK1:		
					INC DI
					INC CX
					CMP CX, 16D
					JNZ DRAWPIECELOPX1


					POPA
					RET
DrawNextPiece		ENDP
;---------------------------
;This procedure clears the current temp piece (used in changing direction or rotation)	;NEEDS TESTING
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
DeleteNextPiece		PROC	NEAR
					PUSHA
					MOV BX, tempNextPieceOffset
					MOV DI, BX						;Load the piece 4x4 string address in pieceData
					ADD DI,	4						;Go to the string data to put in DI
					MOV CX, 0D						;iterate over the 16 cells of the piece
					;if the piece has color !black, draw it with black
					;cell location is:
					;cell_x = orig_x + id%4
					;cell_y = orig_y + id/4
LOPX1:			
					MOV DL, [DI]					;copy the byte of color of current cell into DL
					CMP DL, 0D						;check if color of current piece block is black
					JZ 	ISBLACK1
					
					PUSH CX
					
					MOV AX, CX
					MOV CL, 4D
					DIV CL						;AH = id%4, AL = id/4
					MOV CX, 0
					MOV DX, 0
					MOV CL, 13				;load selected piece X into CL
					MOV DL, 2				;load selected piece Y into DL
					ADD CL, AH					;CX = orig_x + id%4
					ADD DL, AL					;DX = orig_y + id/4
					
					MOV AL, 0

					CALL DrawBlockClr
					
					POP  CX
ISBLACK1:		
					INC CX
					INC DI
					CMP CX, 16D
					JNZ LOPX1
					POPA
					RET
DeleteNextPiece		ENDP
;---------------------------
;This procedure checks if a player should get a powerup now, if he should, then add a random powerup to him
;@param				SI: 0 for player1, 4 for player2
;@return			none
AddPowerupCheck		PROC	NEAR
					PUSHA
					CMP SI, 0
					JNZ PowerupSIis4
					LEA DI, Player1Score	;load offset playerscore1 into bx
					JMP PowerupBreak
PowerupSIis4:
					LEA DI, Player2Score	;load offset playerscore2 into bx
PowerupBreak:
					MOV AH, 0
					MOV AL, [DI]
					MOV CL, PowerupEveryPoint			;check if score is divisible by powerupPoints
					DIV CL					;divide score by CL, check if it is divisible by it
					CMP AH, 0
					JNZ NoPowerUp
					CMP AL, 0
					JZ  NoPowerUp
					MOV BX, 5				;number of powerups
					CALL GenerateRandomNumber
					;bl now has a random number from 0 to 4 inclusive
					;MOV leftPowerupFreezeCount, BL
					ADD DI, BX
					INC DI					;moves DI to rand_number+1
					MOV BL, 1
					ADD [DI], BL			;increases the number of that powerup
					CALL UpdatePowerupsScore

					MOV AH, 2				;create beep sound
					MOV DL, 7
					INT 21H

NoPowerUp:
					POPA
					RET
AddPowerupCheck		ENDP
;---------------------------
;This procedure removes four lines from a given screen
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
RemoveFourLines		PROC	NEAR
		PUSHA
		
		MOV CX,4									;number of lines to be removed
		
		;get the last row in the grid
		MOV DX, FRAMEHEIGHT			
		DEC DX

		CALL GetTempPiece
		CALL DeletePiece

RemoveFourLinesLoop: 
		CALL ShiftLinesDown												;go to next line
		LOOP RemoveFourLinesLoop
		
		CALL DrawPiece

		POPA
		RET
RemoveFourLines		ENDP
;---------------------------
;This procedure speeds up the block speed at the opponent
;@param			SI: screenId of the calling player: 0 will affect the right screen, 4 will affect the left screen
;@return		none
SpeedUpOpponentPiece		PROC	NEAR
		PUSHA
		
		CMP SI, 4							;if it is called by the right player
		JZ SpeedUpLeftPlayer	;increase left player piece speed

	SpeedUpRightPlayer:
		MOV rightPieceSpeed, 2
		POPA
		RET	

	SpeedUpLeftPlayer:
		MOV leftPieceSpeed, 2
		POPA
		RET

SpeedUpOpponentPiece		ENDP
;---------------------------
;This procedure reset the speed of the piece  to its original speed
;@param			SI: screenId 0 for left, 4 for right
;@return		none
ResetPieceSpeed		PROC	NEAR
		PUSHA
		
		CMP SI, 4						;check which screen to reset its piece speed
		JZ ResetRightSpeed	

	ResetLeftSpeed:
		MOV CL, leftPieceSpeed
		CMP CL,1
		JZ BreakResetPieceSpeed
		MOV leftPieceSpeed, 1	;set the piece speed to  1
		JMP BreakResetPieceSpeed

	ResetRightSpeed:
		MOV CL, rightPieceSpeed
		CMP CL,1
		JZ BreakResetPieceSpeed
		MOV rightPieceSpeed, 1	;set the piece speed to  1

	BreakResetPieceSpeed:
		POPA
		RET

ResetPieceSpeed		ENDP
;---------------------------
;This procedure freeze the rotation for the opponent
;@param			SI: screenId of the calling player 0: will affect the right screen 4: will affect the left screen
;@return		none
FreezeRotation		PROC	NEAR
		PUSHA
		
		CMP SI, 4						;if it is called by right screen freeze left piece
		JZ FreezeRotationLeftPiece	

	FreezeRotationRightPiece:
		MOV rightPieceRotationLock, 1 ;set the piece speed to  1
		POPA
		RET

	FreezeRotationLeftPiece:
		MOV leftPieceRotationLock, 1	;set the piece speed to  1
		POPA
		RET

FreezeRotation		ENDP
;---------------------------
;This procedure unfreeze the rotation for specific screen 
;@param			SI: screenId 0: left 4: right
;@return		none
UnfreezeRotation		PROC	NEAR
		PUSHA
		
		CMP SI, 4						;if it is called by right screen freeze left piece
		JZ UnfreezeRightScreen	

	UnfreezeLeftScreen:
		MOV CL, leftPieceRotationLock	;get the lock variable
		CMP CL, 0															
		JZ BreakUnfreezeRotation			
		MOV leftPieceRotationLock, 0	;reset lock variable to 0 if it wasn't
		JMP BreakUnfreezeRotation

	UnfreezeRightScreen:
		MOV CL, rightPieceRotationLock	;get the lock variable
		CMP CL, 0															
		JZ BreakUnfreezeRotation			
		MOV rightPieceRotationLock, 0	;reset lock variable to 0 if it wasn't
		
	BreakUnfreezeRotation:
		POPA
		RET

UnfreezeRotation		ENDP
;---------------------------
;This procedure changes the current piece of the player
;@param				SI: 0 for left player, 4 for right player
;@return			none
ChangePiece			PROC 	NEAR
					PUSHA
					CALL GetTempPiece
					CALL DeletePiece
					CALL GenerateRandomPiece
					POPA
					RET
ChangePiece			ENDP
;---------------------------
;This procedure adds two lines at the opposite player
;@param				SI: 0 for left player, 4 for right player
;@return			none
InsertTwoLines		PROC	NEAR
					PUSHA
					CMP SI, 0				;invert SI from 0 to 4 or from 4 to 0
					JNZ	AddTwoLinesSIis4
					MOV SI, 4
					JMP AddTwoLinesBreak
AddTwoLinesSIis4:
					MOV SI, 0
AddTwoLinesBreak:
					CALL InsertLine			;insert two lines
					CALL InsertLine

					POPA
					RET
InsertTwoLines		ENDP
;---------------------------
; OpenFile 	PROC 	NEAR

;     ; Open file

; 	;JNC SUCCESS
; 	;MOV AH, 4CH
; 	;INT 21H
; ;SUCCESS:

;     MOV AH, 3Dh
;     MOV AL, 0 ; read only
;     LEA DX, LeftFrameTopFilename
;     INT 21h
;     MOV [LeftFrameTopFilehandle], AX

	; MOV AH, 3Dh
    ; MOV AL, 0 ; read only
    ; LEA DX, LeftFrameLeftFilename
    ; INT 21h
    ; MOV [LeftFrameLeftFilehandle], AX

; 	MOV AH, 3Dh
;     MOV AL, 0 ; read only
;     LEA DX, LeftFrameRightFilename
;     INT 21h
;     MOV [LeftFrameRightFilehandle], AX

; 	MOV AH, 3Dh
;     MOV AL, 0 ; read only
;     LEA DX, LeftFrameBottomFilename
;     INT 21h
;     MOV [LeftFrameBottomFilehandle], AX

; 	; MOV AH, 3Dh
;     ; MOV AL, 0 ; read only
;     ; LEA DX, rightFrameTopFilename
;     ; INT 21h
;     ; MOV [rightFrameTopFilehandle], AX

; 	; MOV AH, 3Dh
;     ; MOV AL, 0 ; read only
;     ; LEA DX, rightFrameLeftFilename
;     ; INT 21h
;     ; MOV [rightFrameLeftFilehandle], AX

; 	; MOV AH, 3Dh
;     ; MOV AL, 0 ; read only
;     ; LEA DX, rightFrameRightFilename
;     ; INT 21h
;     ; MOV [rightFrameRightFilehandle], AX

; 	; MOV AH, 3Dh
;     ; MOV AL, 0 ; read only
;     ; LEA DX, rightFrameBottomFilename
;     ; INT 21h
;     ; MOV [rightFrameBottomFilehandle], AX
   
   
;     RET
; OpenFile 	ENDP
; ;---------------------------
; ReadData 	PROC	NEAR
;     MOV AH,3Fh
;     MOV BX, [LeftFrameTopFilehandle]
;     MOV CX, leftFrameTopWidth*leftFrameTopHeight ; number of bytes to read
;     LEA DX, leftFrameTopData
;     INT 21h

    ; MOV AH,3Fh
    ; MOV BX, [LeftFrameLeftFilehandle]
    ; MOV CX, leftFrameLeftWidth*leftFrameLeftHeight ; number of bytes to read
    ; LEA DX, leftFrameLeftData
    ; INT 21h

;     MOV AH,3Fh
;     MOV BX, [LeftFrameRightFilehandle]
;     MOV CX, leftFrameRightWidth*leftFrameRightHeight ; number of bytes to read
;     LEA DX, leftFrameRightData
;     INT 21h

;     MOV AH,3Fh
;     MOV BX, [LeftFrameBottomFilehandle]
;     MOV CX, leftFrameBottomWidth*leftFrameBottomHeight ; number of bytes to read
;     LEA DX, leftFrameBottomData
;     INT 21h

; 	; MOV AH,3Fh
;     ; MOV BX, [rightFrameTopFilehandle]
;     ; MOV CX, rightFrameTopWidth*rightFrameTopHeight ; number of bytes to read
;     ; LEA DX, rightFrameTopData
;     ; INT 21h

;     ; MOV AH,3Fh
;     ; MOV BX, [rightFrameLeftFilehandle]
;     ; MOV CX, rightFrameLeftWidth*rightFrameLeftHeight ; number of bytes to read
;     ; LEA DX, rightFrameLeftData
;     ; INT 21h

;     ; MOV AH,3Fh
;     ; MOV BX, [rightFrameRightFilehandle]
;     ; MOV CX, rightFrameRightWidth*rightFrameRightHeight ; number of bytes to read
;     ; LEA DX, rightFrameRightData
;     ; INT 21h

;     ; MOV AH,3Fh
;     ; MOV BX, [rightFrameBottomFilehandle]
;     ; MOV CX, rightFrameBottomWidth*rightFrameBottomHeight ; number of bytes to read
;     ; LEA DX, rightFrameBottomData
;     ; INT 21h


;     RET
; ReadData	ENDP 
; ;---------------------------
; CloseFile 	PROC	NEAR
; 	MOV AH, 3Eh
; 	MOV BX, [leftFrameTopFilehandle]
; 	INT 21h

	; MOV AH, 3Eh
	; MOV BX, [leftFrameLeftFilehandle]
	; INT 21h

; 	MOV AH, 3Eh
; 	MOV BX, [leftFrameRightFilehandle]
; 	INT 21h

; 	MOV AH, 3Eh
; 	MOV BX, [leftFrameBottomFilehandle]
; 	INT 21h

; 	; MOV AH, 3Eh
; 	; MOV BX, [rightFrameTopFilehandle]
; 	; INT 21h

; 	; MOV AH, 3Eh
; 	; MOV BX, [rightFrameLeftFilehandle]
; 	; INT 21h

; 	; MOV AH, 3Eh
; 	; MOV BX, [rightFrameRightFilehandle]
; 	; INT 21h

; 	; MOV AH, 3Eh
; 	; MOV BX, [rightFrameBottomFilehandle]
; 	; INT 21h


; 	RET
; CloseFile 	ENDP
;---------------------------
;
;
DrawLeftBorder	PROC	NEAR

	;------------ice bottom-------------

	;open file
	MOV AH, 3Dh
	MOV AL, 0 ; read only
	LEA DX, LeftFrameBottomFilename
	INT 21h
	MOV [LeftFrameBottomFilehandle], AX

	;read file
	MOV AH,3Fh
	MOV BX, [LeftFrameBottomFilehandle]
	MOV CX, leftFrameBottomWidth*leftFrameBottomHeight ; number of bytes to read
	LEA DX, WideFrameData
	INT 21h

	;close file
	MOV AH, 3Eh
	MOV BX, [leftFrameBottomFilehandle]
	INT 21h

	;drawing ice Bottom

	LEA BX, WideFrameData ; BL contains index at the current drawn pixel
	
	MOV CX, leftFrameBottomX
	MOV DX, leftFrameBottomY
	MOV AH, 0ch

	drawIceBottom:
		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX, leftFrameBottomWidth + leftFrameBottomX
	JNE drawIceBottom 
		MOV CX , leftFrameBottomX
		INC DX
		CMP DX, leftFrameBottomHeight + leftFrameBottomY
	JNE drawIceBottom


	;------------ice top-------------

	;open file
	MOV AH, 3Dh
	MOV AL, 0 ; read only
	LEA DX, LeftFrameTopFilename
	INT 21h
	MOV [LeftFrameTopFilehandle], AX

	;read file
	MOV AH,3Fh
	MOV BX, [LeftFrameTopFilehandle]
	MOV CX, leftFrameTopWidth*leftFrameTopHeight ; number of bytes to read
	LEA DX, WideFrameData
	INT 21h

	;close file
	MOV AH, 3Eh
	MOV BX, [leftFrameTopFilehandle]
	INT 21h

	;draw ice top
	LEA BX, WideFrameData ; BL contains index at the current drawn pixel
	MOV CX, leftFrameTopX
	MOV DX, leftFrameTopY
	MOV AH, 0ch
	drawIceTop:
		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX, leftFrameTopWidth + leftFrameTopX
	JNE drawIceTop 
		
		MOV CX , leftFrameTopX
		INC DX
		CMP DX, leftFrameTopHeight + leftFrameTopY
	JNE drawIceTop

	;------------ice left-------------

	;open file
    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, LeftFrameLeftFilename
    INT 21h
     
    MOV [LeftFrameLeftFilehandle], AX

	;read file
    MOV AH,3Fh
    MOV BX, [LeftFrameLeftFilehandle]
    MOV CX, leftFrameLeftWidth*leftFrameLeftHeight ; number of bytes to read
    LEA DX, TallFrameData
    INT 21h

	;close file
	MOV AH, 3Eh
	MOV BX, [leftFrameLeftFilehandle]
	INT 21h

	;drawing ice Left
	LEA BX, TallFrameData ; BL contains index at the current drawn pixel
	MOV CX, leftFrameLeftX
	MOV DX, leftFrameLeftY
	MOV AH, 0ch
	
	drawIceLeft:
		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX, leftFrameLeftWidth + leftFrameLeftX
	JNE drawIceLeft 
		
		MOV CX , leftFrameLeftX
		INC DX
		CMP DX, leftFrameLeftHeight + leftFrameLeftY
	JNE drawIceLeft
	
	;------------ice right-------------

	;open file
	MOV AH, 3Dh
	MOV AL, 0 ; read only
	LEA DX, LeftFrameRightFilename
	INT 21h
	MOV [LeftFrameRightFilehandle], AX

	;read file
	MOV AH,3Fh
	MOV BX, [LeftFrameRightFilehandle]
	MOV CX, leftFrameRightWidth*leftFrameRightHeight ; number of bytes to read
	LEA DX, TallFrameData
	INT 21h

	;close file
	MOV AH, 3Eh
	MOV BX, [leftFrameRightFilehandle]
	INT 21h
	
	;drawing ice Right
	LEA BX, TallFrameData	 ; BL contains index at the current drawn pixel
	MOV CX, leftFrameRightX
	MOV DX, leftFrameRightY
	MOV AH, 0ch

	drawIceRight:
		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX, leftFrameRightWidth + leftFrameRightX
	JNE drawIceRight 
		
		MOV CX , leftFrameRightX
		INC DX
		CMP DX, leftFrameRightHeight + leftFrameRightY
	JNE drawIceRight

	;------------done-------------

				RET
DrawLeftBorder	ENDP
;-------------------------
DrawRightBorder	PROC	NEAR

	;------------fire top-------------

	;open file
	MOV AH, 3Dh
	MOV AL, 0 ; read only
	LEA DX, RightFrameTopFilename
	INT 21h
	MOV [RightFrameTopFilehandle], AX

	;read file
	MOV AH,3Fh
	MOV BX, [RightFrameTopFilehandle]
	MOV CX, RightFrameTopWidth*RightFrameTopHeight ; number of bytes to read
	LEA DX, WideFrameData
	INT 21h

	;close file
	MOV AH, 3Eh
	MOV BX, [RightFrameTopFilehandle]
	INT 21h

	;draw fire top
	LEA BX, WideFrameData ; BL contains index at the current drawn pixel
	MOV CX, RightFrameTopX
	MOV DX, RightFrameTopY
	MOV AH, 0ch
	drawfireTop:
		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX, RightFrameTopWidth + RightFrameTopX
	JNE drawfireTop 
		
		MOV CX , RightFrameTopX
		INC DX
		CMP DX, RightFrameTopHeight + RightFrameTopY
	JNE drawfireTop

	;CLEAR BUFFER

	;CALL ClearWideBuffer

	;------------fire bottom-------------

	;open file
	MOV AH, 3Dh
	MOV AL, 0 ; read only
	LEA DX, RightFrameBottomFilename
	INT 21h
	MOV [RightFrameBottomFilehandle], AX

	;read file
	MOV AH,3Fh
	MOV BX, [RightFrameBottomFilehandle]
	MOV CX, RightFrameBottomWidth*RightFrameBottomHeight ; number of bytes to read
	LEA DX, WideFrameData
	INT 21h

	;close file
	MOV AH, 3Eh
	MOV BX, [RightFrameBottomFilehandle]
	INT 21h

	;drawing fire Bottom

	LEA BX, WideFrameData ; BL contains index at the current drawn pixel
	
	MOV CX, RightFrameBottomX
	MOV DX, RightFrameBottomY
	MOV AH, 0ch

	drawfireBottom:
		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX, RightFrameBottomWidth + RightFrameBottomX
	JNE drawfireBottom 
		MOV CX , RightFrameBottomX
		INC DX
		CMP DX, RightFrameBottomHeight + RightFrameBottomY
	JNE drawfireBottom



	;------------fire left-------------

	;open file
    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, RightFrameLeftFilename
    INT 21h
     
    MOV [RightFrameLeftFilehandle], AX

	;read file
    MOV AH,3Fh
    MOV BX, [RightFrameLeftFilehandle]
    MOV CX, RightFrameLeftWidth*RightFrameLeftHeight ; number of bytes to read
    LEA DX, TallFrameData
    INT 21h

	;close file
	MOV AH, 3Eh
	MOV BX, [RightFrameLeftFilehandle]
	INT 21h

	;drawing fire Left
	LEA BX, TallFrameData ; BL contains index at the current drawn pixel
	MOV CX, RightFrameLeftX
	MOV DX, RightFrameLeftY
	MOV AH, 0ch
	

	drawfireLeft:
		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX, RightFrameLeftWidth + RightFrameLeftX
	JNE drawfireLeft 
		
		MOV CX , RightFrameLeftX
		INC DX
		CMP DX, RightFrameLeftHeight + RightFrameLeftY
	JNE drawfireLeft
	
	;------------fire right-------------

	;open file
	MOV AH, 3Dh
	MOV AL, 0 ; read only
	LEA DX, RightFrameRightFilename
	INT 21h
	MOV [RightFrameRightFilehandle], AX

	;read file
	MOV AH,3Fh
	MOV BX, [RightFrameRightFilehandle]
	MOV CX, RightFrameRightWidth*RightFrameRightHeight ; number of bytes to read
	LEA DX, TallFrameData
	INT 21h

	;close file
	MOV AH, 3Eh
	MOV BX, [RightFrameRightFilehandle]
	INT 21h
	
	;drawing fire Right
	LEA BX, TallFrameData	 ; BL contains index at the current drawn pixel
	MOV CX, RightFrameRightX
	MOV DX, RightFrameRightY
	MOV AH, 0ch

	drawfireRight:
		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX, RightFrameRightWidth + RightFrameRightX
	JNE drawfireRight 
		
		MOV CX , RightFrameRightX
		INC DX
		CMP DX, RightFrameRightHeight + RightFrameRightY
	JNE drawfireRight

	;------------done-------------
	
				RET
DrawRightBorder	ENDP
;-------------------------
END     MAIN