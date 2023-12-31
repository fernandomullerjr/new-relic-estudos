


## ERRO

Falha de coleta no New Relic, dados não constam no Dashboard do New Relic.



- Serviço com erros

~~~~~bash
fernando@debian10x64:~$ ps -ef | grep relic
root      20542      1  0 19:09 ?        00:00:00 /usr/bin/newrelic-infra-service
root      20550  20542  0 19:09 ?        00:00:13 /usr/bin/newrelic-infra
root      20838  20550  0 19:09 ?        00:00:05 /opt/fluent-bit/bin/fluent-bit -c /tmp/fb/nr_fb_config1822912085 -e /var/db/newrelic-infra/newrelic-integrations/logging/out_newrelic.so -R /var/db/newrelic-infra/newrelic-integrations/logging/parsers.conf
fernando  48821  48727  0 20:45 pts/3    00:00:00 grep relic
fernando@debian10x64:~$ date
Fri 29 Dec 2023 08:47:14 PM -03
fernando@debian10x64:~$ curl horacerta.com.br
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="http://www.horacerta.com.br/">here</a>.</p>
</body></html>
fernando@debian10x64:~$ sudo systemctl status newrelic-infra
[sudo] password for fernando:
● newrelic-infra.service - New Relic Infrastructure Agent
   Loaded: loaded (/etc/systemd/system/newrelic-infra.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2023-12-29 19:09:45 -03; 1h 47min ago
 Main PID: 20542 (newrelic-infra-)
    Tasks: 33 (limit: 11733)
   Memory: 98.7M (limit: 1.0G)
   CGroup: /system.slice/newrelic-infra.service
           ├─20542 /usr/bin/newrelic-infra-service
           ├─20550 /usr/bin/newrelic-infra
           └─20838 /opt/fluent-bit/bin/fluent-bit -c /tmp/fb/nr_fb_config1822912085 -e /var/db/newrelic-infra/newrelic-integrations/logging/out_newrelic.so -R /var/db/newrelic-infra/newrelic-integrations/logging/parsers.conf

Dec 29 19:09:52 debian10x64 newrelic-infra-service[20542]: 2023/12/29 19:09:52 http: superfluous response.WriteHeader call from github.com/newrelic/infrastructure-agent/internal/httpapi.(*Server).handleEntity (httpapi.go:377)
Dec 29 19:09:52 debian10x64 newrelic-infra-service[20542]: 2023/12/29 19:09:52 http: superfluous response.WriteHeader call from github.com/newrelic/infrastructure-agent/internal/httpapi.(*Server).handleEntity (httpapi.go:377)
Dec 29 19:09:53 debian10x64 newrelic-infra-service[20542]: time="2023-12-29T19:09:53-03:00" level=error msg="cannot build supervisor executor" component=integrations.Supervisor error="failed to load log configs" process=log-forwarder
Dec 29 19:09:53 debian10x64 newrelic-infra-service[20542]: time="2023-12-29T19:09:53-03:00" level=error msg="cannot build supervisor executor" component=integrations.Supervisor error="failed to load log configs" process=log-forwarder
Dec 29 19:09:53 debian10x64 newrelic-infra-service[20542]: time="2023-12-29T19:09:53-03:00" level=error msg="cannot build supervisor executor" component=integrations.Supervisor error="failed to load log configs" process=log-forwarder
Dec 29 19:09:53 debian10x64 newrelic-infra-service[20542]: time="2023-12-29T19:09:53-03:00" level=error msg="cannot build supervisor executor" component=integrations.Supervisor error="failed to load log configs" process=log-forwarder
Dec 29 19:09:53 debian10x64 newrelic-infra-service[20542]: time="2023-12-29T19:09:53-03:00" level=error msg="cannot build supervisor executor" component=integrations.Supervisor error="failed to load log configs" process=log-forwarder
Dec 29 19:10:50 debian10x64 newrelic-infra-service[20542]: time="2023-12-29T19:10:50-03:00" level=info msg="Integration health check finished with success" component=integrations.runner.Runner integration_name=nri-docker runner_uid=63bf05ffb8
Dec 29 20:43:15 debian10x64 newrelic-infra-service[20542]: time="2023-12-29T20:43:15-03:00" level=error msg="metric sender can't process" component=MetricsIngestSender error="error sending events: Post \"https://infra-api.newrelic.com/infra/v2/metrics/events/bulk\": read tcp 192.168.13
Dec 29 20:43:16 debian10x64 newrelic-infra-service[20542]: time="2023-12-29T20:43:16-03:00" level=warning msg="[engine] failed to flush chunk '20838-1703893390.993964218.flb', retry in 11 seconds: task_id=0, input=tail.8 > output=newrelic.0 (out_id=0)" component=integrations.Supervisor
fernando@debian10x64

~~~~~







## DIAGNOSTICO

https://docs.newrelic.com/docs/new-relic-solutions/solve-common-issues/diagnostics-cli-nrdiag/run-diagnostics-cli-nrdiag/

~~~~BASH
fernando@debian10x64:~$ curl -Ls https://download.newrelic.com/nrdiag/scripts/install.sh | bash && sudo ./nrdiag CLI_OPTIONS
Starting installation.
Installing New Relic Diagnostics CLI v3.2.5
Installing to /home/fernando using sudo

Check Results
-------------------------------------------------
Info     Base/Containers/DetectDocker [Docker Daemon is Running]
Info     Base/Env/CollectEnvVars [Gathered Environment variables of current shell.]
We've found a file that may contain secure information: /home/fernando/Python-3.8.3/Mac/PythonLauncher/MyAppDelegate.m
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
We've found a file that may contain secure information: /home/fernando/cursos/Kubernetes/kubedev/aula56-Desafio-Docker/questao6/review/src/Review.Web/Review.Web.csproj
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
We've found a file that may contain secure information: /home/fernando/cursos/Kubernetes/kubedev/aula86-Deploy-de-uma-aplicacao/pedelogo-catalogo/src/PedeLogo.Catalogo.Api/PedeLogo.Catalogo.Api.csproj
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
We've found a file that may contain secure information: /home/fernando/laravel/laravel-example-project/public/web.config
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
We've found a file that may contain secure information: /home/fernando/cursos/Kubernetes/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web/ConversaoPeso.Web.csproj
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
We've found a file that may contain secure information: /home/fernando/cursos/Kubernetes/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web/appsettings.json
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
We've found a file that may contain secure information: /home/fernando/cursos/Kubernetes/kubedev/aula56-Desafio-Docker/questao6/review/src/Review.Web/appsettings.json
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
We've found a file that may contain secure information: /home/fernando/cursos/Kubernetes/kubedev/aula86-Deploy-de-uma-aplicacao/pedelogo-catalogo/src/PedeLogo.Catalogo.Api/appsettings.json
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
We've found a file that may contain secure information: /home/fernando/laravel/travellist-laravel-demo/public/web.config
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
We've found a file that may contain secure information: /home/fernando/testes/travellist-laravel-demo/public/web.config
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
Success  Base/Config/Collect
Success  Base/Config/Validate
Success  Base/Config/LicenseKey
Warning  Base/Config/ValidateLicenseKey
We've found a file that may contain secure information: /var/log/installer/syslog
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
We've found a file that may contain secure information: /var/log/syslog
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: n
Failure  Base/Log/Copy
Success  Infra/Config/Agent
We've found a file that may contain secure information: /etc/newrelic-infra/integrations.d/docker-config.yml
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: y
Adding file to Diagnostics CLI zip file:  /etc/newrelic-infra/integrations.d/docker-config.yml
We've found a file that may contain secure information: /etc/newrelic-infra/logging.d/discovered.yml
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: y
Adding file to Diagnostics CLI zip file:  /etc/newrelic-infra/logging.d/discovered.yml
We've found a file that may contain secure information: /etc/newrelic-infra/logging.d/logging.yml
Include this file in nrdiag-output.zip?
Choose 'y' or 'n', then press enter: y
Adding file to Diagnostics CLI zip file:  /etc/newrelic-infra/logging.d/logging.yml
Success  Infra/Config/IntegrationsCollect
Success  Infra/Config/IntegrationsValidate
Info     Infra/Agent/Version [1.48.1]
Success  Infra/Config/IntegrationsMatch
Info     Java/Env/Version [openjdk version "11.0.21" 2023-10-17 OpenJDK Runti...]
Success  Infra/Agent/Connect
Error    DotNetCore/Env/Versions
Info     Base/Env/HostInfo [Collected host information]
Info     Base/Env/InitSystem [Systemd detected]
Success  Base/Env/RootUser
Success  Base/Collector/ConnectEU
Failure  Infra/Env/ClockSkew
Warning  Base/Config/AppName
Success  Base/Collector/ConnectUS
Warning  Infra/Log/LevelCheck
Warning  Java/AppServer/WebSphere
Error    Python/Requirements/PythonVersion
Success  Infra/Config/DataDirectoryCollect
62 results not shown: 62 None
See nrdiag-output.json for full results.

Issues Found
-------------------------------------------------
Warning - Base/Config/ValidateLicenseKey
We validated 1 license key(s):
The license key found in /etc/newrelic-infra.yml did not match the one assigned to your account:
5dsa5d8asdss4ad8asd87a4d4
If you are not using the account's original license key, you can ignore this warning. The Diagnostics CLI only validates the account's original license key. Read more about license keys - https://docs.newrelic.com/docs/apis/intro-apis/new-relic-api-keys/#license-key



Failure - Base/Log/Copy
User opted out when Diagnostics CLI asked if it can collect this file that may contain secure information.
If you are working with a support ticket, manually provide your New Relic log file for further troubleshooting
User opted out when Diagnostics CLI asked if it can collect this file that may contain secure information.
If you are working with a support ticket, manually provide your New Relic log file for further troubleshooting

See https://docs.newrelic.com/docs/agents/manage-apm-agents/troubleshooting/generate-new-relic-agent-logs-troubleshooting for more information.

Error - DotNetCore/Env/Versions
Unable to complete this health check because we ran into some unexpected errors when attempting to collect this application's .NET Core version:
Unable to run 'dotnet --info':
%w
exec: "dotnet": executable file not found in $PATHUnable to run 'dotnet --version':
%w
exec: "dotnet": executable file not found in $PATH

Failure - Infra/Env/ClockSkew
Detected clock skew of 89011 seconds between host and New Relic collector. This could lead to chart irregularities:
        Host time:      2023-12-30 00:03:45.007370337 +0000 UTC
        Collector time: 2023-12-31 00:47:17 +0000 UTC
Your host may be affected by clock skew. Please consider using NTP to keep your host clocks in sync.

Warning - Base/Config/AppName
No New Relic app names were found. Please ensure an app name is set in your New Relic agent configuration file or as a New Relic environment variable (NEW_RELIC_APP_NAME). Ignore this warning if you are troubleshooting for a non APM Agent.
See https://docs.newrelic.com/docs/agents/manage-apm-agents/app-naming/name-your-application for more information.

Warning - Infra/Log/LevelCheck
Infrastructure logging level not set to verbose (debug/trace). If troubleshooting an Infrastructure issue, please set log level to: debug in newrelic-infra.yml.
See https://docs.newrelic.com/docs/infrastructure/new-relic-infrastructure/troubleshooting/generate-logs-troubleshooting-infrastructure for more information.

Warning - Java/AppServer/WebSphere
We suspect this is a WebSphere environment but we're unable to determine the version. Supported status is unknown.
See https://docs.newrelic.com/docs/agents/java-agent/additional-installation/ibm-websphere-application-server for more information.

Error - Python/Requirements/PythonVersion
Error parsing the Python Version.

Creating nrdiag-output.zip


For better results, run Diagnostics CLI with the 'suites' option to target a New Relic product. To learn how to use this option, run: './nrdiag -h suites'

fernando@debian10x64:~$

~~~~


- Necessário verificar sobre o trecho:

Failure - Infra/Env/ClockSkew
Detected clock skew of 89011 seconds between host and New Relic collector. This could lead to chart irregularities:
        Host time:      2023-12-30 00:03:45.007370337 +0000 UTC
        Collector time: 2023-12-31 00:47:17 +0000 UTC
Your host may be affected by clock skew. Please consider using NTP to keep your host clocks in sync.




- Via timedatectl não funcionou:
sudo timedatectl set-time '21:47:00'
sudo timedatectl set-time '2023-12-30'



- Instalando o NTP
sudo apt-get update
sudo apt-get install ntp
sudo service ntp status



~~~~bash

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos$ history | tail
  506  sudo service ntp status
  507  sudo apt-get update
  508  sudo apt-get install ntp
  509  sudo service ntp status
  510  date
  511  sudo service ntp status
  512  sudo service ntp status
  513  date
  514  date
  515  history | tail
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos$

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos$ date
Sat 30 Dec 2023 09:50:24 PM -03
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos$
~~~~






# SOLUÇÃO

- Após ajuste no horário(instalado o ntp, então horário ajustou sozinho), o serviço do New Relic voltou a enviar dados ao Dashboard via agent.