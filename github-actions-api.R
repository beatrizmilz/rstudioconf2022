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

readr::write_rds(original_rstudio_repos,
                 glue::glue("data/original_rstudio_repos_{Sys.Date()}.Rds"))

# get_repo_github_actions <- function(repo_full_name){
#
#   workflows_list <- gh::gh("GET /repos/{full_name}/actions/workflows",
#                            full_name = repo_full_name)
#
#   workflows_df <- workflows_list |>
#     purrr::pluck("workflows") |>
#     purrr::modify_depth(1, tibble::as_tibble) |>
#     purrr::map_dfr(dplyr::bind_rows, .id = "id_repo") |>
#     dplyr::mutate(repo = repo_full_name, .before = tidyselect::everything())
#
#   workflows_df
# }


# rstudio_actions <- original_rstudio_repos$full_name |>
#   purrr::map_dfr(get_repo_github_actions)




get_repo_github_actions_runs <- function(repo_full_name) {

  usethis::ui_info("Starting with {repo_full_name}...")
  total_count <- gh::gh(
    "GET /repos/{full_name}/actions/runs",
    full_name = repo_full_name,
    per_page = 1
  )$total_count


  pages_to_iterate <- ceiling(total_count/100)

  list_all_runs <- purrr::map_dfr(1:pages_to_iterate,
                 ~ gh::gh(
                   "GET /repos/{full_name}/actions/runs",
                   full_name = repo_full_name,
                   per_page = 100,
                   page = .x
                 ))

  runs_df <- list_all_runs |>
    purrr::pluck("workflow_runs") |>
    purrr::map(purrr::compact) |>
    purrr::map(purrr::discard, ~is.list(.x)) |>
    purrr::map_dfr(tibble::as_tibble, .id = "id") |>
    dplyr::mutate(repo = repo_full_name, .before = tidyselect::everything())


  readr::write_rds(runs_df,
                   glue::glue("data/repos/runs_{ stringr::str_replace(repo_full_name, '/', '_')}_{Sys.Date()}.Rds"))

  usethis::ui_done("Done with {repo_full_name}...")
}


original_rstudio_repos <- readr::read_rds("data/original_rstudio_repos_2022-06-04.Rds")

downloaded_repos_runs <- dir("data/repos/") |>
  stringr::str_remove("runs_") |>
  stringr::str_remove(".Rds") |>
  stringr::str_remove("_2022-06-04")|>
  stringr::str_replace("_", "/")

original_rstudio_repos |>
  dplyr::filter(!full_name %in% downloaded_repos_runs) |>
  dplyr::mutate(created_at = lubridate::as_date(created_at)) |>
  dplyr::arrange(desc(created_at)) |>
  dplyr::pull(full_name) |>
  purrr::walk(get_repo_github_actions_runs)


df_complete_runs <- fs::dir_ls("data/repos/") |>
  purrr::map_dfr(readr::read_rds)

df_complete_runs |>
  readr::write_rds("data/complete_runs_original_rstudio_repos.Rds")

# create graph

df_complete_runs <- readr::read_rds("data/complete_runs_original_rstudio_repos.Rds")

library(ggplot2)
options(scipen=9999)

df_complete_runs |>
  dplyr::count(event, sort = TRUE)

base_data <- df_complete_runs |>
  dplyr::mutate(start_date = lubridate::as_date(run_started_at),
                run_month = lubridate::floor_date(start_date, "month")) |>
  dplyr::filter(conclusion != "skipped", start_date < "2022-06-01") |>
  dplyr::count(run_month)


max_min <- base_data |>
  dplyr::filter(run_month %in% c(min(run_month), max(run_month))) |>
  dplyr::mutate(label = glue::glue("{round(n/1000)}k"))

base_graph <- base_data |>
  ggplot() +
  geom_line(aes(x = run_month, y = n), color = "#80868b", size = 1.5)


final_graph <- base_graph +
  theme_minimal(base_size = 15) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        plot.title.position = "plot",
        plot.title = element_text(family = "Montserrat", color = "#4c83b6"),
        text = element_text(family = "Montserrat", color = "#80868b")) +
  labs(y = "Actions runs per month", x = "",
       title = "Actions runs by RStudio's organizations on GitHub",
       caption = "Plot made by @BeaMilz. Data from the GitHub API.") +
  scale_x_date(date_labels = "%b/%y", date_breaks = "4 month",
               limits = c(as.Date("2020-03-01"), as.Date("2022-06-01"))) +
  scale_y_continuous(limits = c(0, 25000), labels = function(x){glue::glue("{x/1000}k")}) +
  geom_point(data = max_min, aes(x = run_month, y = n), size = 3, color = "#4c83b6") +
  ggrepel::geom_text_repel(data = max_min, aes(x = run_month, y = n, label = label), size = 10, color = "#4c83b6",nudge_y = 4000, nudge_x = 0, min.segment.length = 0)


readr::write_rds(final_graph, "graph.rds")


# ggsave(
#   "img/rstudio_ggplot.png",
#   plot = final_graph,
#   dpi = 300,
#   height = 5,
#   width = 7
# )

