
git status
git add .
git commit -m "aula 1 - Foundations - ."
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status