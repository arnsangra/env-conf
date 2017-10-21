# Environment configuration

This is my personal environment configuration! Feel free to fork it and make yours.

# Windows 10 Fall Creators Update

# Prerequisites
* Docker for Windows (https://docs.docker.com/docker-for-windows/install/)
* Ubuntu for Windows Subsystem Linux (https://msdn.microsoft.com/es-es/commandline/wsl/install_guide)

# Notes:
* Configure Docker for Windows to expose daemon on localhost
    * Docker -> Settings -> General -> Check "Expose daemon on tcp://localhost:2375 without TLS"
* Share all your Windows drives with Docker
    * Docker -> Settings -> Shared Drives -> Check all your Disks -> Apply

# Configure

## On Ubuntu console run

**All the path variables have to point to a Windows path folder.** (/mnt/[drive]/this/is/a/path)

### Variables
${PROJECTS} -> Path to my projects folder  
${TMP} -> Path to my temporary folder  
${THEME} -> Theme selected (console_${THEME}.reg)

```
wget -qO- https://raw.githubusercontent.com/zer0beat/env-conf/master/configure.sh | PROJECTS={/path/to/projects/dir} TMP={/path/to/tmp/dir} bash
```