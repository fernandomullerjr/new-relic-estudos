
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
SELECT max(duration) FROM Transaction 

Slowest transactions for FoodMe app	
SELECT max(duration) FROM Transaction WHERE appName = 'FoodMe' 


## Group your data with FACET
Transactions grouped by name	
SELECT count(*) FROM Transaction FACET name

Transactions grouped by HTTP status	
SELECT count(*) FROM Transaction FACET http.statusText


## Query part of your data with WHERE
Average duration for a specific app	
SELECT average(duration) FROM Transaction WHERE appName = 'FoodMe'
Total number of unsuccessful transactions	
SELECT count(*) FROM Transaction WHERE httpResponseCode != '200'


## Challenges: Can you create these queries on your own?
**If you get stumped, move on to the next lesson :)  
The total number of transactions that led to the 404 error	???
The average transaction time on the FoodMe app	???