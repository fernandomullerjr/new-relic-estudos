
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 2 - The New Relic Explorer"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# The New Relic Explorer


Quantidade de serviços Backend com a palavra "service" no nome
28


Web response time > 0.5 for at least 5 minutes on 'Plan Service'


Os cinzas, filtrei:
nr.sliComplianceCategory
=
Non-compliant





Maior Throughput
FoodMe + Custom Attributes


host usando mais CPU
ip-172-31-25-13






# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# CORREÇÃO

- Filtrar pela palavra "service", mas usar o filtro AND e IN, para dizer que quer procurar por "Services - APM" e "Services - OpenTelemetry".

- Cinzas são aquelas entidades que não tem alertas configurados.








In the navigator view below, we can see that one entity is in grey. This indicates that this entity...

has no alert conditions set up.
Correctly selected

is violating a critical alert condition.
Correctly unselected

is violating a warning alert condition.
Correctly unselected

is not violating any configured alerts related to it.
Correctly unselected

Correct




True or False: The lookout view below is telling us that ip-172-31-20-188 is encountering an error.

True
Correctly unselected

False
Correctly selected

Correct

This view is telling us that CPU usage has recently spiked on the host ip-172-31-20-188. However, this does not inherently mean something is wrong with that host. It is likely something you want to inspect but the spike could be manageable and/or expected.