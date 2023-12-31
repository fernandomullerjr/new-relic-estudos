
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 3 - What is monitoring?"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status





# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  aula 3 - What is monitoring?


## MEAN TIME TO DETECT
MTTD is the amount of time, on average, between the start of an issue and when teams become aware of it. This does not include time spent troubleshooting or fixing the issue.



## MEAN TIME TO RESOLUTION
MTTR is the average amount of time between when an issue is detected, and when systems are fixed and operating normally again. Ideally this includes both time spent fixing the issue, and implementing proactive steps to prevent it from happening again.








Four Golden Signals
 Latency, Traffic, Errors, & Saturation




Core Web Vitals
RED method
USE method

    Four Golden Signals

UX layer
Service layer
Infrastructure layer
Service & Infrastructure layer