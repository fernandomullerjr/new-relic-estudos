
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 4 - Application Performance Monitoring (APM)"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  Application Performance Monitoring (APM)

The New Relic APM agent reports and stores the state of a server-side application to provide visibility into important metrics like errors, throughput, response times, transactions, and traces. After completing the videos and labs, move on to the next lesson.
 

APM Resources | New Relic Docs  

    Troubleshoot with the APM Summary Page(opens in a new tab)
<https://docs.newrelic.com/docs/apm/agents/manage-apm-agents/agent-data/triage-run-diagnostics/>

    APM best practices guide
<https://docs.newrelic.com/docs/new-relic-solutions/best-practices-guides/full-stack-observability/apm-best-practices-guide/>



## PENDENTE
- Continuar no video2 e depois perguntas/respostas


## Dia 12/01/2024

- Continuando o video2.

- Marcações em cinza nos gráficos do APM mostram o momento que ocorreu um deploy. É útil para mapear ofensores de casos onde tenha ocorrido algum impacto.

- Ao analisar um span de um Trace, é possível ver no span ofensor um simbolo como se fosse um relógio, para obter informações valiosas(exemplo: a duração deste span é 25% maior que os demais)
span = periodo









# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# QUESTION

## PERGUNTAS
A team continues to receive false issue notifications on their system. When they click into the issue tile and review incidents, they realize the set threshold for an alert is too low. Which of the following actions should they proceed with?

Create a new alert condition

Review and revise their current alert condition 


Create a new incident 

Review tags attached to an entity

Incorrect

When one or more incidents are triggered, they create an issue. Incidents are created from alert conditions, which are rules you define to notify you when an incident is triggered. To fix a false issue notification, you must review your current alert condition and make sure the thresholds set are accurate . 

Which New Relic feature allows you to view a single transaction to understand where time was spent in the transaction?

Errors inbox

Vulnerability management

Transaction tracing

Distributed tracing

Incorrect








Review and revise their current alert condition 


Correctly selected
 

Correct

When one or more incidents are triggered, they create an issue. Incidents are created from alert conditions, which are rules you define to notify you when an incident is triggered. To fix a false issue notification, you must review your current alert condition and make sure the thresholds set are accurate . 





Transaction tracing