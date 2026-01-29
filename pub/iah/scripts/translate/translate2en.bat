@echo
pause

mx "seq=en.txt=" "proc='d*','<1 0>{{',v1,'}}</1>','<2 0>',v2,'</2>'" -all now create=to_en

for %%i in (*.pft) do mx "seq=%%i" gizmo=to_en lw=0 pft=v1/ now > ..\en\%%i

for %%i in (*.htm) do mx "seq=%%i" gizmo=to_en lw=0 pft=v1# now > ..\en\%%i

rem del to_en.*

pause