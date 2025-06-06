library(redivis)

query <- "
{{query}}
"

workflow <- redivis$user("mikabr")$workflow("project_loon")
df <- workflow$query()$to_tibble(max_results = 100) # remove max as needed