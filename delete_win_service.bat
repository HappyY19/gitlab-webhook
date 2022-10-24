::============================================================================================================
:: Delete the CxFlaskService in a Windows Server
:: Run this batch script in a Command Prompt (Run as Administrator)
:: This batch script requires 1 command line argument
:: The first argument is the path of python exe. e.g. "C:\Program Files\Python310\python.exe"
::============================================================================================================
ECHO OFF

:: Stop the Windows Service
echo "Stoping the Windows Service"
net stop CxFlaskService

:: Delete the Windows Service
echo "Deleting the Windows Service"
sc delete CxFlaskService

:: set the python exe path
SETLOCAL
set python_installation_folder=%1
set python_exe_path=%python_installation_folder%"\python.exe"

:: Uninstall PYPI Packages
echo "Uninstalling PYPI Packages"
%python_exe_path% -m pip uninstall -y -r requirements-win-service.txt

:: delete the chekmarx generic credential from credential manager
echo "deleting the chekmarx generic credential from credential manager"
cmdkey /delete:checkmarx

:: delete system environment variables
echo "deleting system environment variables"
REG delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /F /V "GITLAB_TOKEN"
REG delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /F /V "use_keyring"
REG delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /F /V "cxsast_base_url"
REG delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /F /V "cxsast_username"
