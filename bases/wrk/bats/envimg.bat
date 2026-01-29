@echo off
echo Procedimento de envio de imagens para servidor web
echo.
echo Tem certeza que deseja fazer o envio?
echo Tecle ENTER para iniciar o envio, ou feche esta janela para ABORTAR
pause > null
copy C:\clip\img_env\* \\10.40.1.37\webisis
echo.
echo Envio concluido, tecle ENTER para encerrar
pause > nul