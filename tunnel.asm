;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;tunnel v1.6;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;BY JORDAN CLIFFORD AKA NIKE;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;thx to Th. Fernique for hi score routines;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        include "doorsos.h"
        include "userlib.h"
        include "graphlib.h"
        include "ziplib.h"
        
        xdef    _ti89
        xdef    _main
        xdef    _comment

mask0   equ     %11111110
mask1   equ     %11111101
mask6   equ     %10111111
        
_main:
        pushm.l d0-d7/a0-a6
	clr.l	score
start:
        clr.w   dead


        jsr     graphlib::clr_scr       ;draw the title screen
        lea     titlepic(pc),a0
        lea     uncompress,a1
        jsr     ziplib::extract
        lea     $4c00+2+(30*4),a0
        moveq   #40,d0  
titleloop:
        moveq   #13,d1  
titleloop2:
        move.b  (a1)+,(a0)+
        dbra    d1,titleloop2
        adda.l  #16,a0
        dbra    d0,titleloop

        SetFont #0
        WriteStr #56,#30,#4,author
        WriteStr #54,#36,#4,email       ;draw the strings
        SetFont  #1
        WriteStr #35,#48,#4,top4

        tst.w   score
        beq     menuloop
        bsr     ArchiveScore
        clr.l   score

menuloop:
        bsr     ShowScores              
        bsr     ShowDiff
	clr.l	(doorsos::kb_vars+$1c)
;wait for a key press... and adjust difficulty
        jsr     userlib::idle_loop      
        cmp.w   #338,d0                 
        bne     nosubdiff               
        tst.w   diff                    
        beq     nosubdiff               
        sub.w   #1,diff
nosubdiff:
        cmp.w   #344,d0
        bne     noadddiff
        cmp.w   #2,diff
        beq     noadddiff
        add.w   #1,diff
noadddiff:
        cmp.w   #264,d0                 ;esc. pressed?
        beq     exitmenu                ;yes.. exit
        cmp.w   #13,d0
        bne     menuloop

;play the game.. and start again
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
        jsr     graphlib::clr_scr2
        moveq   #65,d7
        moveq   #85,d4
        SetFont #0
        moveq   #5,d0
        lea     $4c00+(93*30),a0
        WriteStr #0,#95,#4,_comment
        WriteStr #120,#95,#4,scoretxt
main_loop:

;delay the calc
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

;scroll the screen down
        bsr     scrolldown
        
;draw the new top to the tunnel
        bsr     drawline

;decide whether or not to change the dir of the tunnel
        moveq   #5,d0
        jsr     userlib::random
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
;shift the tunnel
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

;clear away the old player
        move.w  d4,d0
        moveq   #85,d1
        lea     blankspr(pc),a0
        lea     car+4(pc),a2
        jsr     graphlib::put_sprite2

;did player collide?
        move.w  d4,d0
        subq    #1,d0
        moveq   #92,d1
        bsr     collide?
        add.w   #9,d0
        bsr     collide?
        moveq	#92-8,d1
        subq	#5,d0
        bsr	collide?
;key handler
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

;draw player
        lea     car(pc),a0
        move.w  d4,d0
        moveq   #85,d1
        clr.b   d3
        jsr     graphlib::put_sprite_mask

;should we pause
        btst    #0,keystat+5
        bne     nopause
        jsr     userlib::idle_loop
nopause:

;is the player dead?
	tst.w   dead
        bne     youdie

;update the score
        add.w   #1,point
        cmp.w   #40,point
        bne     main_loop
        clr.w   point
        add.w   #1,score
        move.w  score,d0
        lea     strend,a0
        moveq   #4,d1
        bsr     ConvStr
        WriteStrA #143,#95,#4,a0

;do it all over again
        bra     main_loop

;tell the user they crashed ;)
youdie:
        lea     youdiedlg(pc),a6
        jsr     graphlib::show_dialog
        jsr     userlib::idle_loop
        cmp.w   #13,d0
        bne     youdie
exit:
        rts

;fills line with black pixels to d7, skips over 42 pixels.. fills the rest of the line
drawline:
        pushm.l d2-d7

        lea     $4c00,a0
        moveq   #5,d3
clrloop:
        clr.l   (a0)+
        dbra    d3,clrloop
        eor     d5,d5
        eor     d4,d4
        ext.l   d7
        lea     $4c00,a0
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

;scrolls the screen down 1 pixel
scrolldown:
        pushm.l d0-d6/a0
        move.l  #$4c00+2960-(7*30)-20,a0
        moveq   #93,d0
ScrollD:
        movem.l	(a0),d1-d6
        movem.l	d1-d6,30(a0)
        sub.l   #30,a0
        dbra    d0,ScrollD
        popm.l  d0-d6/a0
        rts

;simple collision detection
;(actually just a find pixel)
collide?:
        pushm.l d0-d2/a0
        move.w  d0,-(a7)
        lea     $4C00,a0
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

;converts a number into a string
;inputs: d0-number,d1-number of digits,a0-address of string+number of digits
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

;put player's score in the high score table
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
        WriteStr #35,#48,#4,invite
        bsr     ReadName
        WriteStr #35,#48,#4,top4
TooLow:
        popm.l d0-d1/a0-a2
        rts

;get the user's name
ReadName:
        pushm.l d0-d4
        moveq  #25,d3 ;x
        moveq  #4,d1
        sub.w   place,d1
        lsl     #3,d1
        add.w   #50,d1 ;y
        moveq  #19,d0
        moveq  #18,d2
        bsr     WriteChar

        clr.w   (doorsos::kb_vars+$1C)
        clr.w  d4
Input:
        jsr     userlib::idle_loop
        cmp.w  #13,d0
        beq     InputDone
        cmp.w  #257,d0
        beq     BackSpace
        cmp.w   #32,d0
        bcs     Input
        cmp.w   #256,d0
        bcc     Input
        cmp.w   #15,d4
        beq     Input
        move.b  d0,(a3)+
        move.w  d0,d2
        move.w  d3,d0
        bsr     WriteChar
        addq    #6,d3
        addq    #1,d4
        bra     Input
BackSpace:
        tst.w   d4
        beq     Input   
        clr.b   -(a3)
        subq    #6,d3
        move.w  d3,d0
        moveq   #32,d2
        bsr     WriteChar
        sub.w   #1,d4
        bra     Input
InputDone:
        tst.w   d4 
        beq     Input 

        move.w  #14,d0
        move.w  #32,d2
        bsr     WriteChar

        popm.l d0-d4
        rts

;show the current difficulty
ShowDiff:                       
        pushm.l d0-d2/a0
        move.w  diff,d2
        lsl.w   #4,d2
        lea     diffmsgs(pc),a0
        move.w  #4,-(a7)
        pea     0(a0,d2.l)
        move.w  #92,-(a7)
        move.w  #38,-(a7)
        jsr     doorsos::DrawStrXY
        lea     10(a7),a7
        popm.l  d0-d2/a0
        rts     

;show the high score table
ShowScores:
        pushm.l d0-d4/a0-a3
        lea     $4c00+(55*30),a0
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
        WriteStrA #5,d4,#4,a3
        adda.l  #3,a3
        WriteStrA #25,d4,#4,a2
        lea     strend,a0
        move.w  16(a2),d0
        moveq   #4,d1
        bsr     ConvStr
        WriteStrA #121,d4,#4,a0
        lea     18(a2),a2
        addq    #8,d4
        dbra    d3,ShowNextScore
        popm.l  d0-d4/a0-a3
        rts

;draw a character
WriteChar:
        pushm.l d0-d2/a0
        move.w  #$00FF,-(a7)
        clr.w   -(a7)   
        move.w  #$00FF,-(a7)
        move.w  #4,-(a7)
        move.w  d1,-(a7)
        move.w  d0,-(a7)
        move.w  d2,-(a7)
        bsr     DrawCharXY
        lea     14(a7),a7
        popm.l  d0-d2/a0
        rts

DrawCharXY:
        move.w  4(a7),d0
        move.b  d0,charstr
        move.w  6(a7),d0
        move.w  8(a7),d1
        move.w  10(a7),d2
        move.w  d2,-(a7)
        move.l  #charstr,-(a7)
        move.w  d1,-(a7)
        move.w  d0,-(a7)
        jsr     doorsos::DrawStrXY
        lea     10(a7),a7
        rts

;get the key status
GetKeyStat:
        movem.l d0-d1/a0,-(a7)
        lea      keystat,a0
        move.w  #$FFFE,d0
        moveq    #6,d1
GetKeys:
        move.w  d0,($600018)
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
        move.b  ($60001B),(a0)+
        rol.w    #1,d0
        dbra     d1,GetKeys
        movem.l (a7)+,d0-d1/a0
        rts


;;;;;;;;;;;;;;;;;;;DATA;;;;;;;;;;;;;;;;;;;;;;;;;;
;the "CRASH!!! dialog box
youdiedlg:
        dc.w    40,30,115,50,6,6
        dc.l    youdietxt

diff    dc.w    1       ;the current difficulty. (0-easy,1-medium,2-hard)


difftable:                      ;table of delays(no key pressed, key pressed)
        dc.w    6000,5000       ;easy
        dc.w    4000,3000       ;medium
        dc.w    2500,1500       ;hard
        
diffmsgs:                                       
        dc.b    "     EASY    ",18,0,0          
        dc.b    17,"   MEDIUM   ",18,0,0        
        dc.b    17,"    HARD    ",32,0,0
        
hiscores:
        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0 ;easy
        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0

        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0 ;medium
        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0
        
        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0 ;hard
        dc.b    "               ",0,0,0
        dc.b    "               ",0,0,0
blankspr:
        dc.w    8,1             ;blank sprite, along with a mask that is the car
        dc.b    0,0,0,0,0,0,0,0
                
car:
        dc.w    8,1
        dc.b    %00011000       ;your car..
        dc.b    %00111100       ;and the blank sprite's mask
        dc.b    %00111100       ;how convenient. ;)
        dc.b    %01111110
        dc.b    %01111110
        dc.b    %11111111
        dc.b    %11111111
        dc.b    %11111111


rankstr         dc.b    "1)",0,"2)",0,"3)",0,"4)",0
invite          dc.b    "ENTER YOUR NAME",0
youdietxt       dc.b    "CRASH!!!",0
scoretxt        dc.b    "score:",0
_comment:       dc.b    "Tunnel v1.6 by nike",0
author          dc.b    "By Jordan Clifford",0
email           dc.b    "jc.nike@netzero.net",0
top4            dc.b    "TOP FOUR RACERS",0
        
        EVEN

titlepic:

        incbin  "sprite.huf"    ;the title pic. (huffman compressed)

        BSS

keystat         ds.b    8       
uncompress      ds.b    588
dead            dc.w    0       ;set if you hit a wall
keyflag         dc.w    0       ;set if you pressed a key during this iteration
place           dc.w    0
score   	dc.w    0
point		dc.w    0
blankstr        ds.b    16
charstr         dc.b    0
strend          dc.b    0

        END
