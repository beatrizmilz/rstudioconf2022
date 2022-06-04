# Buscar para:
# https://github.com/tidyverse
# https://github.com/r-lib
# https://github.com/mlverse
# https://github.com/tidymodels
# https://github.com/rstudio
# https://github.com/quarto-dev



find_repos_github_org <- function(organisation){

  # get info about the org
  gh_org <- gh::gh("GET /orgs/{org}",
                         org = organisation)

  number_of_public_repos <- gh_org$public_repos


  pages_to_iterate <- ceiling(number_of_public_repos/100)


  repos_org_list <- purrr::map(1:pages_to_iterate,
                             .f = ~gh::gh(
                               "GET /orgs/{org}/repos",
                               org = organisation,
                               type = "public",
                               sort = "updated",
                               per_page = 100,
                               page = .x
                             ))

 repos_org_df <- repos_org_list  |>
    purrr::flatten() |>
    purrr::map(unlist, recursive = TRUE)  |>
    purrr::map_dfr(tibble::enframe, .id = "id_repo") |>
    tidyr::pivot_wider() |>
    janitor::clean_names()
}

rstudio_orgs <- c("rstudio", "tidyverse", "r-lib", "mlverse", "tidymodels", "quarto-dev")

rstudio_repositories <- rstudio_orgs |>
  purrr::map_dfr(find_repos_github_org)

original_rstudio_repos <- rstudio_repositories |>
  dplyr::filter(fork == FALSE)

get_repo_github_actions <- function(repo_full_name){

  workflows_list <- purrr::map(repo_full_name,
                                    .f = ~gh::gh(
                                      "GET /repos/{full_name}/actions/workflows",
                                      full_name = .x
                                    ))

  workflows_df <- workflows_list |>
    purrr::map("workflows") |>
    purrr::compact() |>
    purrr::modify_depth(2, tibble::as_tibble) |>
    purrr::map_dfr(dplyr::bind_rows, .id = "id_repo")

  workflows_df
}

rstudio_actions <- get_repo_github_actions(original_rstudio_repos$full_name)



# viz - creating of actions on repositories
library(ggplot2)
rstudio_actions |>
  dplyr::filter(state == "active") |>
  dplyr::mutate(created_at = lubridate::as_date(created_at),
    created_month = lubridate::floor_date(created_at, "month")) |>
  dplyr::count(created_at) |>
  dplyr::mutate(n_acumulated = cumsum(n)) |>
  ggplot() +
  geom_step(aes(x = created_at, y = n))



