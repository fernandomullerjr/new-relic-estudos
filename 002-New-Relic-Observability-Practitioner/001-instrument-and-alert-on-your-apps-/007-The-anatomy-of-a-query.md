
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 7 - The anatomy of a query."
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# The anatomy of a query

## Video Notes and URLs

    NRQL Default Events
<https://docs.newrelic.com/docs/data-apis/understand-data/event-data/default-events-reported-new-relic-products/>


## Main event types

APM
transaction

Browser monitoring
PageView







## gpt
ChatGPT

A NRQL (New Relic Query Language) é uma linguagem de consulta utilizada para recuperar dados nos produtos da New Relic, como o New Relic Insights. A anatomia básica de uma query NRQL é semelhante à de uma consulta SQL, mas com algumas diferenças específicas para a plataforma New Relic. Aqui estão os principais componentes de uma consulta NRQL:

    Seleção de Dados (SELECT): Especifica quais dados você deseja recuperar da fonte.

    Exemplo:

    nrql

SELECT average(duration) FROM Transaction

Fonte de Dados (FROM): Indica a fonte de dados ou evento que você está consultando.

Exemplo:

nrql

SELECT count(*) FROM PageView

Condição (WHERE): Opcionalmente, você pode filtrar os dados com base em condições específicas.

Exemplo:

nrql

SELECT count(*) FROM Transaction WHERE appName = 'MyApp'

Agrupamento (FACET): Permite agrupar os resultados por uma ou mais dimensões.

Exemplo:

nrql

SELECT count(*) FROM Transaction FACET appName

Ordem (ORDER BY): Define a ordem dos resultados com base em uma ou mais colunas.

Exemplo:

nrql

SELECT count(*) FROM Transaction FACET appName ORDER BY count(*) DESC

Limitação de Resultados (LIMIT): Define o número máximo de resultados a serem retornados.

Exemplo:

nrql

    SELECT count(*) FROM Transaction LIMIT 10

Esses são os componentes básicos, e você pode combiná-los para criar consultas mais complexas e específicas para suas necessidades. Lembre-se de consultar a documentação oficial da New Relic para obter informações mais detalhadas e exemplos específicos para o produto ou recurso que você está usando.






## NRQL syntax

<https://docs.newrelic.com/docs/query-your-data/nrql-new-relic-query-language/get-started/introduction-nrql-how-nrql-works/#syntax>

SELECT function(attribute) [AS 'label'][, ...] 
  FROM data type | event_type
  [WHERE attribute [comparison] [AND|OR ...]][AS 'label'][, ...]
  [FACET attribute | function(attribute)]
  [LIMIT number]
  [SINCE time]
  [UNTIL time]
  [WITH TIMEZONE timezone]
  [COMPARE WITH time]
  [TIMESERIES time]


