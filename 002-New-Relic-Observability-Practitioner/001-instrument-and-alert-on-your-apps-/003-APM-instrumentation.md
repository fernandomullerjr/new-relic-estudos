
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 3 - APM instrumentation"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# APM instrumentation

- Acessar a key
clicar no nome do meu usuario
Menu "API Keys"
https://one.newrelic.com/api-keys?account=4301656&duration=3600000&state=79dd6094-d585-e822-ac7f-38290f707329


- Necessário criar uma "INGEST - LICENSE", especifica para NodeJS.
no momento não exista uma especifica
clicar em "Create a key"

Create an API key
Ingest keys are for getting data into New Relic:
License keys for agent configuration and metric, event, log and trace APIs
Browser keys for browser applications
Mobile keys for mobile applications. To learn how to manage mobile keys, see our docs, <https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile/maintenance/configure-settings-for-mobile-monitoring/>
User keys are for querying data and managing configurations (Alerts, Synthetics, dashboards, etc.)
To learn more about API keys, see our docs, <https://docs.newrelic.com/docs/apis/intro-apis/new-relic-api-keys/>

- Criando:
nodejs-curso
Key utilizada no curso do New Relic University para projetos em NodeJS

- Copiar o valor da chave e adicionar ao .env do projeto no Glitch.
<https://glitch.com/edit/#!/titanium-water-wind?path=.env%3A6%3A0>

- Acessar o arquivo "newrelic.js"
editar linha do name
DE:
app_name: ['my-service'],
PARA:
app_name: ['FoodMe-test'],



- Efetuar compra de teste na página do projeto FoodMe-test, <https://titanium-water-wind.glitch.me/#/>
Thank you for your order!
Our chefs are getting your food ready. It will be on its way shortly.
Your order ID is 1705786786822.


- Verificar ocorrencia da transação no painel do APM.

- Consultar o total de transações via menu "Query your data"
<https://one.newrelic.com/data-exploration/query-builder?account=4301656&duration=10800000&state=f1a0cbd1-626b-f131-12a3-d206d3570da3>

~~~~sql
SELECT count(*) FROM Transaction WHERE appName = 'FoodMe-test'
~~~~

Resultado:
105Transactions




# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# RESUMO

- Criar license key do tipo "INGEST - LICENSE", para utilizar no projeto em nodeJS.
- Copiar o valor da chave e adicionar ao .env do projeto no Glitch.
- - Acessar o arquivo "newrelic.js", editar o app_name.
- Efetuar compra de teste na página do projeto FoodMe-test, <https://titanium-water-wind.glitch.me/#/>
- Verificar ocorrencia da transação no painel do APM.
- Consultar o total de transações via menu "Query your data".  SELECT count(*) FROM Transaction WHERE appName = 'FoodMe-test'