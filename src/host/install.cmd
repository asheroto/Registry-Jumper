@echo off
pushd %~dp0
@powershell.exe -ExecutionPolicy Bypass -NoProfile -File ".\install.ps1"