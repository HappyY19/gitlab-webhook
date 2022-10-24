# cx_flask_service.py
#
# A Windows Service for the Flask Application for the handler for GitLab Webhooks.
#
# Copyright 2022 Checkmarx
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import win32serviceutil
import win32service
import win32event
import servicemanager
import socket
from waitress import serve
from gitlab_webhook_flask import app


class SmallestPythonService(win32serviceutil.ServiceFramework):
    _svc_name_ = "CxFlaskService"
    _svc_display_name_ = "CxFlaskService"

    def __init__(self, args):
        win32serviceutil.ServiceFramework.__init__(self, args)
        self.hWaitStop = win32event.CreateEvent(None, 0, 0, None)
        socket.setdefaulttimeout(60)

    def SvcStop(self):
        self.ReportServiceStatus(win32service.SERVICE_STOP_PENDING)
        win32event.SetEvent(self.hWaitStop)
        self.ReportServiceStatus(win32service.SERVICE_STOPPED)

    def SvcDoRun(self):
        servicemanager.LogMsg(
            servicemanager.EVENTLOG_INFORMATION_TYPE,
            servicemanager.PYS_SERVICE_STARTED,
            (self._svc_name_, '')
        )
        serve(app, host='0.0.0.0', port=5000)


if __name__ == '__main__':
    win32serviceutil.HandleCommandLine(SmallestPythonService)
