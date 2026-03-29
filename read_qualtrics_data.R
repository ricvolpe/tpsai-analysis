load_data <- function(file_path, factors_path) {
  
  raw_data  <- read_csv(file_path, n_max = 2)
  colnames  <- names(raw_data)
  q_text    <- setNames(sub(".* - ", "", as.character(raw_data[1, ])), colnames)
  raw_data  <- read_csv(file_path, col_names = colnames, skip = 3)
  
  # survey is designed as two choice matrix one containing odd item IDs
  # one containing even item IDs, displayed at random within each matrix
  # so item ordering is COMP_01, COMP_03, COMP_05, etc.
  survey_cols <- c(rbind(paste0("OD_", 1:20), paste0("EV_", 1:20)))
  
  factors_map <- read_csv(factors_path)
  item_ids <- factors_map$IID
  
  q_text_items <- q_text[survey_cols]
  names(q_text_items) <- item_ids
  
  verification <- data.frame(
    survey_col  = survey_cols,
    survey_q    = unname(q_text[survey_cols]),
    IID         = item_ids,
    factor_item = factors_map$Item[!is.na(factors_map$IID)]
  ) %>%
    mutate(match = survey_q == factor_item)
  
  mismatches <- filter(verification, !match)
  
  if (nrow(mismatches) > 0) {
    warning(sprintf("%d item(s) do not match between survey and factors map", nrow(mismatches)))
    print(mismatches)
  }
  
  likert_levels <- c(
    "Strongly disagree"          = 1,
    "Disagree"                   = 2,
    "Somewhat disagree"          = 3,
    "Neither agree nor disagree" = 4,
    "Somewhat agree"             = 5,
    "Agree"                      = 6,
    "Strongly agree"             = 7,
    "Don't know"                 = NA
  )
  
  items_data <- raw_data |>
    rename_with(~ item_ids, all_of(survey_cols)) |>
    mutate(across(all_of(item_ids), ~ likert_levels[.x])) |>
    select(all_of(item_ids))
  
  list(
    raw_data      = raw_data,
    items_data    = items_data,
    factors_map   = factors_map,
    item_ids    = item_ids,
    likert_levels = likert_levels
  )
}