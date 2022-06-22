## Planejamento da palestra

Título da palestra: Making awesome automations with Github Actions

Tempo: 4 min 45 s.

- Quem é meu público alvo?

As pessoas que vão participar da RStudio Conf são pessoas que, no geral, já tem contato com a linguagem de programação R. Porém, com níveis de experiências diferentes. Parte das pessoas são as pessoas especialistas, que já criam e mantém pacotes, etc. Outra parte são pessoas que utilizam R em seus trabalhos e estão lá para aprender mais sobre as  aplicações possíveis. Esse é o grupo que eu pretendo atingir mais.




Ideia de roteiro:

- slide de abertura: Hi everyone! It's a great honor to be here to present this talk. Today I'm going to talk about how to make awesome automations with GitHub Actions.

- Slide de apresentação sobre mim: First,  my name is Beatriz, I am an R-Lady from Brazil, and I really really like to automate repetitive tasks.


- So, i'm going to ask a question and would be really nice if you could raise your hand if this applies to you:  do you have to do a task using R in a regular basis? like every day, once a week, once a month, for example?

(WAIT SOME SECONDS SO PEOPLE CAN THINK AND RAISE THEIR HANDS)

- If you raised your hand, GitHub Actions can be usefull to you, and Today my aim is to answer this question: "What is GitHub Actions? How can I run R Scripts with it?"


- GitHub Actions has been heavily used in some contexts, like runing checks in packages. The tidyverse packages all use it, and package developers can easily start using  with the help of package usethis!


- But what about people that are not package developers? What can be done apart from package development tasks? 


- This are some of the things that you can do with Actions:

  - Scrape data from the internet...

  - ...and save it on the repository, in a database, or on a Google sheet..
  
  - Run Rmarkdown reports
  
  
  - Run a regular R Script and save the results
  
  - Send emails with the results


  

- How you can start doing that?

- First, we need a GitHub Account! You can sign up for free at github.com and there you go.

- Then, we need a repository! If you don't know what a repository is, imagine that you have a folder with all the files that you need in a project and you upload it somewhere, like in Google Drive. The repository is like that, a folder that stores the files of your project.

- To show this example, I prepared this repository that stores the files that we need. You can click on fork if you want, so GitHub creates a copy of the repository in your account, and you can edit it after.

- Next, we need an R script with the code that we want to be executed. Imagine that you are in a brand new R installation, so you have to start your script installing all the packages you need in your script. Take your time to write a script that is fully reproducible!


- Last, we need a file to store the GitHub Actions workflow. Usually we copy and paste from another script and adapt it.

- FALTA POUCO! CONCLUIR




-------
- SÓ DEIXAR SE SOBRAR TEMPO:
- So... Imagine that you have to go to the post office to deliver a mail everyday. Everyday you get to walk in the same path, deliver it and then go back to your house. Everyday! That feels exausthing, right?

- BUT! If you found out about an awesome robot that could take your mail at your house and deliver it at the post office everyday, so you don't need to do it yourself? That would be awesome, right?

- GitHub Actions can be like this awesome robot!








