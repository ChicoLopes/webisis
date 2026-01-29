@echo
pause

mx "seq=pt.txt=" "proc='d*','<1 0>{{',v1,'}}</1>','<2 0>',v2,'</2>'" -all now create=to_pt

for %%i in (*.pft) do mx "seq=%%i" gizmo=to_pt lw=0 pft=v1/ now > ..\pt\%%i

for %%i in (*.htm) do mx "seq=%%i" gizmo=to_pt lw=0 pft=v1# now > ..\pt\%%i

rem del to_pt.*

pause