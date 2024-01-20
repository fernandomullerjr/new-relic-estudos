
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 2 - Account registration"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Account registration

## Video Notes and URLs

FoodMe application starter environment(opens in a new tab)(opens in a new tab)(opens in a new tab)
    https://glitch.com/edit/#!/remix/foodme-fy23
    <https://glitch.com/edit/#!/remix/foodme-fy23>


    Sign up for a free account with New Relic(opens in a new tab) - 
    https://newrelic.com/signup
    As mentioned in the video, all tasks in this course can be completed using a free account. However, you may choose to use an existing account if you'd like but please be sure that you have your own child account(opens in a new tab) within your organization if you choose to go this route
    https://docs.newrelic.com/docs/accounts/original-accounts-billing/original-users-roles/parent-child-account-structure/
    <https://docs.newrelic.com/docs/accounts/original-accounts-billing/original-users-roles/parent-child-account-structure/>



<https://docs.newrelic.com/docs/accounts/original-accounts-billing/original-users-roles/parent-child-account-structure/>
License keys for child accounts
In a New Relic organization, your main New Relic account serves as the parent account with its own license key. Each child account has their own individual license key. Each application can use only one license key, so each application can report to only one account.

Create child accounts
To add accounts to your New Relic organization, you must have Pro or Enterprise edition.







glitch.com
<https://glitch.com/>

one.newrelic.com

- Criada conta no Glitch.com
https://glitch.com/dashboard?group=owned&sortColumn=boost&sortDirection=DESC&page=1&showAll=false&filterDomain=



- Copiando o projeto do FoodMe com o link abaixo:
    <https://glitch.com/edit/#!/remix/foodme-fy23>



https://glitch.com/edit/#!/titanium-water-wind?path=README.md%3A1%3A0

FoodMe App — an AngularJS app ready to be instrumented for New Relic APM

FoodMe is a simplified meal ordering app built with AngularJS and node.js backend. New Relic instrumentation code has been placed in the following files: newrelic.js, server/index.js, app/js/services/cart.js.

For a hands-on experience that makes use of this app, consider enrolling the the New Relic University course Instrument and Alert on your apps with APM, Browser, & Synthetics
Creative Commons

This repository has been cloned and edited from: https://github.com/IgorMinar/foodme/



- Preview
https://titanium-water-wind.glitch.me/#/customer
<https://titanium-water-wind.glitch.me/#/customer>



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# RESUMO

- Utilizar a conta free mesmo.
- É interessante criar uma child account, porém só é possível via Pro ou Enterprise, conta free não permite.
- Cada aplicação consegue usar apenas uma license key.
- Ter 1 conta no Glitch e 1 no New Relic.
- Copiar o projeto FoodMe de exemplo para o Glitch.