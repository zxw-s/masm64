@echo off
:: 需要ml64.exe，一般在VS Build Tools目录
ml64 miniGUI64.asm /link /subsystem:windows /entry:main kernel32.lib user32.lib
pause