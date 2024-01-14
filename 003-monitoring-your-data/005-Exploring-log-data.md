
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 5 - Exploring log data"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#   Exploring log data


Exploring log data

Log monitoring

Log management provides a way to connect your log data with the rest of your application and infrastructure data. With the Logs UI in the New Relic Platform, you can instantly search through your logs and troubleshoot performance issues without switching between other tools.

Watch the video below. Along the way, complete any tasks included in the video using the NRU Training account. After completing the video, move on to the next lesson.



- Consultando logs com NRQL

~~~~SQL
SELECT `message`,`entity.name`,`error.stack` FROM Log WHERE `entity.guid` = 'MTYwNjg2MnxBUE18QVBQTElDQVRJT058NDMxOTIyMTA' OR `entity.guids` LIKE '%MTYwNjg2MnxBUE18QVBQTElDQVRJT058NDMxOTIyMTA%' OR `service_name` = 'WebPortal' OR `serviceName` = 'WebPortal' OR `service.name` = 'WebPortal' OR `entity.name` = 'WebPortal' AND `error.message` LIKE '%HTTP%' SINCE 7 days ago
~~~~

- Filtrando pelo campo level, do tipo ERROR:

~~~~SQL
SELECT `message`,`entity.name`,`error.stack`,`level` FROM Log WHERE `entity.guid` = 'MTYwNjg2MnxBUE18QVBQTElDQVRJT058NDMxOTIyMTA' OR `entity.guids` LIKE '%MTYwNjg2MnxBUE18QVBQTElDQVRJT058NDMxOTIyMTA%' OR `service_name` = 'WebPortal' OR `serviceName` = 'WebPortal' OR `service.name` = 'WebPortal' OR `entity.name` = 'WebPortal' AND `level` = 'ERROR' SINCE 7 days ago
~~~~