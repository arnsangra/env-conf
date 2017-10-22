rm -Force "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\System Tools\Command Prompt.lnk"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\System Tools\Command Prompt.lnk")
$Shortcut.TargetPath = "%windir%\system32\cmd.exe"
$Shortcut.WorkingDirectory = "%HOMEDRIVE%%HOMEPATH%"
$Shortcut.Description = "Realiza funciones basadas en texto (línea de comandos)."
$Shortcut.Save()