clear''
load 'clock.ijs gl2'
coinsert 'jgl2 clock'

setup_form =: 0 : 0
pc setup closeok;
bin v;
  bin h;
    cc time static; set time text time; set time wh 30 30;
    cc th edit; set th alignment center; set th text 0; set th wh 30 30;
    cc tm edit; set tm alignment center; set tm text 15; set tm wh 30 30;
    cc ts edit; set ts alignment center; set ts text 0; set ts wh 30 30;
  bin z;
  bin h;
    cc step static; set step text step; set step wh 30 30;
    cc sh edit; set sh alignment center; set sh text 0; set sh wh 30 30;
    cc sm edit; set sm alignment center; set sm text 0; set sm wh 30 30;
    cc ss edit; set ss alignment center; set ss text 10; set ss wh 30 30;
  bin z;
  bin h;
    cc ws static; set ws text "Who starts?"; set ws wh 100 30;
    cc rl combolist; set rl items Right Left;
  bin z;
  cc go button; set go text setup;
bin z;
pshow;
)

setup_close =: 3 : 0
wd 'psel setup;pclose'
)

setup_go_button =: 3 : 0
time =: 60 #. (".wd'get th text'),(".wd'get tm text'),(".wd'get ts text')
step =: 60 #. (".wd'get sh text'),(".wd'get sm text'),(".wd'get ss text')
wb =: 2#time
ori =: 'Right' -: wd 'get rl text'
j =: 0
setup_close''
open_clock ''
)

setup_ts_button =: setup_tm_button =: setup_th_button =: setup_go_button
setup_ss_button =: setup_sm_button =: setup_sh_button =: setup_go_button

clock_form =: 0 : 0
pc clock escclose;
minwh 1200 600;
bin h;
  cc face isidraw;
bin z;
pshow;
)

clock_close =: 3 : 0
echo 'closing down'
wd 'timer 0'
wd 'psel clock;pclose'
)

open_clock =: 3 : 0
wd clock_form
wd 'timer 100'
)

highlight =: 152 226 245
half =: 600
offset =: 155 200
NB. ori set by setup form. 0 means flipped (relative to wb times)
NB. todo: over/make look reasonable
draw_times =: 3 : 0
wd 'psel clock'
glclear''

glrgb (-.ori)*255 255 255
glbrush''
glrect half * 0 0 1 1
glfont '"lucide console" 80'
glrgb ori*255 255 255
gltextcolor''
gltextxy offset
gltext toft 0 { |.^:ori wb

glrgb ori*255 255 255
glbrush''
glrect half * 1 0 1 1
glrgb (-.ori)*255 255 255
gltextcolor''
gltextxy offset + half * 1 0
gltext toft 1 { |.^:ori wb

glpaint ''
)

clock_face_char =: 3 : 0
select. {.sysdata
case. ' ' do. if.     STATUS = SETUP do. start  ''
              elseif. STATUS = RUN   do. switch '' end.
case. 'p' do. if.     STATUS = RUN   do. pause  ''
              elseif. STATUS = PAUSE do. resume '' end.
case. 'r' do. STATUS =: SETUP
              clock_close ''
              wd setup_form
case. 'q' do. clock_close ''
case. do. end.
)

control_loop =: draw_times@loop
sys_timer_z_ =: control_loop_base_

wd 'timer 0'
setup_close^:(wdisparent'setup')''
clock_close^:(wdisparent'clock')''
wd setup_form
