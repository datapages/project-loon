library(redivis)

query <- "
{{query}}
"

workflow <- redivis$user("briangre")$workflow("project_loon")
df <- workflow$query(query)$to_tibble()