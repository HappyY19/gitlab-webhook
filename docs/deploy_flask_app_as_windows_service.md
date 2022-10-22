# Note
Deploy Python application as a Windows Service requires to use pywin32.
According to document of pywin32, running Python application as a Windows Service requires Python to be installed in a 
location where the user running the service has access to the installation and is able to load pywintypesXX.dll and 
pythonXX.dll.

We will choose the 'System' Python to run the application. We will use Python3.

We will use waitress as the Python WSGI server to server the Flask application.

# Steps to deploy

## Start a CMD with Administrator Permission

In Windows Search box, type 'command prompt', right-click the command prompt, run as administrator

## install pypi packages

`python -m pip install -r requirements.txt`

Here is the contents of requirements.txt
```
CheckmarxPythonSDK == 0.5.9
Flask == 2.2.2
pywin32 == 304
waitress == 2.1.2
```

## run pywin32_postinstall script

`python "C:\Program Files\Python3\Scripts\pywin32_postinstall.py"  -install`

You will see the following messages: 

Copied pythoncom37.dll to C:\WINDOWS\system32\pythoncom37.dll

Copied pywintypes37.dll to C:\WINDOWS\system32\pywintypes37.dll

## Install the Windows Service

`python cx_flask_service.py install`

## Start the Windows Service
You can use `python cx_flask_service.py start` or `net start CxFlaskService` to start the Windows Service


# Other command to Manage Windows Service

## Stop the Windows Service
`python cx_flask_service.py stop` or `net stop CxFlaskService`

## update the service if the code has changed
`python cx_flask_service.py update` 

## Delete the Windows Service
`python cx_flask_service.py remove` or `sc delete CxFlaskService`