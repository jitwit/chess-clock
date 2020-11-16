NB. base off? https://www.google.com/search?q=kasparov+deep+blue&tbm=isch&ved=2ahUKEwjEyauv8IftAhUjVd8KHVvJCx8Q2-cCegQIABAA&oq=kasparov+deep+blue&gs_lcp=CgNpbWcQAzICCAAyAggAMgYIABAFEB4yBggAEAUQHjIGCAAQCBAeMgYIABAIEB4yBggAEAgQHjIGCAAQCBAeMgYIABAIEB4yBggAEAgQHjoECAAQQ1C8BVioFGDwFWgAcAB4AIABZIgB2ASSAQM0LjaYAQCgAQGqAQtnd3Mtd2l6LWltZ8ABAQ&sclient=img&ei=mt2yX8SUL6Oq_Qbbkq_4AQ#imgrc=ntcT1cfyeToyyM

NB. status
coclass 'clock'
'SETUP RUN PAUSE OVER' =: i. 4
STATUS =: SETUP NB. start in configuration

NB. time in seconds
time =: 15*60
step =: 10
last =: __
wb =: 2#time
j =: 0

NB. text of time
tofn =: ':' , _2 {. '0' , ":
toft =: [: }. [: ,/ [: tofn"0 [: <. (60 60&#:)

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

loop =: 3 : 0
 select. STATUS
 case. SETUP do. last =: 6!:1 ''
 case. PAUSE do. last =: 6!:1 ''
 case. RUN do. dt''
               if. +./ 0 >: wb do. STATUS =: OVER end.
 case. do. end.
)
