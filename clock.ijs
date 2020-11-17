NB. status
coclass 'clock'
'SETUP RUN PAUSE OVER' =: i. 4
STATUS =: SETUP NB. start in configuration
DEFAULTS =: jpath '~temp/chess-clock.txt'

NB. defaults
loaddefaults =: 3 : 0
 d =. (1!:1 :: 0:) < DEFAULTS
 if. d
 do.   'time step ori' =: ". d
       j =: 0
       last =: __
 else. time =: 15*60
       step =: 10
       last =: __
       wb =: 2#time
       j =: 0 end.
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
 if. STATUS = RUN do. bump (now =. 6!:1 '') - last
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
 bump (now - last)
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
 case. RUN do. dt''
               if. +./ 0 >: wb do. STATUS =: OVER end.
 case. do. end.
)
