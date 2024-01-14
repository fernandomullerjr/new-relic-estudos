
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




- Analisando agora o APM e transacoes do "FoodMe + Custom Attributes":

Tem este GET que levou 230segundos:
GET /
230 s
<0.01%
17.5 ms

https://one.newrelic.com/nr1-core/apm/overview/MTAzODI4N3xBUE18QVBQTElDQVRJT058MTA0ODY2MjAxMQ?duration=604800000&filters=%28domain%20%3D%20%27APM%27%20AND%20type%20%3D%20%27APPLICATION%27%29&state=acd1be52-b269-f566-8b79-c55ba423660a

WebTransaction/Expressjs/GET//
Host: 20d937bb7348 | Language: nodejs | Entity: FoodMe + Custom Attributes | Jan 10, 2024 15:43:27.548
DT Trace ID: f5f3d01a0ecb584052452df3cd4817d4 | TT Trace ID: 
https://foodme.nru.to:8080/img/customer_bkg.jpg

Nodejs/Middleware/Expressjs/serveStatic

Performance

Attributes
Search attributes and keys
duration
229520.017318
exclusiveDurationMs
null
name
Nodejs/Middleware/Expressjs/serveStatic
nr_exclusive_duration_millis
229519.44456409375
timestamp
1704901154861







## LAB

Querying Log data

1. Acessar APM
2. Summary -> Logs
3. Using query field, find the order you placed in the FoodMe App





- Gerando pedido:

        http://foodme.nru.to:8080/#/customer
<http://foodme.nru.to:8080/#/customer>


- Necessário cartão fake:
visa
5482078545167852
06/2024
994

Thank you for your order!

Our chefs are getting your food ready. It will be on its way shortly.

Your order ID is 1705264690730.


- Consegui filtrar utilizando esta query:

~~~~sql
SELECT `message`,`deliverTo.name`,`items` FROM Log WHERE `entity.guid` = 'MTAzODI4N3xBUE18QVBQTElDQVRJT058MTA0ODY2MjAxMQ' OR `entity.guids` LIKE '%MTAzODI4N3xBUE18QVBQTElDQVRJT058MTA0ODY2MjAxMQ%' OR `service_name` = 'FoodMe + Custom Attributes' OR `serviceName` = 'FoodMe + Custom Attributes' OR `service.name` = 'FoodMe + Custom Attributes' OR `entity.name` = 'FoodMe + Custom Attributes' AND `deliverTo.name` LIKE '%Carlos%' SINCE 30 minutes ago
~~~~

- Resultado:

~~~~bash
17:38:10.730
checkout
Carlos Santana
[{"name":"Grilled Chicken","price":4.95,"qty":5},{"name":"Yassa Chicken","price":8.95,"qty":2},{"name":"Yassa Lamb","price":8.25,"qty":2}]
~~~~