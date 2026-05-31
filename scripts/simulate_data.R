library(tidyverse)
library(faux)

options(readr.show_col_types = FALSE)

simulate_data <- function(data, seed = 8675309, shrinkage = 0.85, n = 200) {
  set.seed(seed)
  
  factors_data <- data |>
    mutate(across(everything(), ~replace_na(.x, 4)))
  
  raw_cor <- cor(factors_data, method = 'spearman', use = "pairwise.complete.obs")
  xcors <- raw_cor |> 
    as_tibble(rownames = "item") |>
    pivot_longer(-item, names_to = "item2", values_to = "r") |>
    filter(item < item2) |>
    mutate(shrink = ifelse(r < 0, -1, 1) * abs(r) * shrinkage)|>
    arrange(item, item2)
  
  item_names <- unique(c(xcors$item, xcors$item2))
  
  simdata <- sim_design(
    n = n, 
    within = list(item = item_names),
    r = xcors$shrink,
    sep = "~",
    plot = FALSE,
    long = TRUE
  ) |>
    mutate(likert = norm2likert(y, c(1, 2, 2, 3, 2, 3, 1), labels = 1:7)) |>
    separate(item, c("scale", "scale_n"), remove = FALSE)
  
  simdata |>
    select(id, item, likert) |>
    pivot_wider(names_from = item, values_from = likert)
}