## Planejamento da palestra

- TODO: Blogpost about GHA in RStudio

Título da palestra: Making awesome automations with Github Actions

Tempo: 4 min 45 s.

- Quem é meu público alvo?

As pessoas que vão participar da RStudio Conf são pessoas que, no geral, já tem contato com a linguagem de programação R. Porém, com níveis de experiências diferentes. Parte das pessoas são as pessoas especialistas, que já criam e mantém pacotes, etc. Outra parte são pessoas que utilizam R em seus trabalhos e estão lá para aprender mais sobre as  aplicações possíveis. Esse é o grupo que eu pretendo atingir mais.




Ideia de roteiro:

- slide de abertura: Hi everyone! It's a great honor to be here to present this talk. Today I'm going to talk about how to make awesome automations with GitHub Actions.

- Slide de apresentação sobre mim: First,  my name is Beatriz, I am an R-Lady from Brazil, and I really like to automate repetitive tasks.


- So, i'm going to ask a question and would be really nice if you could raise your hand if this applies to you:  do you have to do a task using R in a regular basis? like every day, once a week, once a month, for example?

(WAIT SOME SECONDS SO PEOPLE CAN THINK AND RAISE THEIR HANDS)

- If you raised your hand, GitHub Actions can be usefull to you, and Today my aim is to answer this question: "What is GitHub Actions? How can I run R Scripts with it?"


- TODO: resumo do que é gha.

- So, Actions is a service from GitHub that allows automate 


- GitHub Actions has been heavily used in some contexts, like runing checks in packages.  Package developers can easily start using  with the help of package usethis!

- Graph of RStudio uses of actions.. The tidyverse packages all use it, and.


- But what about people that are not package developers? What can be done apart from package development tasks? 


- This are some of the things that you can do with Actions:

  - Run a regular R Script and save the results (on the repository, in a database, or on a Google sheet..)

  - Scrape data from the internet
  
  - Run Rmarkdown reports
  
  - Send emails with the results
  
  - And so on!


  

- How you can start doing that?

- First, we need a GitHub Account! 

- Then, we need a repository!


- To show this example, I prepared a repository that stores the files that we need. You can click on fork if you want, so GitHub creates a copy of the repository in your account, and you can edit it after.

- Next, we need an R script with the code that we want to be executed. Imagine that you are in a brand new R installation, so you have to start your script installing all the packages you need in your script. Take your time to write a script that is fully reproducible!


- Last, we need a file to store the GitHub Actions workflow. Usually we copy and paste from another script and adapt it.

- FALTA POUCO! CONCLUIR









