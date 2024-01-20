
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 1 - Instrument and Alert on your apps with APM, Browser, & Synthetics - Lesson 1 of 17 - Introduction"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Instrument and Alert on your apps with APM, Browser, & Synthetics

Lesson 1 of 17
Introduction

Overview

This course will provide you with the practical skills and knowledge needed to instrument, monitor, troubleshoot, and alert a technology stack using Browser and APM monitoring.

Course objectives

After completing this course, you will be able to…

    Instrument a service with the New Relic APM and Browser agents

    Implement custom attributes to identify specific business related data trends

    Query real-user-data to build custom dashboards

    Create an alert workflow to be notified of issues when they occur

    Create and implement synthetic monitors to verify critical application user flow

Prerequisite knowledge

The lessons in this course assume prerequisite knowledge gained in the Foundations learning path(opens in a new tab). This includes but is not limited to; the classification and use cases of telemetry data types, the industry of monitoring & observability, and navigation of the New Relic Platform. 

It is recommended that you complete that learning path before starting this course.