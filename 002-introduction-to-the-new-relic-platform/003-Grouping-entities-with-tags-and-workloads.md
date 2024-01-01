
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 3 - Grouping entities with tags and workloads"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Grouping entities with tags and workloads

Working with your own data

Unlike the previous lessons in this course, you will not be able to replicate the actions of the instructor in the video using the training account. This is because you only have read-only access to that account. While you follow along with the videos in this lesson, pause the video as needed to complete tasks in your personal/work New Relic account. After completing the video, answer the question below and then move on to the next lesson in this course.






## WORKLOAD

- Ao criar um Workload, é possível agrupar entities.
- Clicando em "Add this query", é possível automatizar quem será adicionado ao Workload.
- Workload é uma forma de agrupar logicamente as entities.
- Cria uma visualização fácil das entities, service map, etc.







If you were to create a "Tier" tag in your account, which categories of entities should you place in the tag Tier = Infrastructure?

- check all that apply

Hosts
Correctly checked

Browser
Correctly unchecked

APM
Correctly unchecked

Synthetic
Correctly unchecked

    Containers
    Correctly checked


Correct

Although more categories of entities would be appropriate for this tag, only two from this list should be placed in the Infra tier.









If you have several entities in your New Relic account that are all related to the same application, you should consider adding them all to the same ________ to quickly see the status of them all on the same page.

service
Correctly unselected

workload
Correctly selected

tag
Correctly unselected

capability
Correctly unselected

Correct

The correct answer to this question is workload. Although creating a tag to organize the entities described in this question would also support your ability to organize them in one place, it would be considered best practice to create a workload for a grouping of entities that meets this description.