::============================================================================================================
:: Deploy the CxFlaskService in a Windows Server
:: Run this batch script in a Command Prompt (Run as Administrator)
:: This batch script requires 3 command line arguments
:: The first argument is the value of System Environment Variable GITLAB_TOKEN, e.g. "111"
:: The second argument is the URL of Checkmarx Manager Server. e.g. "https://localhost"
:: The third argument is the username of CxSAST. e.g. "Admin"
:: The fourth argument is installation folder of python. e.g. "C:\Program Files\Python310"
::============================================================================================================
ECHO OFF

:: set system environment variable GITLAB_TOKEN
setx GITLAB_TOKEN %1 /m

:: set system environment variable use_keyring, so the password will be read from Windows Credential Manager
setx use_keyring "yes" /m

:: set system environment variable cxsast_base_url
setx cxsast_base_url %2 /m

:: set system environment variable cxsast_username
setx cxsast_username %3 /m
set username=%3

:: Get input from user as password
set /p password=Please Type Your CxSAST Password:

:: create or update a generic credential in Windows Credential Manager
cmdkey /generic:checkmarx /user:%username% /pass:%password%

:: set the python exe path
SETLOCAL
set python_exe_folder=%4
set python_exe_path=%python_exe_folder%\python.exe
set pywin32_postinstall_path=%python_exe_folder%\Scripts\pywin32_postinstall.py

echo %python_exe_path%
echo %pywin32_postinstall_path%

:: install dependencies
%python_exe_path% -m pip install -r requirements-win-service.txt

:: run pywin32 postinstall script
%python_exe_path% %pywin32_postinstall_path%  -install

:: install CxFlaskService
%python_exe_path% cx_flask_service.py install

:: start CxFlaskService
net start CxFlaskService
