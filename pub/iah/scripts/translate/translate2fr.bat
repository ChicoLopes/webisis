@echo
pause

mx "seq=fr.txt=" "proc='d*','<1 0>{{',v1,'}}</1>','<2 0>',v2,'</2>'" -all now create=to_fr

for %%i in (*.pft) do mx "seq=%%i" gizmo=to_fr lw=0 pft=v1/ now > ..\fr\%%i

for %%i in (*.htm) do mx "seq=%%i" gizmo=to_fr lw=0 pft=v1# now > ..\fr\%%i

rem del to_fr.*

pause