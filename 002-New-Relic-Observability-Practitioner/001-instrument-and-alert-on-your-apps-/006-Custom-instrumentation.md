
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 6 - Custom instrumentation"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Custom instrumentation

Video Notes and URLs

    index.js(opens in a new tab) solution code, 
<https://drive.google.com/file/d/1fmXAlt_QTqaIfMOKo4IqiVj14F0CHfOz/view?usp=sharing>

    cart.js(opens in a new tab) solution code
<https://drive.google.com/file/d/1Pg350jH2UAPvD5nsXwQUuYQqCXNv7AQo/view?usp=sharing>




## Atributos

- Acessar "Query your data"
SELECT count(*) FROM Transaction FACET restaurant
Isto não retorna nada, porque não temos este atributo para poder consultar por restaurante.

- Acessar o Glitch
pasta server/
arquivo index.js
<https://glitch.com/edit/#!/titanium-water-wind?path=server%2Findex.js%3A1%3A0>

Arquivo disponivel na pagina da aula.
Porém o código já está inserido, basta descomentar as linhas 64 e 78

~~~~js
    var order = req.body;
    var itemCount = 0;
    var orderTotal = 0;
    order.items.forEach(function(item) { 
      itemCount += item.qty;
      orderTotal += item.price * item.qty;
    });
    newrelic.addCustomAttributes({
      'customer': order.deliverTo.name,
      'restaurant': order.restaurant.name,
      'itemCount': itemCount,
      'orderTotal': orderTotal
    });
    
    return res.status(201).send({ orderId: Date.now() });
  });
~~~~



video -6:02

## Dia 26/01/2024

- Fazer um pedido, para validar

Thank you for your order!

Our chefs are getting your food ready. It will be on its way shortly.

Your order ID is 1706315741415.




- Acessar "Query your data", tentar fazer a mesma query novamente:
SELECT count(*) FROM Transaction FACET restaurant


- Código que também funciona, traz o valor total por ordem:
SELECT count(*) FROM Transaction FACET orderTotal





Agora vamos editar a parte relacionada ao browser.

- Acessar o Glitch
Ir na pasta app/
js/
services/
cart.js
<https://glitch.com/edit/#!/titanium-water-wind?path=app%2Fjs%2Fservices%2Fcart.js%3A1%3A0>

Editar o código
descomentar a linha 61
descomentar a linha 70 também




- Após o ajuste, efetuar pedidos de teste.

Thank you for your order!

Our chefs are getting your food ready. It will be on its way shortly.

Your order ID is 1706316979081.



Thank you for your order!

Our chefs are getting your food ready. It will be on its way shortly.

Your order ID is 1706317003912.






- Acessar "Query your data", tentar esta query:
SELECT count(*) FROM PageAction

não retornou nada
parece ser um problema com a configuração do cart.js, newrelic.js e o 


- Resolvido.
- Foi necessário acessar a parte de "+ add data"
ir em "Browser monitoring"
Adicionar uma aplicação para instrumentar a parte de browser
"Choose your instrumentation method"
Escolher esta opção:
"Connect browser data to an application's APM data
Choose this method if you've already instrumented your application with APM."


- Acessar "Query your data", tentar esta query:
SELECT count(*) FROM PageAction

agora retorna
6 Page Actions





- Acessar "Query your data", efetuar esta query mais avançada:
SELECT count(*) FROM PageAction WHERE appName = 'FoodMe-Browser' FACET restaurant,item,qty


Since 1 hour ago
Esther's German SaloonBockwurst Würstchen11
Esther's German SaloonUngarische Gulaschsuppe mit Brötchen11
Esther's German SaloonWienerschnitzel11
Esther's German SaloonWurstsalad mit Bauernbrot11
Le Bateau Rougefrites aïoli 11
Le Bateau Rougemoules et frites11



most popular items

add to dashboard

foodme-dashboard / foodme-dashboard
Account 4301656


https://one.newrelic.com/dashboards/detail/NDMwMTY1NnxWSVp8REFTSEJPQVJEfGRhOjUxMzAwNzQ?state=5bcfe257-e3a0-cc1c-3768-66d175cdc5a5


## PENDENTE
- Adicionar demais widgets no Dashboard, antes de prosseguir.








## Dia 27/01/2024
- Adicionar demais widgets no Dashboard, antes de prosseguir.


Thank you for your order!

Our chefs are getting your food ready. It will be on its way shortly.

Your order ID is 1706397800922.




Thank you for your order!

Our chefs are getting your food ready. It will be on its way shortly.

Your order ID is 1706397819206.


- App data NRQL query examples:
<https://docs.newrelic.com/docs/query-your-data/nrql-new-relic-query-language/nrql-query-tutorials/app-data-nrql-query-examples/>

- Browser/SPA NRQL query examples:
<https://docs.newrelic.com/docs/query-your-data/nrql-new-relic-query-language/nrql-query-tutorials/browserspa-nrql-query-examples/>

- NRQL reference:
<https://docs.newrelic.com/docs/query-your-data/nrql-new-relic-query-language/get-started/nrql-syntax-clauses-functions/>




- Adicionar demais widgets no Dashboard, antes de prosseguir.
nrql para trazer "transactions grouped by name"
SELECT count(*) FROM Transaction FACET name



Added to your dashboard
View this on foodme-dashboard / foodme-dashboard
<https://one.newrelic.com/dashboards/detail/NDMwMTY1NnxWSVp8REFTSEJPQVJEfGRhOjUxMzAwNzQ?state=5bcfe257-e3a0-cc1c-3768-66d175cdc5a5>




Total number of unsuccessful transactions	
~~~~sql
SELECT count(*) FROM Transaction WHERE httpResponseCode != '200'
~~~~



Average duration for a specific app	
~~~~sql
SELECT average(duration) FROM Transaction WHERE appName = 'FoodMe-test'
~~~~



Transactions grouped by HTTP status	
~~~~sql
SELECT count(*) FROM Transaction FACET http.statusText
~~~~



- Ajustando o Widget "Total number of unsuccessful transactions", pois os OK estão batendo código 225, então ajustei para que transação ÑOK seja 400 ou acima:

~~~~sql
SELECT count(*) FROM Transaction WHERE httpResponseCode >= '400'
~~~~

- Atualizado widget e dashboard:
<https://one.newrelic.com/dashboards/detail/NDMwMTY1NnxWSVp8REFTSEJPQVJEfGRhOjUxMzAwNzQ?state=8ad77a1d-b167-ed5f-9679-c849e86d8cad>