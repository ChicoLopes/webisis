@echo off

REM Via file-system
REM set ORIGEM=C:\@qapla\clientes\Melhoramentos\bases\wrk\bases\iah\edi
REM set DESTIN=C:\xampp\htdocs\edm\bases\iah\edi
REM copy /y %ORIGEM%\edi.* %DESTIN%

echo open webisis.melhoramentos.com.br> ftp.ftp
echo user isis isis>> ftp.ftp
echo bin>> ftp.ftp
echo cd www/bases/iah/edi>> ftp.ftp
echo lcd linux\iah\edi>> ftp.ftp
echo mput edi.*>> ftp.ftp
echo bye>> ftp.ftp
echo.
echo Se iniciara agora a transferencia de dados para o servidor
echo Esta operacao demanda alguns minutos, por favor aguarde
ftp -i -n -v < ftp.ftp
echo.
pause