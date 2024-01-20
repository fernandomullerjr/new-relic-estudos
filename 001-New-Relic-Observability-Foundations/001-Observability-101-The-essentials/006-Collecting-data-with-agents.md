
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 6 - Collecting data with agents"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Collecting data with agents

Agents are integrated into a service through a process called instrumentation. 

At New Relic, this list of agents includes:

APM agent - for server-side applications
Browser agent - for browser applications 
Mobile agent - for mobile applications
Infrastructure agents - for hosts and on-host integrations





 The browser agent is a line of JavaScript that runs in the client browser. You can manually place that code yourself or ask the APM agent to do it.





True or False: In order to instrument a system that hosts your application, you need to have code level access to that system.

True
Incorrectly selected

False
Incorrectly unselected

Incorrect

New Relic's On-Host-Integrations allow you to instrument hosts and services that you do not have code level access to.






# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# RESUMO

- New Relic consegue instrumentar hosts e serviços, mesmo sem ter acesso em level do código.