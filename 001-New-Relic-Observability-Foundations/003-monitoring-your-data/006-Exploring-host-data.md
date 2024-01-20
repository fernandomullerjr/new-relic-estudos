
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 6 - Exploring host data"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  Exploring host data

- Acessar o New Relic com a conta readonly.
mudar para account "NRU Demotron"


- É possível verificar no APM do "WebPortal" uma seção sobre infra chamada "Infrastructure".
Clicando nela é possível ver detalhes dos hosts atrelados ao serviço APM do  "WebPortal".
Também é possível verificar outras aplicações que são atendidas por este mesmo host.



