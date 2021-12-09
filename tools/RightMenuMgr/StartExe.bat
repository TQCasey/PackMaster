@Echo off
title 360右键菜单管理
color 6F
mode con: cols=56 lines=13
reg add "HKEY_LOCAL_MACHINE\software\microsoft\Windows\CurrentVersion\App Paths\360Safe.exe" /ve /t "REG_SZ" /d "%cd%\360safe.exe" /f>nul 2>nul
"360AppLoader.exe" "/module=Utils\360MenuMgr.dll /entry=CreatePageEntry /border=5 /title=360右键菜单管理 /wndclass=Q360MenuMgrClass "
exit
