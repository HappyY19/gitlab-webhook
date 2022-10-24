# Deploy the Flask Application as a Windows Service

Deploy a Python application as a Windows Service requires to use pywin32. According to document of pywin32, running 
Python application as a Windows Service requires Python to be installed in a location where the user running the service
has access to the installation and is able to load pywintypesXX.dll and pythonXX.dll.

## Install Python for All Users

We will choose the 'System' Python to run the application, and We will use Python3. During installation of Python, in 
the Python installer wizard, choose Customize Installation, and select "Add python.exe to PATH". In the Advanced Options
step, choose install python for all users. Copy the python installation folder e.g. "C:\Program Files\Python3", as we 
will use it later.

We will use [waitress](https://flask.palletsprojects.com/en/2.2.x/deploying/waitress/) as the Python WSGI server to 
serve the Flask application.

## Deploy the Windows Service

### Start a CMD with Administrator Permission

In Windows Search box, type 'command prompt', right-click the command prompt, run as administrator.

### Start a New CMD as LocalSystem User

The Windows Service will be run as LocalSystem user. Copy and paste the following command, and run it. It would start a 
new Command Prompt as the LocalSystem user. 

```commandline
psexec.exe -s -i cmd.exe
```

### Run the Batch Script to Install and Start the Windows Service 

in the new Command Prompt, go to the gitlab-webhook folder, run the deploy_win_service.bat batch script with arguments:

deploy_win_service.bat "<GITLAB_TOKEN>" "<CHECKMARX_BASE_URL>" "<CHECKMARX_USERNAME>" "<PYTHON_INSTALLATION_FOLDER>" 

for example:
```commandline
deploy_win_service.bat "a1b2c3" "http://happyy-laptop" "Admin" "C:\Program Files\Python3"
```


# Delete Windows Service and Remove Dependencies

delete_win_service.bat "<PYTHON_INSTALLATION_FOLDER>" 

for example:
```commandline
delete_win_service.bat "C:\Program Files\Python3"
```
