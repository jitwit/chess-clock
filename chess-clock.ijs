coclass 'chessclock'
load 'gl2'
coinsert 'jgl2'
NB. status
'SETUP RUN PAUSE OVER' =: i. 4
STATUS =: SETUP NB. start in configuration
DEFAULTS =: jpath '~temp/chess-clock.txt'

NB. defaults
loaddefaults =: 3 : 0
 if. d =. (1!:1 :: 0:) < DEFAULTS
 do.   'time step ori' =: ". d
       j =: 0
       last =: __
 else. time =: 15
       step =: 10
       j =: 0
       last =: __ end.
)

savedefaults =: 3 : 0
 d =. (":time%60),' ',(":step),' ',(":ori)
 d 1!:2 < DEFAULTS
)

NB. text of time
tofn =: ':' , _2 {. '0' , ":
toft =: [: }. [: ,/ [: tofn"0 [: <. 60 60 #: (0&>.)

bump =: 3 : 0
 wb =: wb j}~ y-~j{wb
)

dt =: 3 : 0
 if. STATUS = RUN
 do. bump (now =. 6!:1 '') - last
     last =: now
 end.
)

start =: 3 : 0
 last =: 6!:1 ''
 STATUS =: RUN
)

pause =: 3 : 0
 assert. STATUS = RUN
 now =. 6!:1 ''
 STATUS =: PAUSE
 bump now - last
)

resume =: 3 : 0
 if. STATUS = PAUSE
 do. STATUS =: RUN
     last =: 6!:1 ''
 end.
)

switch =: 3 : 0
 bump -step
 j =: -. j
)

reset =: 3 : 0
 STATUS =: SETUP
)

loop =: 3 : 0
 select. STATUS
 case. SETUP do. last =: 6!:1 ''
 case. PAUSE do. last =: 6!:1 ''
 case. RUN   do. dt ''
                 if. +./ 0 >: wb do. STATUS =: OVER end.
 case. do. end.
)
setup_form =: 0 : 0
 pc setup closeok;
 bin v;
   bin h;
     cc min edit; set min alignment center; set min text 15; set min wh 30 30;
     cc time static; set time text "+"; set time wh 10 30;
     cc sec edit; set sec alignment center; set sec text 10; set sec wh 30 30;
     cc ws static; set ws text "white:"; set ws wh 40 30;
     cc rl combolist; set rl wh 40 30; set rl items ← →;
   bin z;
   cc ok button; set ok text ok;
 bin z;
 pshow;
)

setup_close =: 3 : 0
 wd 'psel setup;pclose'
)

open_setup =: 3 : 0
 wd 'timer 0'
 loaddefaults ''
 wd setup_form
 wd 'set min text ',":time
 wd 'set sec text ',":step
 wd 'set rl select ',":ori
)

setup_ok_button =: 3 : 0
 time =: 60 * ". wd'get min text'
 step =: ". wd'get sec text'
 wb =: 2#time
 ori =: 'Right' -: wd 'get rl text'
 j =: 0
 savedefaults ''
 setup_close ''
 open_clock ''
)

setup_min_button =: setup_sec_button =: setup_ok_button

clock_form =: 0 : 0
 pc clock escclose;
 minwh 1200 600;
 bin h;
   cc face isidraw;
 bin z;
 pshow;
)

clock_close =: 3 : 0
 wd 'timer 0'
 wd 'psel clock;pclose'
)

open_clock =: 3 : 0
 wd clock_form
 wd 'timer 50'
)

half =: 600
offset =: 120 190 + (UNAME-:'Darwin') * 30 15
colorlose =: 245 10 30

NB. left's turn iff ori -: j. so left's lost iff that and status is OVER.
draw =: 3 : 0
 wd 'psel clock'
 glclear''

 glrgb (-.(STATUS=OVER)*.ori-:j) { colorlose,:(-.ori)*255 255 255
 glbrush''
 glrect half * 0 0 1 1
 glfont ('monospace 100' [`,@.(j-:ori) ' bold')
 glrgb ori*255 255 255
 gltextcolor''
 gltextxy offset
 gltext toft 0 { |.^:ori wb

 glrgb (-.(STATUS=OVER)*.ori~:j) { colorlose,:ori*255 255 255
 glbrush''
 glrect half * 1 0 1 1
 glfont ('monospace 100' [`,@.(j~:ori) ' bold')
 glrgb (-.ori)*255 255 255
 gltextcolor''
 gltextxy offset + half * 1 0
 gltext toft 1 { |.^:ori wb

 glpaint ''
)

handle_space =: 3 : 0
 select. STATUS
 case. SETUP do. start  ''
 case. RUN   do. switch ''
 case. PAUSE do. resume ''
 case. do. end.
)

handle_p =: 3 : 0
 select. STATUS
 case. RUN   do. pause ''
 case. PAUSE do. resume ''
 case. do. end.
)

handle_r =: 3 : 0
 reset ''
 clock_close ''
 open_setup ''
)

handle_q =: 3 : 0
 clock_close ''
)

clock_face_char =: 3 : 0
 select. {.sysdata
 case. ' ' do. handle_space ''
 case. 'p' do. handle_p     ''
 case. 'r' do. handle_r     ''
 case. 'q' do. handle_q     ''
 case. do. end.
)

clock_face_mblup =: handle_space
clock_face_mbmup =: handle_space
clock_face_mbrup =: handle_p

control_loop =: draw@loop
sys_timer_z_ =: control_loop_chessclock_

setup_close^:(wdisparent'setup')''
clock_close^:(wdisparent'clock')''
open_setup ''
