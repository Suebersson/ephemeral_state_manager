::
:: Para chamar/executar esse script no CMD, basta apenas digitar o nome 'gitUpgrade.bat' + 'ENTER'
::
:: Ja no PowerShell, tem que digitar o comando 'cmd' primeiro e depois 'gitUpgrade.bat' + 'ENTER'
:: --> cmd
:: --> gitUpgrade.bat
::
:: Observações importantes, para não armazenar esse arquivo(gitUpgrade.bat) na pasta do projeto
:: no Git basta apenas adicionar *.bat no arquivo .gitignore
::
:: Já na arquitetura de projetos dart e flutter basta apenas criar o arquivo .pubignore, 
:: caso ele não exista, e adicionar *.bat
::
@echo off
:: ########## Caminhos de diretorios ###########
::@echo %cd%
::@echo %~dp0
::@echo %ProgramFiles%
::Pause

::set GIT_PATH=C:\Program Files (x86)\Git\bin\git.exe
::BRANCH: origin, upstream
set BRANCH=origin
set GIT_DOMAIN=https://github.com/

::get and set this project folder
for %%f in ("%cd%") do set thisFolder=%%~nxf

:: Definir o nome da conta de usuario na variavel 'GIT_USER' manualmente
::set GIT_USER=myUserName
:: set GIT_USER ::: Ler a conta de usuario logando no git usando 'git config --get' ou '--global'
::CALL cmd /K "git config --get user.name"
for /f %%f in ('git config --get user.name') do set GIT_USER=%%f

@echo.
@echo ================================ Atualizar reposiorio no Github ================================
@echo.
@echo Usuario(a): %GIT_USER%
@echo Repositorio: %GIT_DOMAIN%%GIT_USER%/%thisFolder%.git
@echo.
@echo ================================================================================================
@echo.

:::::::::::::::::::::::::::: upgrade repository ::::::::::::::::::::::::::::::
git add .
git commit -m %thisFolder%
git pull %BRANCH% main
git push -u %BRANCH% main

:::::::::::::::::::::::::::: first commit in an existing repository ::::::::::::::::::::::::::::::
@REM git init
@REM git add .
@REM git commit -m %thisFolder%
@REM git branch -M main
@REM git remote add %BRANCH% %GIT_DOMAIN%%GIT_USER%/%thisFolder%.git
@REM git push -u %BRANCH% main

@echo.
@echo.
Pause
