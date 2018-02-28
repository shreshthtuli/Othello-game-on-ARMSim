@@@Lab 3 - Shreshth Tuli, Shashank Goel
	.equ SWI_Exit, 0x11 	@ Stop execution
	.global _start

.data

board:
	.space 260

board2:
	.space 260

allowed_pos:
	.space 100

allowed_pos_no:
	.word 4

str0:
	.asciz "Othello Game\n"
str1:
	.asciz "Black Score: \n"
str2:
	.asciz "White Score: \n"
str3:
	.asciz "Black Turn\n"
str4:
	.asciz "White Turn\n"
str5:
	.asciz "Enter a valid Move!\n"
str6:
	.asciz "Black Wins\n"
str7:
	.asciz "White Wins\n"
str8:
	.asciz "Oops! Its a Draw!\n"
str9:
	.asciz "COL216 : Lab 3 : Othello Game\n"

blackscore:
	.word 0, 2

whitescore:
	.word 0, 2

player:
	.word 0

pos_x:
	.word 0

pos_y:
	.word 0

isPlayer:
	.space 4

isOpponent:
	.space 4

count:
	.word 0

update_pos_args:
	.word 0, 0, 0, 0, 0, 0, 0, 0 ; k, l, a, b, c, d, a_, b_

play_args:
	.word 0, 0, 0, 0, 0, 0 		 ; k, l, a, b, c, d

.text

Othello_Board:

	ldr r0, =board      ; board intialisation
	mov r1, #'_
	mov r2, #0
	OB1:
	cmp r2, #72
	bgt OB1E
	str r1, [r0, r2]
	add r2, r2, #4
	b OB1
	OB1E:
	mov r1, #'+
	str r1, [r0, #76]
	mov r1, #'_
	str r1, [r0, #80]
	str r1, [r0, #84]
	str r1, [r0, #88]
	str r1, [r0, #92]	;
	str r1, [r0, #96]
	str r1, [r0, #100]
	mov r1, #'+
	str r1, [r0, #104]
	mov r1, #'W
	str r1, [r0, #108]
	mov r1, #'B
	str r1, [r0, #112]
	mov r1, #'_
	str r1, [r0, #116]
	str r1, [r0, #120]
	str r1, [r0, #124]	;
	str r1, [r0, #128]
	str r1, [r0, #132]
	str r1, [r0, #136]
	mov r1, #'B
	str r1, [r0, #140]
	mov r1, #'W
	str r1, [r0, #144]
	mov r1, #'+
	str r1, [r0, #148]
	mov r1, #'_
	str r1, [r0, #152]	
	str r1, [r0, #156]	;
	str r1, [r0, #160]
	str r1, [r0, #164]
	str r1, [r0, #168]
	str r1, [r0, #172]
	mov r1, #'+
	str r1, [r0, #176]
	mov r1, #'_
	mov r2, #180
	OB2:
	cmp r2, #252
	bgt OB2E
	str r1, [r0, r2]
	add r2, r2, #4
	b OB2
	OB2E:


	ldr r0, =allowed_pos
	mov r1, #2
	str r1, [r0, #0]
	mov r1, #3
	str r1, [r0, #4]
	str r1, [r0, #8]
	mov r1, #2
	str r1, [r0, #12]
	mov r1, #4
	str r1, [r0, #16]
	mov r1, #5
	str r1, [r0, #20]
	str r1, [r0, #24]
	mov r1, #4
	str r1, [r0, #28]	

	mov pc, lr

Main:
	bl Othello_Board
	bl Permanent_display
	sub sp, sp, #44
	bl Display_scene

	Main_For:

	ldr r0, =count		; count address
	ldr r0, [r0, #0]	; r0 = count
	and r1, r0, #0x01	; r1 = player
	ldr r2, =player 	; r2 = address of player
	str r1, [r2, #0]	; storing player in player address

	sub sp, sp, #44		; calling UpdateAllowPos
	bl UpdateAllowPos

	ldr r3, =allowed_pos_no
	ldr r3, [r3, #0]	; r3 = allowed_pos_no
	cmp r3, #0
	beq If1
	ldr r3, =blackscore
	ldr r4, [r3, #0]
	ldr r5, [r3, #4]
	orr r3, r4, r5
	cmp r3, #0
	beq If1
	ldr r3, =whitescore
	ldr r4, [r3, #0]
	ldr r5, [r3, #4]
	orr r3, r4, r5
	cmp r3, #0
	beq If1
	b Else1

	If1:
	ldr r3, =blackscore
	ldr r3, [r3, #0]
	ldr r4, =whitescore
	ldr r4, [r4, #0]
	cmp r3, r4
	mov r0, #4
	mov r1, #12
	ldreq r2, =str6		; win
	ldrne r2, =str7
	swi 0x204
	b Exit

	Else1:

	ldr r2, =player
	ldr r1, [r2, #0]	; r1 = player
	cmp r1, #0
	mov r0, #4
	mov r1, #12
	ldreq r2, =str3		; turn
	ldrne r2, =str4
	swi 0x204

	sub sp, sp, #44
	bl Input

	mov r9, #0			; r9 = check_valid
	ldr r4, =allowed_pos
	ldr r5, =allowed_pos_no
	ldr r5, [r5, #0]	; r5 = allowed_pos_no
	mov r3, #0			; r3 is counter
	ldr r0, =pos_x
	ldr r1, =pos_y
	ldr r0, [r0, #0]	; r0 = pos_x
	ldr r1, [r1, #0]	; r1 = pos_y

	Check_Valid_Loop:
	cmp r3, r5, LSL #3	; termination check
	bge Check_Valid_Loop_Exit
	cmp r9, #1
	beq Check_Valid_Loop_Exit
	mov r6, #1			; are coordinates equal boolean
	ldr r8, [r4, r3]
	cmp r0, r8
	movne r6, #0
	add r3, r3, #4
	ldr r8, [r4, r3]
	cmp r1, r8
	movne r6, #0
	cmp r6, #1
	moveq r9, #1
	add r3, r3, #4
	b Check_Valid_Loop

	Check_Valid_Loop_Exit:

	While_Check_Valid:
		cmp r9, #1

		beq While_Check_Valid_Exit

		mov r0, #4
		mov r1, #13
		ldr r2, =str5
		swi 0x204

		sub sp, sp, #44
		bl Input
		mov r9, #0			; r9 = check_valid
		ldr r4, =allowed_pos
		ldr r5, =allowed_pos_no
		ldr r5, [r5, #0]	; r5 = allowed_pos_no
		mov r3, #0			; r3 is counter
		ldr r0, =pos_x
		ldr r1, =pos_y
		ldr r0, [r0, #0]	; r0 = pos_x
		ldr r1, [r1, #0]	; r1 = pos_y

		Check_Valid_Loop_While:
		cmp r3, r5, LSL #3	; terminatoin check
		bge Check_Valid_Loop_While_Exit
		mov r6, #1			; are coordinates equal boolean
		ldr r8, [r4, r3]
		cmp r0, r8
		movne r6, #0
		add r3, r3, #4
		ldr r8, [r4, r3]
		cmp r1, r8
		movne r6, #0

		cmp r6, #1
		moveq r9, #1
		b Check_Valid_Loop_While

		Check_Valid_Loop_While_Exit:
		b While_Check_Valid

	While_Check_Valid_Exit:

	mov r0, #13
	swi 0x208				; clear line: Enter valid move

	sub sp, sp, #44
	bl Play

	ldr r5, =player
	ldr r6, [r5, #0]
	rsb r6, r6, #1
	str r6, [r5, #0]

	sub sp, sp, #44
	bl UpdateAllowPos

	ldr r5, =player
	ldr r6, [r5, #0]
	rsb r6, r6, #1
	str r6, [r5, #0]

	ldr r0, =allowed_pos_no
	ldr r0, [r0, #0]
	cmp r0, #0
	bne SkipM

	ldr r1, =count
	ldr r2, [r1, #0]
	sub r2, r2, #1
	str r2, [r1, #0]
	sub sp, sp, #44
	bl UpdateAllowPos

	SkipM:

	sub sp, sp, #44
	bl Display_scene

	ldr r1, =count
	ldr r2, [r1, #0]
	add r2, r2, #1
	str r2, [r1, #0]
	cmp r2, #60
	blt Main_For

	b Exit


Play:
	str lr, [sp, #0] 	; storing restore address value to stack
	BL Store

	ldr r0, =player  	; storing isPlayer and isOpponent as per player
	ldr r0, [r0, #0]	; r0 = player
	cmp r0, #1
	mov r1, #'W
	mov r2, #'B
	ldr r3, =isPlayer
	ldr r4, =isOpponent
	streq r1, [r3, #0]
	streq r2, [r4, #0]
	ldreq r3, =whitescore
	strne r1, [r4, #0]
	strne r2, [r3, #0]
	ldrne r3, =blackscore
	ldr r4, [r3, #4]	; r4 = Score ones
	cmp r4, #9
	addne r4, r4, #1	; increment score by 1
	strne r4, [r3, #4]	; store the incremented score
	ldreq r4, [r3, #0]
	addeq r4, r4, #1
	streq r4, [r3, #0]
	moveq r4, #0
	streq r4, [r3, #4]

	ldr r0, =pos_x
	ldr r0, [r0, #0]
	ldr r1, =pos_y
	ldr r1, [r1, #0]
	ldr r2, =board
	add r2, r2, r1, LSL #2  ; r2 = board + 4*pos_y
	add r2, r2, r0, LSL #5	; r2 = board + 4*pos_y + 32*pos_x
	ldr r3, =isPlayer
	ldr r3, [r3, #0]		; r3 = isPlayer
	str r3, [r2, #0]		; board[pos_x][pos_y]

	Case1P:
	mov r3, #0
	mov r4, #0
	cmp r0, #1
	movge r3, #1
	cmp r1, #1
	movge r4, #1
	and r5, r3, r4
	cmp r5, #1
	bne Case2P
	ldr r6, =play_args	     ; putting arguments in update_pos_args
	mov r7, #1
	str r7, [r6, #0]
	mov r7, #1
	str r7, [r6, #4]
	mov r7, #0
	str r7, [r6, #8]
	mov r7, #0
	str r7, [r6, #12]
	mov r7, #8
	str r7, [r6, #16]
	mov r7, #8
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Play_moves


	Case2P:
	cmp r0, #1
	blt Case3P
	ldr r6, =play_args		  ; putting arguments in update_pos_args
	mov r7, #1
	str r7, [r6, #0]
	mov r7, #0
	str r7, [r6, #4]
	mov r7, #0
	str r7, [r6, #8]
	mov r7, #-1
	str r7, [r6, #12]
	mov r7, #8
	str r7, [r6, #16]
	mov r7, #8
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Play_moves

	Case3P:
	mov r3, #0
	mov r4, #0
	cmp r0, #1
	movge r3, #1
	cmp r1, #6
	movle r4, #1
	and r5, r3, r4
	cmp r5, #1
	bne Case4P
	ldr r6, =play_args 		 ; putting arguments in update_pos_args
	mov r7, #1
	str r7, [r6, #0]
	mov r7, #-1
	str r7, [r6, #4]
	mov r7, #0
	str r7, [r6, #8]
	mov r7, #-1
	str r7, [r6, #12]
	mov r7, #8
	str r7, [r6, #16]
	mov r7, #7
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Play_moves

	Case4P:
	cmp r1, #1
	blt Case5P
	ldr r6, =play_args		  ; putting arguments in update_pos_args
	mov r7, #0
	str r7, [r6, #0]
	mov r7, #1
	str r7, [r6, #4]
	mov r7, #-1
	str r7, [r6, #8]
	mov r7, #0
	str r7, [r6, #12]
	mov r7, #8
	str r7, [r6, #16]
	mov r7, #8
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Play_moves

	Case5P:
	cmp r1, #6
	bgt Case6P
	ldr r6, =play_args		  ; putting arguments in update_pos_args
	mov r7, #0
	str r7, [r6, #0]
	mov r7, #-1
	str r7, [r6, #4]
	mov r7, #-1
	str r7, [r6, #8]
	mov r7, #-1
	str r7, [r6, #12]
	mov r7, #8
	str r7, [r6, #16]
	mov r7, #7
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Play_moves

	Case6P:
	mov r3, #0
	mov r4, #0
	cmp r0, #6
	movle r3, #1
	cmp r1, #1
	movge r4, #1
	and r5, r3, r4
	cmp r5, #1
	bne Case7P
	ldr r6, =play_args		  ; putting arguments in update_pos_args
	mov r7, #-1
	str r7, [r6, #0]
	mov r7, #1
	str r7, [r6, #4]
	mov r7, #-1
	str r7, [r6, #8]
	mov r7, #0
	str r7, [r6, #12]
	mov r7, #7
	str r7, [r6, #16]
	mov r7, #8
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Play_moves

	Case7P:
	mov r3, #0
	mov r4, #0
	cmp r0, #6
	bgt Case8P
	ldr r6, =play_args		  ; putting arguments in update_pos_args
	mov r7, #-1
	str r7, [r6, #0]
	mov r7, #0
	str r7, [r6, #4]
	mov r7, #0
	str r7, [r6, #8]
	mov r7, #-1
	str r7, [r6, #12]
	mov r7, #7
	str r7, [r6, #16]
	mov r7, #8
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Play_moves

	Case8P:
	mov r3, #0
	mov r4, #0
	cmp r0, #6
	movle r3, #1
	cmp r1, #6
	movle r4, #1
	and r5, r3, r4
	cmp r5, #1
	bne Skip_
	ldr r6, =play_args		  ; putting arguments in update_pos_args
	mov r7, #-1
	str r7, [r6, #0]
	mov r7, #-1
	str r7, [r6, #4]
	mov r7, #-1
	str r7, [r6, #8]
	mov r7, #-1
	str r7, [r6, #12]
	mov r7, #7
	str r7, [r6, #16]
	mov r7, #7
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Play_moves

	Skip_:

	BL Restore
	ldr lr, [sp, #0] ; restore lr
	add sp, sp, #44
	mov pc, lr


Play_moves:
	str lr, [sp, #0] 	; storing restore address value to stack
	BL Store

	ldr r9, =play_args
	ldr r0, =pos_x		
	ldr r0, [r0, #0]	; r0 = pos_x = i
	ldr r1, =pos_y
	ldr r1, [r1, #0]	; r1 = pos_y = j
	ldr r2, [r9, #0]	; r2 = k
	ldr r3, [r9, #4]	; r3 = l
	sub r2, r0, r2		; r2 = i - k
	sub r3, r1, r3		; r3 = j - l
	ldr r5, [r9, #8]	; r5 = a
	ldr r6, [r9, #12]	; r6 = b
	ldr r7, [r9, #16]	; r7 = c
	ldr r8, [r9, #20]	; r8 = d

	ldr r4, =board
	add r4, r4, r2, LSL #5 ; r4 = board + 32*[i-k]
	add r4, r4, r3, LSL #2 ; r4 = board + 32*[i-k] + 4*[j-l]
	ldr r4, [r4, #0]	; r4 = board[i-k][j-l]

	ldr r10, =isOpponent
	ldr r10, [r10, #0]
	cmp r4, r10
	bne SkipP

	ldr r2, [r9, #0]	; r2 = k
	ldr r3, [r9, #4]	; r3 = l
	sub r0, r0, r2		; i-=k
	sub r1, r1, r3		; j-=l

	WhileP:
	mov r4, #1			; r4 = && result carrier
	cmp r0, r5
	andle r4, r4, #0
	cmp r1, r6
	andle r4, r4, #0
	cmp r0, r7
	andge r4, r4, #0
	cmp r1, r8
	andge r4, r4, #0
	cmp r4, #1
	bne WhilePExit

	sub r0, r0, r2		; i-=k
	sub r1, r1, r3		; j-=l

	ldr r4, =board
	add r4, r4, r0, LSL #5 ; r4 = board + 32*[i]
	add r4, r4, r1, LSL #2 ; r4 = board + 32*[i] + 4*[j]
	ldr r4, [r4, #0]	; r4 = board[i][j]
	ldr r10, =isOpponent
	ldr r10, [r10, #0]
	cmp r4, r10			; board[i][j] == isOpponent
	bne WhilePExit

	b WhileP

	WhilePExit:

	mov r9, #1			; r9 = && result carrier
	cmp r0, r5
	andlt r9, r9, #0
	cmp r1, r6
	andlt r9, r9, #0
	cmp r0, r7
	andgt r9, r9, #0
	cmp r1, r8
	andgt r9, r9, #0
	ldr r4, =board
	add r4, r4, r0, LSL #5 ; r4 = board + 32*[i]
	add r4, r4, r1, LSL #2 ; r4 = board + 32*[i] + 4*[j]
	ldr r4, [r4, #0]	; r4 = board[i][j]
	ldr r10, =isPlayer
	ldr r10, [r10, #0]
	cmp r4, r10			; board[i][j] == isPlayer
	andne r9, r9, #0
	cmp r9, #1
	bne SkipP

	WhileP2:
	ldr r9, =play_args
	ldr r2, [r9, #0]	; r2 = k
	ldr r3, [r9, #4]	; r3 = l
	; r0 = i, r1 = j, r2 = k, r3 = l, r4 = pos_x, r5 = pos_y
	ldr r4, =pos_x
	ldr r4, [r4, #0]
	ldr r5, =pos_y
	ldr r5, [r5, #0]
	mov r6, #0
	mov r7, #0
	sub r8, r4, r2		; r8 = pos_x - k
	cmp r0, r8			; i != pos_x - k
	movne r6, #1
	cmp r0, r4			; i == pos_x
	moveq r6, #1
	sub r9, r5, r3		; r9 = pos_y - l
	cmp r1, r9			; j != pos_y - l
	movne r7, #1
	cmp r1, r5			; j == pos_y
	moveq r7, #1
	and r6, r6, r7		; r6 = condition true
	cmp r6, #1
	bne SkipP

	add r0, r0, r2		; i+=k
	add r1, r1, r3		; j+=l	
	ldr r4, =board
	add r4, r4, r0, LSL #5 ; r4 = board + 32*[i]
	add r4, r4, r1, LSL #2 ; r4 = board + 32*[i] + 4*[j]
	ldr r10, =isPlayer
	ldr r10, [r10, #0]
	str r10, [r4, #0]	; board[i][j] <= isPlayer

	ldr r4, =player
	ldr r4, [r4, #0]
	ldr r5, =blackscore	
	ldr r6, =whitescore
	cmp r4, #1
	bne BpWm
	ldr r7, [r5, #4]	; r7 = blackscore ones
	cmp r7, #0			; r7 == 0
	moveq r7, #9
	streq r7, [r5, #4]
	ldreq r7, [r5, #0]
	subeq r7, r7, #1
	streq r7, [r5, #0]
	subne r7, r7, #1
	strne r7, [r5, #4] 
	ldr r7, [r6, #4]	; r7 = whitescore ones
	cmp r7, #9			; r7 == 0
	moveq r7, #0
	streq r7, [r6, #4]
	ldreq r7, [r6, #0]
	addeq r7, r7, #1
	streq r7, [r6, #0]
	addne r7, r7, #1
	strne r7, [r6, #4] 
	b WhileP2
	BpWm:
	ldr r7, [r6, #4]	; r7 = whitescore ones
	cmp r7, #0			; r7 == 0
	moveq r7, #9
	streq r7, [r6, #4]
	ldreq r7, [r6, #0]
	subeq r7, r7, #1
	streq r7, [r6, #0]
	subne r7, r7, #1
	strne r7, [r6, #4] 
	ldr r7, [r5, #4]	; r7 = blackscore ones
	cmp r7, #9			; r7 == 0
	moveq r7, #0
	streq r7, [r5, #4]
	ldreq r7, [r5, #0]
	addeq r7, r7, #1
	streq r7, [r5, #0]
	addne r7, r7, #1
	strne r7, [r5, #4] 
	b WhileP2

	SkipP:

	BL Restore
	ldr lr, [sp, #0] ; restore lr
	add sp, sp, #44
	mov pc, lr


Input:
	str lr, [sp, #0] 	; storing restore address value to stack
	BL Store

	mov r5, #0			; zero
	mov r3, #0			; storing value
	ldr r1, =pos_y
	ldr r2, =pos_x
	BB1:
	swi 0x203 			; check blue buttons and store in r0
	cmp r0, #0
	beq BB1				; continue checking till a button is pressed
	BL1:	
	cmp r0, #0x01
	addne r3, r3, #1
	add r0, r5, r0, LSR #1
	bne BL1
	mov r5, #0
	str r3, [r2, #0]	; store x in pos_x
	mov r3, #0
	b BR1 				; wait for button release

	BR1:
	swi 0x203
	cmp r0, #0
	beq BB2				; if button released, check for next button
	bne BR1				; if not released continue checking till released

	BB2:
	swi 0x203 			; check blue buttons and store in r0
	cmp r0, #0
	beq BB2				; continue checking till a button is pressed
	BL2:
	cmp r0, #0x01
	addne r3, r3, #1
	add r0, r5, r0, LSR #1
	bne BL2
	str r3, [r1, #0]	; store y in pos_y
	b BR2 				; wait for button release

	BR2:
	swi 0x203
	cmp r0, #0
	bne BR2				; if not released continue checking till released

	BL Restore
	ldr lr, [sp, #0] ; restore lr
	add sp, sp, #44
	mov pc, lr


UpdateAllowPos:
	str lr, [sp, #0] 	; storing restore address value to stack
	BL Store

	ldr r0, =board 		; loop for resetting allowed_pos on board
	mov r2, r0
	add r2, r2, #252
	L:
	ldr r1, [r0, #0]
	cmp r1, #'+
	moveq r1, #'_
	streq r1, [r0, #0]
	add r0, r0, #4
	cmp r0, r2
	ble L

	ldr r0, =allowed_pos_no ; allowed_pos = new int list
	mov r1, #0
	str r1, [r0, #0]

	ldr r0, =player  	; storing isPlayer and isOpponent as per player
	ldr r0, [r0, #0]	; r0 = player
	cmp r0, #1
	mov r1, #'W
	mov r2, #'B
	ldr r3, =isPlayer
	ldr r4, =isOpponent
	streq r1, [r3, #0]
	streq r2, [r4, #0]
	strne r1, [r4, #0]
	strne r2, [r3, #0]

	mov r0, #0			; r0 = a
	mov r1, #0			; r1 = b
	For_a:
	mov r1, #0
	For_b:
	ldr r2, =board
	add r2, r2, r1, LSL #2  ; r2 = board + 4*b
	add r2, r2, r0, LSL #5	; r2 = board + 4*b + 32*a
	ldr r3, [r2, #0]	; r3 = board[a][b]
	ldr r4, =isOpponent
	ldr r4, [r4, #0]	; r4 = isOpponent

	cmp r4, r3			; board[a][b] == isOpponent
	bne Skip

	ldr r6, =update_pos_args  ; putting arguments in update_pos_args
	str r0, [r6, #24]
	str r1, [r6, #28]

	Case1:
	mov r3, #0
	mov r4, #0
	mov r5, #0
	cmp r0, #1
	movge r3, #1
	cmp r1, #1
	movge r4, #1
	and r5, r3, r4
	cmp r5, #1
	bne Case2
	ldr r6, =update_pos_args  ; putting arguments in update_pos_args
	mov r7, #1
	str r7, [r6, #0]
	mov r7, #1
	str r7, [r6, #4]
	mov r7, #-1
	str r7, [r6, #8]
	mov r7, #-1
	str r7, [r6, #12]
	mov r7, #7
	str r7, [r6, #16]
	mov r7, #7
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Update_pos


	Case2:
	cmp r0, #1
	blt Case3
	ldr r6, =update_pos_args  ; putting arguments in update_pos_args
	mov r7, #1
	str r7, [r6, #0]
	mov r7, #0
	str r7, [r6, #4]
	mov r7, #-1
	str r7, [r6, #8]
	mov r7, #-1
	str r7, [r6, #12]
	mov r7, #7
	str r7, [r6, #16]
	mov r7, #8
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Update_pos

	Case3:
	mov r3, #0
	mov r4, #0
	mov r5, #0
	cmp r0, #1
	movge r3, #1
	cmp r1, #6
	movle r4, #1
	and r5, r3, r4
	cmp r5, #1
	bne Case4
	ldr r6, =update_pos_args  ; putting arguments in update_pos_args
	mov r7, #1
	str r7, [r6, #0]
	mov r7, #-1
	str r7, [r6, #4]
	mov r7, #-1
	str r7, [r6, #8]
	mov r7, #0
	str r7, [r6, #12]
	mov r7, #7
	str r7, [r6, #16]
	mov r7, #8
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Update_pos

	Case4:
	cmp r1, #1
	blt Case5
	ldr r6, =update_pos_args  ; putting arguments in update_pos_args
	mov r7, #0
	str r7, [r6, #0]
	mov r7, #1
	str r7, [r6, #4]
	mov r7, #-1
	str r7, [r6, #8]
	mov r7, #-1
	str r7, [r6, #12]
	mov r7, #8
	str r7, [r6, #16]
	mov r7, #7
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Update_pos

	Case5:
	cmp r1, #6
	bgt Case6
	ldr r6, =update_pos_args  ; putting arguments in update_pos_args
	mov r7, #0
	str r7, [r6, #0]
	mov r7, #-1
	str r7, [r6, #4]
	mov r7, #-1
	str r7, [r6, #8]
	mov r7, #0
	str r7, [r6, #12]
	mov r7, #8
	str r7, [r6, #16]
	mov r7, #8
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Update_pos

	Case6:
	mov r3, #0
	mov r4, #0
	mov r5, #0
	cmp r0, #6
	movle r3, #1
	cmp r1, #1
	movge r4, #1
	and r5, r3, r4
	cmp r5, #1
	bne Case7
	ldr r6, =update_pos_args  ; putting arguments in update_pos_args
	mov r7, #-1
	str r7, [r6, #0]
	mov r7, #1
	str r7, [r6, #4]
	mov r7, #0
	str r7, [r6, #8]
	mov r7, #-1
	str r7, [r6, #12]
	mov r7, #8
	str r7, [r6, #16]
	mov r7, #7
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Update_pos

	Case7:
	cmp r0, #6
	bgt Case8
	ldr r6, =update_pos_args  ; putting arguments in update_pos_args
	mov r7, #-1
	str r7, [r6, #0]
	mov r7, #0
	str r7, [r6, #4]
	mov r7, #0
	str r7, [r6, #8]
	mov r7, #-1
	str r7, [r6, #12]
	mov r7, #8
	str r7, [r6, #16]
	mov r7, #8
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Update_pos

	Case8:
	mov r3, #0
	mov r4, #0
	mov r5, #0
	cmp r0, #6
	movle r3, #1
	cmp r1, #6
	movle r4, #1
	and r5, r3, r4
	cmp r5, #1
	bne Skip
	ldr r6, =update_pos_args  ; putting arguments in update_pos_args
	mov r7, #-1
	str r7, [r6, #0]
	mov r7, #-1
	str r7, [r6, #4]
	mov r7, #0
	str r7, [r6, #8]
	mov r7, #0
	str r7, [r6, #12]
	mov r7, #8
	str r7, [r6, #16]
	mov r7, #8
	str r7, [r6, #20]
	sub sp, sp, #44
	bl Update_pos

	Skip:

	add r1, r1, #1
	cmp r1, #8
	blt For_b

	add r0, r0, #1
	cmp r0, #8
	blt For_a

	BL Restore
	ldr lr, [sp, #0] ; restore lr
	add sp, sp, #44
	mov pc, lr


Update_pos:
	str lr, [sp, #0] 	; storing restore address value to stack
	BL Store

	ldr r9, =update_pos_args
	ldr r0, [r9, #24]	; r0 = i = a_
	ldr r1, [r9, #28]	; r1 = j = b_
	ldr r2, [r9, #0]	; r2 = k
	ldr r3, [r9, #4]	; r3 = l
	sub r2, r0, r2		; r2 = i - k
	sub r3, r1, r3		; r3 = j - l
	ldr r5, [r9, #8]	; r5 = a
	ldr r6, [r9, #12]	; r6 = b
	ldr r7, [r9, #16]	; r7 = c
	ldr r8, [r9, #20]	; r8 = d

	ldr r4, =board
	add r4, r4, r2, LSL #5 ; r4 = board + 32*[i-k]
	add r4, r4, r3, LSL #2 ; r4 = board + 32*[i-k] + 4*[j-l]
	ldr r4, [r4, #0]	; r4 = board[i-k][j-l]

	cmp r4, #'_
	bne SkipU

	ldr r2, [r9, #0]	; r2 = k
	ldr r3, [r9, #4]	; r3 = l
	add r0, r0, r2		; i+=k
	add r1, r1, r3		; j+=l

	WhileU:
	mov r4, #1			; r4 = && result carrier
	cmp r0, r5
	andle r4, r4, #0
	cmp r1, r6
	andle r4, r4, #0
	cmp r0, r7
	andge r4, r4, #0
	cmp r1, r8
	andge r4, r4, #0
	cmp r4, #1
	bne WhileUExit

	ldr r4, =board
	add r4, r4, r0, LSL #5 ; r4 = board + 32*[i]
	add r4, r4, r1, LSL #2 ; r4 = board + 32*[i] + 4*[j]
	ldr r4, [r4, #0]	; r4 = board[i][j]
	ldr r10, =isOpponent
	ldr r10, [r10, #0]
	cmp r4, r10			; board[i][j] == isOpponent
	bne WhileUExit

	ldr r2, [r9, #0]	; r2 = k
	ldr r3, [r9, #4]	; r3 = l
	add r0, r0, r2		; i+=k
	add r1, r1, r3		; j+=l
	b WhileU

	WhileUExit:

	mov r9, #1			; r9 = && result carrier
	cmp r0, r5
	andlt r9, r9, #0
	cmp r1, r6
	andlt r9, r9, #0
	cmp r0, r7
	andgt r9, r9, #0
	cmp r1, r8
	andgt r9, r9, #0
	ldr r4, =board
	add r4, r4, r0, LSL #5 ; r4 = board + 32*[i]
	add r4, r4, r1, LSL #2 ; r4 = board + 32*[i] + 4*[j]
	ldr r4, [r4, #0]	; r4 = board[i][j]
	ldr r10, =isPlayer
	ldr r10, [r10, #0]
	cmp r4, r10			; board[i][j] == isPlayer
	andne r9, r9, #0
	cmp r9, #1
	bne SkipU

	ldr r9, =update_pos_args
	ldr r0, [r9, #24]	; r0 = i = a_
	ldr r1, [r9, #28]	; r1 = j = b_
	ldr r2, [r9, #0]	; r2 = k
	ldr r3, [r9, #4]	; r3 = l
	sub r2, r0, r2		; r2 = a_ - k
	sub r3, r1, r3		; r3 = b_ - l
	ldr r4, =allowed_pos_no		; r4 = allowed_pos address
	ldr r5, [r4, #0]	; r5 = allowed_pos_no
	ldr r6, =allowed_pos ; r6 = allowed_pos address
	str r2, [r6, r5, LSL #3]
	add r6, r6, #4
	str r3, [r6, r5, LSL #3]
	add r5, r5, #1
	str r5, [r4, #0]	; update allowed_pos_no

	ldr r4, =board
	add r4, r4, r2, LSL #5 ; r4 = board + 32*[a_ - k]
	add r4, r4, r3, LSL #2 ; r4 = board + 32*[a_ - k] + 4*[b_ - l]
	mov r5, #'+
	str r5, [r4, #0]

	SkipU:

	BL Restore
	ldr lr, [sp, #0] ; restore lr
	add sp, sp, #44
	mov pc, lr




Display_scene:
	str lr, [sp, #0] 	; storing restore address value to stack
	BL Store

	mov r0, #6			; x
	mov r1, #4   		; y
	ldr r3, =board      ; address of board
	ldr r4, =board2
	OL:
	IL:
	ldr r2, [r3, #0]	; board1 value
	ldr r5, [r4, #0]	; board2 value
	cmp r2, r5			; compare values
	beq SKIP_DP
	swi 0x207			; print string
	str r2, [r4, #0]
	SKIP_DP:
	add r0, r0, #2
	add r3, r3, #4
	add r4, r4, #4
	cmp r0, #20
	ble IL
	mov r0, #6
	add r1, r1, #1
	cmp r1, #11
	ble OL

	mov r1, #5
	mov r0, #36
	ldr r3, =blackscore
	ldr r2, [r3, #0]
	swi 0x205
	mov r0, #37
	ldr r2, [r3, #4]
	swi 0x205

	mov r1, #7
	mov r0, #36
	ldr r3, =whitescore
	ldr r2, [r3, #0]
	swi 0x205
	mov r0, #37
	ldr r2, [r3, #4]
	swi 0x205

	BL Restore
	ldr lr, [sp, #0] ; restore lr
	add sp, sp, #44
	mov pc, lr

Permanent_display:

	mov r0, #4
	mov r1, #3
	mov r2, #'$
	swi 0x207
	add r0, r0, #2
	mov r2, #'1
	swi 0x207
	add r0, r0, #2
	mov r2, #'2
	swi 0x207
	add r0, r0, #2
	mov r2, #'3
	swi 0x207
	add r0, r0, #2
	mov r2, #'4
	swi 0x207
	add r0, r0, #2
	mov r2, #'5
	swi 0x207
	add r0, r0, #2
	mov r2, #'6
	swi 0x207
	add r0, r0, #2
	mov r2, #'7
	swi 0x207
	add r0, r0, #2
	mov r2, #'8
	swi 0x207

	mov r0, #4
	add r1, r1, #1
	mov r2, #'1
	swi 0x207
	add r1, r1, #1
	mov r2, #'2
	swi 0x207
	add r1, r1, #1
	mov r2, #'3
	swi 0x207
	add r1, r1, #1
	mov r2, #'4
	swi 0x207
	add r1, r1, #1
	mov r2, #'5
	swi 0x207
	add r1, r1, #1
	mov r2, #'6
	swi 0x207
	add r1, r1, #1
	mov r2, #'7
	swi 0x207
	add r1, r1, #1
	mov r2, #'8
	swi 0x207
	
	mov r0, #24
	mov r1, #5
	ldr r2, =str1
	swi 0x204

	mov r0, #24
	mov r1, #7
	ldr r2, =str2
	swi 0x204
	mov r0, #4
	mov r1, #1
	ldr r2, =str9
	swi 0x204

	mov pc, lr


Store:
	str r0, [sp, #16]
	str r1, [sp, #20]
	str r2, [sp, #24]
	str r3, [sp, #28]
	str r4, [sp, #32]
	str r5, [sp, #36]
	str r6, [sp, #40]
	mov pc, lr

Restore:
	ldr r0, [sp, #16]
	ldr r1, [sp, #20]
	ldr r2, [sp, #24]
	ldr r3, [sp, #28]
	ldr r4, [sp, #32]
	ldr r5, [sp, #36]
	ldr r6, [sp, #40]

	mov pc, lr

Exit:
	swi SWI_Exit