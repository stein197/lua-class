@echo off
where /q lua
if errorlevel 1 (
	echo Lua interpreter is not installed
	exit /b
)
cls & lua test\class.lua
