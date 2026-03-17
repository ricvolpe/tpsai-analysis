load_data <- function(file_path) {
  
  # Read headers and build clean column names (e.g. TR_1 to TR_01 for ordering)
  raw_data  <- read_csv(file_path, n_max = 2)
  colnames  <- names(raw_data) |> gsub("_(\\d)$", "_0\\1", x = _)
  
  # Extract question labels from row 1
  question_labels <- setNames(
    sub(".* - ", "", as.character(raw_data[1, ])),
    colnames
  )
  
  # Re-read with clean column names, skipping metadata rows
  raw_data <- read_csv(file_path, col_names = colnames, skip = 3)
  
  # Column groups
  cols_trust    <- sprintf("TR_%02d", 1:22)
  cols_distrust <- sprintf("DT_%02d", 1:14)
  cols_company  <- sprintf("CD_%02d", 1:7)
  cols_tpsai    <- c(cols_trust, cols_distrust, cols_company)
  
  likert_levels <- c(
    "Strongly disagree"          = 1,
    "Disagree"                   = 2,
    "Neither agree nor disagree" = 3,
    "Agree"                      = 4,
    "Strongly agree"             = 5,
    "Don't know"                 = NA
  )
  
  qid_label_map <- question_labels[cols_tpsai]
  qid_label_df  <- tibble(id = names(qid_label_map), text = qid_label_map)
  
  items_data <- raw_data |>
    mutate(across(all_of(cols_tpsai), ~ likert_levels[.x]))
  
  # Return everything needed downstream as a named list
  list(
    raw_data      = raw_data,
    items_data    = items_data,
    qid_label_df  = qid_label_df,
    cols_trust    = cols_trust,
    cols_distrust = cols_distrust,
    cols_company  = cols_company,
    cols_tpsai    = cols_tpsai,
    likert_levels = likert_levels
  )
}