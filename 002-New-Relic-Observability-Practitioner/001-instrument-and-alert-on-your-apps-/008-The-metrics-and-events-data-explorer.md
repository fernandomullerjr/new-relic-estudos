
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 8 - The metrics and events data explorer."
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  The metrics and events data explorer

Video Notes and URLs

    (opens in a new tab)NRQL Default Events
<https://docs.newrelic.com/docs/data-apis/understand-data/event-data/default-events-reported-new-relic-products/>

(opens in a new tab)
    Introduction to the metrics and events data explorer
<https://docs.newrelic.com/docs/query-your-data/explore-query-data/browse-data/introduction-data-explorer/>



- Fazendo pedido para ter métricas recentes:

<https://titanium-water-wind.glitch.me/#/>

Thank you for your order!

Our chefs are getting your food ready. It will be on its way shortly.

Your order ID is 1706479657608.




- Para acessar o "Data explorer", é uma aba disponível dentro do "Query Your Data".
Selecionar "Events"
Escolher "Transaction"
Plot, escolher "count(*)"
Em "Dimensions" / "Group by" selecionar o http.statusCode
OBS: Pode demorar algum tempo até ficar disponível a dimension do http status code!!! 
OBS: Pode demorar algum tempo até ficar disponível a dimension do http status code!!! 
OBS: Pode demorar algum tempo até ficar disponível a dimension do http status code!!! 
OBS: Pode demorar algum tempo até ficar disponível a dimension do http status code!!! 

~~~~sql
SELECT count(*) FROM Transaction FACET `http.statusCode` SINCE 1 days AGO TIMESERIES
~~~~



Thank you for your order!

Our chefs are getting your food ready. It will be on its way shortly.

Your order ID is 1706479657608.






## LAB

