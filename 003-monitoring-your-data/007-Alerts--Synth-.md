
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 7 - Alerts, synthetics, & NRQL - Oh my!"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Alerts, synthetics, & NRQL - Oh my!


Before jumping into the videos in this lesson, please read about the features we'll explore in each tab below:


## Alerts

Once data is being reported to your observability platform, a natural next step is to set up alerts. Alerts notify stakeholders when telemetry data surpasses a predefined threshold, indicating a need for attention. You can't expect your team to stare at New Relic dashboards all day, every day waiting for the next error or slow trace to occur, can you?

Alerts are useful because when an alert threshold is crossed, the platform will both send notifications to the selected destinations and also create a detailed record and timeline of the incident, available on a built-in platform dashboard.




## Synthetics

The role of a synthetic monitor is to run into an issue before one of your users does. Think of a synthetic monitor like a program, or a bot, that attempts the same action(s) over and over again. If it fails to complete this action at any time, then you'll know something has changed for the worse. Perhaps a new deployment caused a broken link, or a host has reached its limits and your site is down. 

If a synthetic monitor has failed, you'll want to be alerted about it.




## NRQL

Until this point, we have been looking at charts and dashboards created for us by the New Relic Platform. However, your business, like the fictional businesses in the NRU Training account, has an infinite number of ways in which data can be queried and correlated to provide value. 

NRQL enables us to ask questions from our data in any way you can imagine! These custom queries can be used to quickly and easily create charts and dashboards that align with your business KPIs. 



Watch the videos below to learn more about how alerts, synthetics, and NRQL work together in the New Relic Platform. Complete any tasks that are asked of you using the NRU Training account. After completing the videos, answer the knowledge check questions and then move on to the next lesson.












## questions

Match the New Relic Platform feature with its function

    
Alerts
This feature defines the conditions and thresholds that you want to know about

Synthetics
This feature simulates traffic so that it can encounter an issue before a user does

NRQL
This feature enables you to query and interpret your data any way you'd like