
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



- Dentro do "Data explorer", temos 3 etapas para escolher:
Event
Plot
Dimension

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






## LAB - DATA EXPLORER

1. Criar queries e adicionar ao Dashboard as preferidas.
Event Type: Transaction
Plot "count(*)"
Dimension: Name

Event Type: Transaction
Plot "Duration Max"
Dimension: Name

Event Type: PageView
Plot "Duration Max"
Dimension: PageURL


Duração máxima das transações

~~~~sql
SELECT max(duration) FROM Transaction FACET name SINCE 55 MINUTES AGO TIMESERIES
~~~~

Duração máxima do PageView

~~~~sql
SELECT max(duration) FROM PageView FACET pageUrl SINCE 55 MINUTES AGO TIMESERIES
~~~~


Added to your dashboard
View this on foodme-dashboard / foodme-dashboard




2. Explorar os atributos do PageView, usando o "RAW Data".
Quais informações você consegue ver agora que não via antes?

RAW DATA

~~~~BASH
PageView
timestamp
app Idapp Nameasnasn Latitudeasn Longitudeasn Organizationbackend Durationbrowser Transaction Namecityconnection Setup Durationcountry Codedevice Type
January 28, 2024 19:38:50
1103305516
FoodMe-Browser
268985
-29.917
-51.089
VEM PRA UNO PROVEDOR DE INTERNET LTDA
0.784
titanium-water-wind.glitch.me:443/
Cachoeirinha
0.425
BR
Desktop
0.001
1.317
titanium-water-wind.glitch.me
2.286
NDMwMTY1NnxCUk9XU0VSfEFQUExJQ0FUSU9OfDExMDMzMDU1MTY
January 28, 2024 19:07:21
1103305516
FoodMe-Browser
268985
-29.917
-51.089
VEM PRA UNO PROVEDOR DE INTERNET LTDA
3.017
titanium-water-wind.glitch.me:443/
Cachoeirinha
0.424
BR
Desktop
2.28
1.539
titanium-water-wind.glitch.me
4.811
NDMwMTY1NnxCUk9XU0VSfEFQUExJQ0FUSU9OfDExMDMzMDU1MTY
January 28, 2024 19:04:21
1103305516
FoodMe-Browser
268985
-29.917
-51.089
VEM PRA UNO PROVEDOR DE INTERNET LTDA
1.683
titanium-water-wind.glitch.me:443/
Cachoeirinha
0
BR
Desktop
0
2.852
titanium-water-wind.glitch.me
4.712
NDMwMTY1NnxCUk9XU0VSfEFQUExJQ0FUSU9OfDExMDMzMDU1MTY
January 28, 2024 19:04:20
1103305516
FoodMe-Browser
268985
-29.917
-51.089
VEM PRA UNO PROVEDOR DE INTERNET LTDA
1.548
titanium-water-wind.glitch.me:443/
Cachoeirinha
0.28
BR
Desktop
0
2.374
titanium-water-wind.glitch.me
4.124
NDMwMTY1NnxCUk9XU0VSfEFQUExJQ0FUSU9OfDExMDMzMDU1MTY
January 28, 2024 17:51:23
1103305516
FoodMe-Browser
268985
-29.917
-51.089
VEM PRA UNO PROVEDOR DE INTERNET LTDA
0.93
titanium-water-wind.glitch.me:443/
Cachoeirinha
0.424
BR
Desktop
0
1.877
titanium-water-wind.glitch.me
2.988
NDMwMTY1NnxCUk9XU0VSfEFQUExJQ0FUSU9OfDExMDMzMDU1MTY
January 28, 2024 17:51:22
1103305516
FoodMe-Browser
268985
-29.917
-51.089
VEM PRA UNO PROVEDOR DE INTERNET LTDA
0.785
titanium-water-wind.glitch.me:443/
Cachoeirinha
0
BR
Desktop
0
1.839
titanium-water-wind.glitch.me
2.82
NDMwMTY1NnxCUk9XU0VSfEFQUExJQ0FUSU9OfDExMDMzMDU1MTY
January 27, 2024 20:22:43
1103305516
FoodMe-Browser
268985
-29.917
-51.089
VEM PRA UNO PROVEDOR DE INTERNET LTDA
0.72
titanium-water-wind.glitch.me:443/
Cachoeirinha
0.283
BR
Desktop
0
1.455
titanium-water-wind.glitch.me
4.042
NDMwMTY1NnxCUk9XU0VSfEFQUExJQ0FUSU9OfDExMDMzMDU1MTY
January 27, 2024 20:22:41
1103305516
FoodMe-Browser
268985
-29.917
-51.089
VEM PRA UNO PROVEDOR DE INTERNET LTDA
0.656
titanium-water-wind.glitch.me:443/
Cachoeirinha
0.28
BR
Desktop
0.006
1.572
titanium-water-wind.glitch.me
2.504
NDMwMTY1NnxCUk9XU0VSfEFQUExJQ0FUSU9OfDExMDMzMDU1MTY
January 27, 2024 20:22:04

~~~~



3. Mover o mouse para a query NRQL que foi criada.
Clicar em "Edit in Query builder"
Change time period, eg: SINCE 1 day ago
Change the FACET