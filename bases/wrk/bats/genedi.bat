@echo off
if exist edi.xrf del edi.xrf
if exist edi.mst del edi.mst
cisis\1660\mxcp ..\edi\edi create=work clean log=edi.clean
cisis\1660\mx work append=edi -all now tell=1000 "proc=('Ggizmos\gansmi,120')"
if exist work.xrf del work.*
cisis\1660\mx edi "fst=@fsts\edi.fst" actab=tabs\ac850.tab uctab=tabs\uc850.tab fullinv=edi tell=5000
if not exist bases         mkdir bases
if not exist bases\iah     mkdir bases\iah
if not exist bases\iah\fst mkdir bases\iah\fst
if not exist bases\iah\edi mkdir bases\iah\edi
if not exist linux         mkdir linux
if not exist linux\iah     mkdir linux\iah
if not exist linux\iah\fst mkdir linux\iah\fst
if not exist linux\iah\edi mkdir linux\iah\edi
cisis\1660\crunchmf edi linux\iah\edi\edi 
cisis\1660\crunchif edi linux\iah\edi\edi 
move edi.xrf bases\iah\edi > nul
move edi.mst bases\iah\edi > nul
move edi.cnt bases\iah\edi > nul
move edi.ifp bases\iah\edi > nul
move edi.l0? bases\iah\edi > nul
move edi.n0? bases\iah\edi > nul
copy fsts\edi.fst bases\iah\fst > nul
copy fsts\edi.fst linux\iah\fst > nul
echo Tecle ENTER para fechar esta janela
pause > nul
