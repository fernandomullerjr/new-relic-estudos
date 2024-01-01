
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


