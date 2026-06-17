@echo off
chcp 65001 >nul

:: 自动提升管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 正在请求管理员权限...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:menu
cls
echo ======================================================
echo       异环 (NTE) 与 Roblox 反作弊冲突一键切换工具
echo ======================================================
echo  [1] 禁用异环反作弊 (去玩 Roblox)
echo  [2] 启用异环反作弊 (去玩 异环)
echo  [3] 退出
echo ======================================================
set /p choice=请输入选项数字（1/2/3）并回车: 

if "%choice%"=="1" goto disable_driver
if "%choice%"=="2" goto enable_driver
if "%choice%"=="3" goto exit_script
goto menu

:disable_driver
echo 正在禁用异环反作弊驱动...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\HtAntiCheatDriver" /v "Start" /t REG_DWORD /d 4 /f
if %errorlevel% equ 0 (
    echo.
    echo [成功] 已成功禁用异环反作弊驱动！
    goto ask_restart
) else (
    echo [错误] 修改失败，请检查是否被安全软件拦截。
    pause
    goto menu
)

:enable_driver
echo 正在启用异环反作弊驱动...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\HtAntiCheatDriver" /v "Start" /t REG_DWORD /d 2 /f
if %errorlevel% equ 0 (
    echo.
    echo [成功] 已成功启用异环反作弊驱动！
    goto ask_restart
) else (
    echo [错误] 修改失败，请检查是否被安全软件拦截。
    pause
    goto menu
)

:ask_restart
echo ------------------------------------------------------
echo 提示：反作弊驱动的状态修改需要【重启电脑】才能完全生效！
set /p choice_restart=是否现在重启电脑？(输入 Y 重启，输入 N 返回菜单): 
if /i "%choice_restart%"=="Y" (
    echo 电脑将在 5 秒后重启，请保存好其他工作...
    shutdown /r /t 5
    exit
)
goto menu

:exit_script
exit