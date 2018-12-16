rem *Este programa serve para parar qualquer serviço do windows
rem *aqui utilizei os serviços do TOTVS Protheus como exemplo.
rem *Esse programa deve ser iniciado com direitos de administrador.
rem *Autor LaBamba

@echo off
cls
:menu
cls

echo Computador: %computername%        Usuario: %username%
                   
echo            MENU TAREFAS
echo ==================================

echo * 1. Reinicia TOTVS-PROTHEUS12     *
echo * 2. Reinicia TOTVS-PROTHEUS12-Ext *
echo * 3. Reinicia o servico do TSS     *
echo * 4. Reinicia Todos                *
echo * 5. Sair                          *
echo ==================================

set /p opcao= Escolha uma opcao:
echo ------------------------------

cls
if %opcao% equ 1 goto opcao1
if %opcao% equ 2 goto opcao2
if %opcao% equ 3 goto opcao3
if %opcao% equ 4 goto opcao4
if %opcao% equ 5 goto sair

:opcao1
taskkill /f /fi "services eq TOTVS-PROTHEUS12"
pause
net start TOTVS-PROTHEUS12
pause
goto menu

:opcao2
taskkill /f /fi "services eq TOTVS-PROTHEUS12-Ext
pause
net start TOTVS-PROTHEUS12-Ext
pause
goto menu

:opcao3
taskkill /f /fi "services eq TSS-Appserver12"
net start TSS-Appserver12
pause
goto menu

:opcao4
rem Devido aos serviços demorarem para parar e iniciar, não funciona começar na opcao1 e descer...
taskkill /f /fi "services eq licenseVirtual"
taskkill /f /fi "services eq TOTVS-PROTHEUS12"
taskkill /f /fi "services eq TOTVS-PROTHEUS12-Ext
taskkill /f /fi "services eq TSS-Appserver12"
pause

net start licenseVirtual
net start TOTVS-PROTHEUS12
net start TOTVS-PROTHEUS12-Ext
net start TSS-Appserver12
pause

:sair 