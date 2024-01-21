
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 5 - Explore your data with NRQL"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Explore your data with NRQL

Lesson Challenge

Before moving on to the next lesson, add the following queries to your FoodMe Dashboard(opens in a new tab)(opens in a new tab)


## Aggregate your data with Average(), Max(), Min(), and Count()
Slowest transactions for all apps in my account	
~~~~sql
SELECT max(duration) FROM Transaction 
~~~~

Slowest transactions for FoodMe app	
~~~~sql
SELECT max(duration) FROM Transaction WHERE appName = 'FoodMe' 
~~~~



## Group your data with FACET
Transactions grouped by name	
~~~~sql
SELECT count(*) FROM Transaction FACET name
~~~~

Transactions grouped by HTTP status	
~~~~sql
SELECT count(*) FROM Transaction FACET http.statusText
~~~~



## Query part of your data with WHERE
Average duration for a specific app	
~~~~sql
SELECT average(duration) FROM Transaction WHERE appName = 'FoodMe'
~~~~

Total number of unsuccessful transactions	
~~~~sql
SELECT count(*) FROM Transaction WHERE httpResponseCode != '200'
~~~~

## Challenges: Can you create these queries on your own?
**If you get stumped, move on to the next lesson :)  
The total number of transactions that led to the 404 error	???
The average transaction time on the FoodMe app	???





No dashboard Browser da aplicação FoodMe, é possível pegar o código NRQL do painel "Front end vs. back end", por exemplo, clicando em nos ... e "View query":

~~~~sql
SELECT percentile(timeToResponseStart, 50) AS 'Back end (Time to first byte)', percentile(duration-timeToResponseStart, 50) AS 'Front end (Window load + AJAX)' FROM BrowserInteraction WHERE (entityGuid = 'NDMwMTY1NnxCUk9XU0VSfEFQUExJQ0FUSU9OfDExMDMzMDU1MTY') AND (`mobileOptimized` IS NULL) LIMIT 1000 SINCE 21600 seconds AGO TIMESERIES
~~~~




Clicar em "Dashboards"