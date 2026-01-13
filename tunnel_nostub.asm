;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;tunnel v2.0 - NOSTUB VERSION;;;;;;;;
;;;;;;;;;BY JORDAN CLIFFORD AKA NIKE;;;;;;;;;
;;;;;;;;;NOSTUB CONVERSION 2026;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;thx to Th. Fernique for hi score routines;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This is a nostub version that runs on stock AMS without kernels
; Compatible with TI-89, TI-89 Titanium, TI-92+, Voyage 200

        xdef    _ti89
        xdef    _ti92plus
        xdef    _v200
        xdef    _main
        xdef    _comment

; AMS ROM Call Definitions
; These are official TI-89 OS functions
ROM_CALL_000 equ $C8        ; HeapCompress
ROM_CALL_00A equ $D2        ; idle
ROM_CALL_00E equ $D6        ; OSTimerExpired, etc
ROM_CALL_120 equ $248       ; random
ROM_CALL_124 equ $250       ; DrawStrXY
ROM_CALL_177 equ $2F6       ; FontSetSys
ROM_CALL_1A6 equ $350       ; ST_busy, ST_angle, etc
ROM_CALL_1A7 equ $352       ; PortRestore, PortSet, etc
ROM_CALL_1F3 equ $3E8       ; _rom_call_addr

; Hardware addresses
LCD_MEM     equ $4C00       ; Screen buffer
KEY_PORT    equ $600018     ; Keyboard scan port
KEY_DATA    equ $60001B     ; Keyboard data port

; Display constants
SCREEN_W    equ 160         ; Screen width in pixels
SCREEN_H    equ 100         ; Screen height in pixels
BYTES_PER_ROW equ 30        ; 160 pixels / 8 bits = 20, but HW92 is 30

mask0   equ     %11111110
mask1   equ     %11111101
mask6   equ     %10111111

_main:
        pushm.l d0-d7/a0-a6
	clr.l	score
start:
        clr.w   dead

        ; Clear screen - direct implementation
        bsr     clr_scr

        ; Decompress title graphic
        lea     titlepic(pc),a0
        lea     uncompress,a1
        bsr     huffman_extract

        ; Draw title graphic to screen
        lea     LCD_MEM+2+(30*4),a0
        moveq   #40,d0
titleloop:
        moveq   #13,d1
titleloop2:
        move.b  (a1)+,(a0)+
        dbra    d1,titleloop2
        adda.l  #16,a0
        dbra    d0,titleloop

        ; Set font and draw strings
        move.w  #0,-(sp)
        jsr     call_177        ; FontSetSys #0
        addq.l  #2,sp

        bsr     DrawStr_56_30_author
        bsr     DrawStr_54_36_email

        move.w  #1,-(sp)
        jsr     call_177        ; FontSetSys #1
        addq.l  #2,sp

        bsr     DrawStr_35_48_top4

        tst.w   score
        beq     menuloop
        bsr     ArchiveScore
        clr.l   score

menuloop:
        bsr     ShowScores
        bsr     ShowDiff
        clr.l   kb_state        ; Clear keyboard state

; Wait for key press
        bsr     idle_call
        move.w  d0,d1
        cmp.w   #338,d1         ; Up arrow
        bne     nosubdiff
        tst.w   diff
        beq     nosubdiff
        sub.w   #1,diff
nosubdiff:
        cmp.w   #344,d1         ; Down arrow
        bne     noadddiff
        cmp.w   #2,diff
        beq     noadddiff
        add.w   #1,diff
noadddiff:
        cmp.w   #264,d1         ; ESC pressed?
        beq     exitmenu        ; yes.. exit
        cmp.w   #13,d1          ; ENTER pressed?
        bne     menuloop

; Play the game and restart
        bsr     playgame
        bra     start

exitmenu:
        popm.l  d0-d7/a0-a6
        rts

playgame:
        lea     difftable(pc),a5
        move.w  diff,d0
        lsl.w   #2,d0
        adda.w  d0,a5

        bsr     clr_scr2

        moveq   #65,d7
        moveq   #85,d4

        move.w  #0,-(sp)
        jsr     call_177        ; FontSetSys #0
        addq.l  #2,sp

        moveq   #5,d0
        lea     LCD_MEM+(93*30),a0
        bsr     DrawStr_0_95_comment
        bsr     DrawStr_120_95_scoretxt

main_loop:
; Delay the calc
        tst.w   keyflag
        beq     longdelay
        clr.w   keyflag
        move.w  2(a5),d5
        bra     delayloop
longdelay:
        move.w  (a5),d5
delayloop:
        nop
        dbra    d5,delayloop

; Scroll the screen down
        bsr     scrolldown

; Draw the new top to the tunnel
        bsr     drawline

; Decide whether or not to change the dir of the tunnel
        moveq   #5,d0
        bsr     random_gen
        cmpi.w  #4,d0
        blt     nochgdir
        tst.w   d6
        beq     right
left:
        clr.w   d6
        bra     noright
right:
        moveq   #1,d6
noright:
nochgdir:

; Shift the tunnel
        tst.w   d6
        bne     movrht
        tst.w   d7
        beq     right
        subq    #1,d7
        bra     nomvrt
movrht:
        cmp     #112,d7
        beq     left
        addq    #1,d7
nomvrt:

; Clear away the old player
        move.w  d4,d0
        moveq   #85,d1
        lea     blankspr(pc),a0
        lea     car+4(pc),a2
        bsr     put_sprite2_impl

; Did player collide?
        move.w  d4,d0
        subq    #1,d0
        moveq   #92,d1
        bsr     collide?
        add.w   #9,d0
        bsr     collide?
        moveq	#92-8,d1
        subq	#5,d0
        bsr	collide?

; Key handler
        bsr     GetKeyStat
        btst    #1,keystat
        bne     noplrleft
        move.w  #1,keyflag
        tst.w   d4
        beq     noplrleft
        subq    #1,d4
        bra     keypress
noplrleft:
        btst    #3,keystat
        bne     noplrright
        cmpi.w  #152,d4
        beq     keypress
        addq    #1,d4
        move.w  #1,keyflag
        bra     keypress
noplrright:
        clr.w   keyflag
keypress:
        btst    #0,keystat+6
        beq     exit

; Draw player
        lea     car(pc),a0
        move.w  d4,d0
        moveq   #85,d1
        clr.b   d3
        bsr     put_sprite_mask_impl

; Should we pause
        btst    #0,keystat+5
        bne     nopause
        bsr     idle_call
nopause:

; Is the player dead?
	tst.w   dead
        bne     youdie

; Update the score
        add.w   #1,point
        cmp.w   #40,point
        bne     main_loop
        clr.w   point
        add.w   #1,score
        move.w  score,d0
        lea     strend,a0
        moveq   #4,d1
        bsr     ConvStr
        bsr     DrawStrA_143_95_score

; Do it all over again
        bra     main_loop

; Tell the user they crashed
youdie:
        bsr     show_dialog_impl
        bsr     idle_call
        cmp.w   #13,d0
        bne     youdie
exit:
        rts

;=============================================================================
; NOSTUB IMPLEMENTATIONS OF LIBRARY FUNCTIONS
;=============================================================================

; Clear screen - fills LCD memory with zeros
clr_scr:
        pushm.l d0/a0
        lea     LCD_MEM,a0
        move.w  #(SCREEN_H*BYTES_PER_ROW)/4-1,d0
clr_scr_loop:
        clr.l   (a0)+
        dbra    d0,clr_scr_loop
        popm.l  d0/a0
        rts

; Clear screen variant 2
clr_scr2:
        bra     clr_scr

; Idle/wait for keypress - calls AMS idle and waits for key
idle_call:
        pushm.l d1-d7/a0-a6
        ; Call AMS idle function
        move.w  #$00A,d0
        trap    #4              ; ROM_CALL trap
        ; Wait for key
wait_key:
        bsr     GetKeyStat
        move.b  keystat,d0
        or.b    keystat+1,d0
        or.b    keystat+2,d0
        or.b    keystat+3,d0
        or.b    keystat+4,d0
        or.b    keystat+5,d0
        or.b    keystat+6,d0
        beq     wait_key
        ; Convert to keycode
        moveq   #0,d0
        ; TODO: implement proper keycode mapping
        popm.l  d1-d7/a0-a6
        rts

; Random number generator
; Input: d0.w = range (returns 0 to d0-1)
; Output: d0.w = random number
random_gen:
        pushm.l d1-d2/a0-a1
        move.w  d0,d2           ; Save range
        ; Simple LCG: seed = (seed * 1103515245 + 12345) & 0x7fffffff
        move.l  random_seed,d0
        move.l  #1103515245,d1
        mulu.l  d1,d0
        add.l   #12345,d0
        and.l   #$7fffffff,d0
        move.l  d0,random_seed
        ; Modulo range
        divu.w  d2,d0
        swap    d0              ; Get remainder
        ext.l   d0
        popm.l  d1-d2/a0-a1
        rts

; ROM Call wrappers
call_177:
        move.w  #$177,d0
        trap    #4
        rts

; Simple Huffman decompression stub
; For now, we'll need to decompress offline or implement full decompressor
huffman_extract:
        ; TODO: Implement Huffman decompression
        ; For now, this is a placeholder
        rts

; Sprite drawing implementation
put_sprite2_impl:
        ; d0.w = x, d1.w = y, a0 = sprite data, a2 = mask
        ; TODO: Implement sprite drawing
        rts

put_sprite_mask_impl:
        ; d0.w = x, d1.w = y, d3.b = mode, a0 = sprite
        ; TODO: Implement masked sprite drawing
        rts

show_dialog_impl:
        ; TODO: Implement simple dialog
        rts

; String drawing helpers (using AMS DrawStrXY)
DrawStr_56_30_author:
        move.w  #4,-(sp)
        pea     author(pc)
        move.w  #30,-(sp)
        move.w  #56,-(sp)
        jsr     call_124
        lea     10(sp),sp
        rts

DrawStr_54_36_email:
        move.w  #4,-(sp)
        pea     email(pc)
        move.w  #36,-(sp)
        move.w  #54,-(sp)
        jsr     call_124
        lea     10(sp),sp
        rts

DrawStr_35_48_top4:
        move.w  #4,-(sp)
        pea     top4(pc)
        move.w  #48,-(sp)
        move.w  #35,-(sp)
        jsr     call_124
        lea     10(sp),sp
        rts

DrawStr_0_95_comment:
        move.w  #4,-(sp)
        pea     _comment(pc)
        move.w  #95,-(sp)
        move.w  #0,-(sp)
        jsr     call_124
        lea     10(sp),sp
        rts

DrawStr_120_95_scoretxt:
        move.w  #4,-(sp)
        pea     scoretxt(pc)
        move.w  #95,-(sp)
        move.w  #120,-(sp)
        jsr     call_124
        lea     10(sp),sp
        rts

DrawStrA_143_95_score:
        move.w  #4,-(sp)
        pea     (a0)
        move.w  #95,-(sp)
        move.w  #143,-(sp)
        jsr     call_124
        lea     10(sp),sp
        rts

call_124:
        move.w  #$124,d0
        trap    #4
        rts

;=============================================================================
; ORIGINAL GAME FUNCTIONS (unchanged)
;=============================================================================

; Fills line with black pixels to d7, skips over 42 pixels, fills the rest
drawline:
        pushm.l d2-d7
        lea     LCD_MEM,a0
        moveq   #5,d3
clrloop:
        clr.l   (a0)+
        dbra    d3,clrloop
        eor     d5,d5
        eor     d4,d4
        ext.l   d7
        lea     LCD_MEM,a0
        move    d7,d2
        lsr.w   #3,d7
        subq    #1,d7
        tst.w   d7
        blt     mini
lineloop:
        addq    #1,d5
        move.b  #$FF,(a0)+
        dbra.b  d7,lineloop
mini:
        andi.l  #%111,d2
        addq    #1,d5
miniloop:
        moveq   #8,d6
        sub.w   d2,d6
        bset    d6,d4
        dbra    d2,miniloop
        move.b  d4,(a0)
        eor.b   #$FF,d4
        addq    #6,a0
        move.b  d4,(a0)+
        addq    #6,d5
lineloop2:
        move.b  #$FF,(a0)+
        addq    #1,d5
        cmpi    #20,d5
        blt     lineloop2
        popm.l  d2-d7
        rts

; Scrolls the screen down 1 pixel
scrolldown:
        pushm.l d0-d6/a0
        move.l  #LCD_MEM+2960-(7*30)-20,a0
        moveq   #93,d0
ScrollD:
        movem.l	(a0),d1-d6
        movem.l	d1-d6,30(a0)
        sub.l   #30,a0
        dbra    d0,ScrollD
        popm.l  d0-d6/a0
        rts

; Simple collision detection (find pixel)
collide?:
        pushm.l d0-d2/a0
        move.w  d0,-(a7)
        lea     LCD_MEM,a0
        mulu.w  #30,d1
        add.w   d1,a0
        lsr.w   #3,d0
        add.w   d0,a0
        move.w  (a7)+,d0
        and.w   #7,d0
        moveq   #7,d1
        sub     d0,d1
        btst    d1,(a0)
        beq     nocollide
        move.b  #1,dead
nocollide:
        popm.l  d0-d2/a0
        rts

; Converts a number into a string
ConvStr:
        pushm.l d0-d2
        clr.b   (a0)
RepConv:
        divu    #10,d0
        move.l  d0,d2
        swap    d2
        add.b   #48,d2
        move.b  d2,-(a0)
        subq    #1,d1
        andi.l  #$FFFF,d0
        bne     RepConv
        tst.w   d1
        beq     CS_Done
        subq    #1,d1
FillOut:
        move.b  #48,-(a0)
        dbra    d1,FillOut
CS_Done:
        popm.l  d0-d2
        rts

; Put player's score in the high score table
ArchiveScore:
        pushm.l d0-d1/a0-a2
        move.w  score,d0
        lea     hiscores(PC),a2
        move.w  diff,d1
        mulu    #72,d1
        add.w   d1,a2
        cmp.w  70(a2),d0
        ble     TooLow
        lea  16(a2),a0
        moveq  #3,d1
CheckHigher:
        cmp.w  (a0),d0
        bgt     HigherFound
        lea  18(a0),a0
        dbra  d1,CheckHigher
HigherFound:
        move.w  d1,place
        lea  72(a2),a0
        lea  54(a2),a3
        tst.w  d1
        beq     NoScrollDown
        mulu  #9,d1
        subq  #1,d1
ScrollDown:
        move.w  -(a3),-(a0)
        dbra  d1,ScrollDown
NoScrollDown:
        move.w  d0,16(a3)
        move.w  #14,d1
ResetName:
        move.b  #32,0(a3,d1)
        dbra    d1,ResetName
        bsr     ShowScores
        bsr     ShowDiff
        ; TODO: Replace with nostub string drawing
        bsr     ReadName
        ; TODO: Replace with nostub string drawing
TooLow:
        popm.l d0-d1/a0-a2
        rts

; Get the user's name
ReadName:
        ; TODO: Implement name input without DoorOS
        rts

; Show the current difficulty
ShowDiff:
        pushm.l d0-d2/a0
        move.w  diff,d2
        lsl.w   #4,d2
        lea     diffmsgs(pc),a0
        move.w  #4,-(sp)
        pea     0(a0,d2.l)
        move.w  #38,-(sp)
        move.w  #92,-(sp)
        jsr     call_124
        lea     10(sp),sp
        popm.l  d0-d2/a0
        rts

; Show the high score table
ShowScores:
        pushm.l d0-d4/a0-a3
        lea     LCD_MEM+(55*30),a0
        move.w  #(30*45)/4,d0
scoreclr:
        clr.l   (a0)+
        dbra    d0,scoreclr
        lea     rankstr(pc),a3
        lea     hiscores(PC),a2
        move.w  diff,d1
        mulu    #72,d1
        add.w   d1,a2
        moveq   #58,d4
        moveq   #3,d3
ShowNextScore:
        ; TODO: Draw strings at specific positions
        adda.l  #3,a3
        adda.l  #18,a2
        addq    #8,d4
        dbra    d3,ShowNextScore
        popm.l  d0-d4/a0-a3
        rts

; Draw a character
WriteChar:
        ; TODO: Implement character drawing
        rts

; Get the key status by directly scanning keyboard hardware
GetKeyStat:
        movem.l d0-d1/a0,-(a7)
        lea      keystat,a0
        move.w  #$FFFE,d0
        moveq    #6,d1
GetKeys:
        move.w  d0,(KEY_PORT)
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        move.b  (KEY_DATA),(a0)+
        rol.w    #1,d0
        dbra     d1,GetKeys
        movem.l (a7)+,d0-d1/a0
        rts

;=============================================================================
; DATA
;=============================================================================

youdiedlg:
        dc.w    40,30,115,50,6,6
        dc.l    youdietxt

diff    dc.w    1       ; Current difficulty (0-easy,1-medium,2-hard)

difftable:                      ; Table of delays (no key, key pressed)
        dc.w    6000,5000       ; easy
        dc.w    4000,3000       ; medium
        dc.w    2500,1500       ; hard

diffmsgs:
        dc.b    "     EASY    ",18,0,0
        dc.b    17,"   MEDIUM   ",18,0,0
        dc.b    17,"    HARD    ",32,0,0

hiscores:
        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0 ; easy
        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0

        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0 ; medium
        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0

        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0 ; hard
        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0

blankspr:
        dc.w    8,1             ; Blank sprite + mask
        dc.b    0,0,0,0,0,0,0,0

car:
        dc.w    8,1
        dc.b    %00011000       ; Your car sprite
        dc.b    %00111100
        dc.b    %00111100
        dc.b    %01111110
        dc.b    %01111110
        dc.b    %11111111
        dc.b    %11111111
        dc.b    %11111111

rankstr         dc.b    "1)",0,"2)",0,"3)",0,"4)",0
invite          dc.b    "ENTER YOUR NAME",0
youdietxt       dc.b    "CRASH!!!",0
scoretxt        dc.b    "score:",0
_comment:       dc.b    "Tunnel v2.0 (nostub) by nike",0
author          dc.b    "By Jordan Clifford",0
email           dc.b    "jc.nike@netzero.net",0
top4            dc.b    "TOP FOUR RACERS",0

        EVEN

titlepic:
        incbin  "sprite.huf"    ; Title pic (Huffman compressed)

        BSS

keystat         ds.b    8
kb_state        ds.l    1       ; Keyboard state
uncompress      ds.b    588
dead            dc.w    0       ; Set if you hit a wall
keyflag         dc.w    0       ; Set if you pressed a key this frame
place           dc.w    0
score   	dc.w    0
point		dc.w    0
random_seed     dc.l    12345   ; Random number seed
blankstr        ds.b    16
charstr         dc.b    0
strend          dc.b    0

        END
