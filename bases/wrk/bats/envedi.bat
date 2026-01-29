@echo off

REM set ORIGEM=C:\@qapla\clientes\Melhoramentos\bases\wrk\bases\iah\edi
REM set DESTIN=C:\xampp\htdocs\edm\bases\iah\edi

REM copy /y %ORIGEM%\edi.* %DESTIN%

REM echo open webisis.melhoramentos.com.br> ftp.ftp
REM echo user>> ftp.ftp
REM echo bin>> ftp.ftp
REM echo cd /var/www/htdocs/bases/iah/edi>> ftp.ftp
REM echo lcd linux\iah\edi>> ftp.ftp
REM echo mput edi.*>> ftp.ftp
REM echo bye>> ftp.ftp
echo open www.sinpu.com.br> ftp.ftp
echo user melhoramentos@sinpu.com.br MelhorAdmin12>> ftp.ftp
echo bin>> ftp.ftp
echo cd bases/iah/edi>> ftp.ftp
echo lcd linux\iah\edi>> ftp.ftp
echo mput edi.*>> ftp.ftp
echo bye>> ftp.ftp
ftp -i -n -v < ftp.ftp
echo.
echo Tecle ENTER para fechar esta janela
pause > nul
