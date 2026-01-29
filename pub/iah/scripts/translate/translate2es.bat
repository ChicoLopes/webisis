@echo
pause

mx "seq=es.txt=" "proc='d*','<1 0>{{',v1,'}}</1>','<2 0>',v2,'</2>'" -all now create=to_es

for %%i in (*.pft) do mx "seq=%%i" gizmo=to_es lw=0 pft=v1/ now > ..\es\%%i

for %%i in (*.htm) do mx "seq=%%i" gizmo=to_es lw=0 pft=v1# now > ..\es\%%i

rem del to_es.*

pause