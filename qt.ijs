clear''
load 'clock.ijs gl2'
coinsert 'jgl2 clock'

setup_form =: 0 : 0
 pc setup closeok;
 bin v;
   bin h;
     cc min edit; set min alignment center; set min text 15; set min wh 30 30;
     cc time static; set time text "+"; set time wh 10 30;
     cc sec edit; set sec alignment center; set sec text 10; set sec wh 30 30;
     cc ws static; set ws text "white:"; set ws wh 40 30;
     cc rl combolist; set rl items Right Left;
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
 wd 'timer 100'
)

half =: 600
offset =: 120 190

draw_times =: 3 : 0
 wd 'psel clock'
 glclear''

 glrgb (-.ori)*255 255 255
 glbrush''
 glrect half * 0 0 1 1
 glfont ('monospace 100' [`,@.(j-:ori) ' bold')
 glrgb ori*255 255 255
 gltextcolor''
 gltextxy offset
 gltext toft 0 { |.^:ori wb

 glrgb ori*255 255 255
 glbrush''
 glrect half * 1 0 1 1
 glfont ('monospace 100' [`,@.(j~:ori) ' bold')
 glrgb (-.ori)*255 255 255
 gltextcolor''
 gltextxy offset + half * 1 0
 gltext toft 1 { |.^:ori wb

 glpaint ''
)

draw =: 3 : 0
 select. STATUS
 case. OVER do. echo 'todo' [ draw_times ''
 case. do.      draw_times '' end.
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
sys_timer_z_ =: control_loop_base_

setup_close^:(wdisparent'setup')''
clock_close^:(wdisparent'clock')''
open_setup ''
