$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Open-Script-Services -srv 5 -sv 5 -a STOP
Open-Script-Services -srv 6 -sv 5 -a STOP
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"