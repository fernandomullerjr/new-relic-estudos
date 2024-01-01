
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 2 - Generating data"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Generating data

This course is a series of labs

In this course, you will watch a series of videos that will guide you through several features of the New Relic Platform. During these labs, you will often be asked to complete specific tasks such as generating your own data, using a specific feature in the New Relic Platform, and creating your own queries using the New Relic Query Language (NRQL). 

Demo app 1 - FoodMe

In the video below, you'll be making an order on a sample application called FoodMe. Throughout the rest of this course, we'll be using a number of features in the New Relic Platform related to the data being collected at the UX, service, and infrastructure layers of FoodMe. 

    FoodMe's home page can be found here(opens in a new tab)(opens in a new tab).
        http://foodme.nru.to:8080/#/customer
<http://foodme.nru.to:8080/#/customer>

    FoodMe's browser entity in the NRU Training account (called FoodMe + Custom Attributes) can be found here(opens in a new tab).
    https://onenr.io/07j9ab9lAjO
<https://onenr.io/07j9ab9lAjO>






        http://foodme.nru.to:8080/#/customer
<http://foodme.nru.to:8080/#/customer>
5482078545167852
06/2024
994

Fried banana and ice cream 	$11.45 	$11.45 	
	Pumpkin curry 	$6.95 	$83.40 	
	Red curry with chicken 	$8.95 	$8.95 	
		Total: 	$103.80 	


Thank you for your order!

Our chefs are getting your food ready. It will be on its way shortly.

Your order ID is 1704126031180.






- Analisando via F12
https://bam.nr-data.net/jserrors/1/ab57e54f93?a=1048662011&sa=1&v=1223.PROD&t=Unnamed%20Transaction&rst=358933&ck=0&s=5eec82b5500bc0e9&ref=http://foodme.nru.to:8080/
https://bam.nr-data.net/jserrors/1/ab57e54f93?a=1048662011&sa=1&v=1223.PROD&t=Unnamed%20Transaction&rst=358933&ck=0&s=5eec82b5500bc0e9&ref=http://foodme.nru.to:8080/


- Analisando via F12, é possível verificar que existe um código Javascript do NewRelic, que contem o "NREUM", que é o "New Relic User Monitoring".

~~~~javascript
  ;window.NREUM||(NREUM={});NREUM.init={distributed_tracing:{enabled:true},privacy:{cookies_enabled:true},ajax:{deny_list:["bam.nr-data.net"]}};
~~~~





## LAB - GENERATING DATA

1. Acessar http://foodme.nru.to:8080/#/customer e fazer um pedido.
2. Checar o código fonte e identificar o NREUM.
3. Acessar algum site qualquer e checar se ele usa o New Relic também.





https://www.boticario.com.br/
tem o NREUM






## Check your knowledge

 If you view the source of a webpage and see a script tag with the string `NREUM`, you know that the site is instrumented with the New Relic __________ agent

Browser
Correctly selected

APM
Correctly unselected

Infrastructure
Correctly unselected

Mobile
Correctly unselected

OpenTelemetry
Correctly unselected

Correct

The New Relic Browser agent is a simple line of JavaScript code that can be injected into the head of any website.



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# RESUMO

- Logar via Firefox mesmo:
        http://foodme.nru.to:8080/#/customer
<http://foodme.nru.to:8080/#/customer>

- Abrir em outro navegador, logado na conta Training do NewRelic:
    https://onenr.io/07j9ab9lAjO
<https://onenr.io/07j9ab9lAjO>


- Analisando via F12, é possível verificar que existe um código Javascript do NewRelic, que contem o "NREUM", que é o "New Relic User Monitoring".