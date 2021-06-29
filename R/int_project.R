#' Initialize Project
#'
#' Create a initial project structure
#'
#' Creates a project structure in the GOI style. Creates a basic, modelling, Teradata
#' or EMS project, or creates a custom one from a custom_structure list.
#' If a custom structure is needed, you must pass a list with the following elements:
#' files - a string of filenames to create
#' folders - a string of folders to create
#' packages - a string of packages to insert in the first file
#' additional changes - a list, containing two elements:
#' files - a list of files to add elements to
#' text - a string, with the corresponding text to add to each file.
#' @param type the kind of project to create - basic, teradata, EMS, or a custom project
#' @param custom_structure a list with the custom structure, if used.
#' @param additional_packages a string, with additional packages to load along with the template, if any.
#' @export
#' @examples
#' \dontrun{
#' init_project("basic")
#' }
#' @return
#' This function is only used for its side effects

init_project <- function(type = c("basic", "modelling", "teradata", "ems", "ems-ts", "custom"), custom_structure = NA, additional_packages = NA) {
  # internally define the basic structures
  basic_structure <- list(
    files = c("00 Functions.R", "01 Ingestion.R", "02 Transformation.R", "03 Output.R"),
    folders = c("Input-Data", "Output-Files"),
    packages = c("tidyverse", "lubridate", "janitor"),
    additional_changes = list(
      file = c("02 Transformation.R",
               "03 Output.R"),
      text = c('clean <- raw',
               'write_excel_csv(clean, "Output-Files/output.csv")')
    )
  )

  modelling_structure <- list(
    files = c("00 Functions.R", "01 Ingestion.R", "02 Transformation.R", "03 Modelling.R", "04 Output.R"),
    folders = c("Input-Data", "Output-Files"),
    packages = c("tidyverse", "lubridate", "janitor"),
    additional_changes = list(
      file = c("02 Transformation.R",
               "04 Output.R"),
      text = c('clean <- raw',
               'write_excel_csv(clean, "Output-Files/output.csv")')
    )
  )

  teradata_structure <- list(
    files = c("00 Functions.R", "01 Ingestion.R", "02 Transformation.R", "03 Output.R"),
    folders = c("Input-Data", "Output-Files"),
    packages = c("tidyverse", "lubridate", "janitor", "odbc"),
    additional_changes = list(
      file = c("01 Ingestion.R",
               "02 Transformation.R",
               "03 Output.R"),
      text = c('td_con <- dbConnect(odbc::odbc(), "P", timeout = 10)',
               'clean <- raw',
               'write_excel_csv(clean, "Output-Files/output.csv")'
               )
    )
  )

  ems_structure <- list(
    files = c("00 Functions.R", "01 Ingestion.R", "02 Transformation.R", "03 Output.R"),
    folders = c("Input-Data", "Output-Files"),
    packages = c("Rems", "qEmsTools", "tidyverse", "lubridate", "janitor", "odbc"),
    additional_changes = list(
      file = c("01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "02 Transformation.R",
               "03 Output.R"),
      text = c('ems_con <- getEMSCon("user.name")\n\n',
               'base_qry <- Rems::flt_query(conn = ems_con, ems_name = "", data_file = NA)\n\n',
               'db_qry <- base_qry %>% Rems::set_database("FDW") %>% Rems:: generate_preset_fieldtree()\n\n',
               'tree_qry <- db_qry %>% Rems::update_fieldtree("")\n\n',
               'select_qry <- tree_qry %>% Rems::select("flight record", "flight date (exact)", "tail number", "takeoff airport iata code", "landing airport iata code","airframe")\n\n',
               'filter_qry <- select_qry %>% Rems::filter("\'Takeoff Valid\' == TRUE") %>% Rems::filter("\'Landing Valid\' == TRUE")\n\n',
               'raw <- Rems::run(filter_qry)',
               'clean <- raw',
               'write_excel_csv(clean, "Output-Files/output.csv")'
               )
    )
  )

  ems_ts_structure <- list(
    files = c("00 Functions.R", "01 Ingestion.R", "02 Transformation.R", "03 Output.R"),
    folders = c("Input-Data", "Output-Files"),
    packages = c("Rems", "qEmsTools", "tidyverse", "lubridate", "janitor", "odbc"),
    additional_changes = list(
      file = c("01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "01 Ingestion.R",
               "02 Transformation.R",
               "03 Output.R"),
      text = c('ems_con <- getEMSCon("user.name")\n',
               'base_qry <- Rems::flt_query(conn = ems_con, ems_name = "", data_file = NA)\n',
               'db_qry <- base_qry %>% Rems::set_database("FDW") %>% Rems:: generate_preset_fieldtree()\n',
               'tree_qry <- db_qry %>% Rems::update_fieldtree("")\n',
               'select_qry <- tree_qry %>% Rems::select("flight record", "flight date (exact)", "tail number")\n',
               'filter_qry <- select_qry %>% Rems::filter()\n',
               'raw <- Rems::run(filter_qry)\n',
               'ts_qry <- Rems::tseries_query(conn = ems_con, data_file = NA)\n',
               'ts_qry_sel <- ts_qry %>% Rems::select("Best Available Latitude", "Best Available Longitude")\n',
               'ts_out <- Rems::run_multiflts(qry = ts_qry_sel, flight = raw$`Flight Record`, start = NA, end = NA)',
               'clean <- raw',
               'write_excel_csv(clean, "Output-Files/output.csv")'
      )
    )
  )

  # get the structure being used
  type <- match.arg(type, c("basic", "modelling", "teradata", "ems", "ems-ts", "custom"))
  used_structure <- switch(type,
         "basic" = basic_structure,
         "modelling" = modelling_structure,
         "teradata" = teradata_structure,
         "ems" = ems_structure,
         "ems-ts" = ems_ts_structure,
         "custom" = custom_structure)

  # append any additional packages

  if (!is.na(additional_packages)) {
    used_structure$packages <-  c(used_structure$packages, additional_packages)
  }

  # write all files required
    for(k in used_structure$files) {
      file.create(k)
    }
  # write all folders required
    for(k in used_structure$folders) {
      dir.create(k)
    }

    packages <- paste0("library(", used_structure$packages, ")")
    package_string <- paste(packages, collapse = "\n")
  # write in the package loading scripts
    con <- file(used_structure$files[1], open = "w")
    cat(package_string, file = con)
    close(con)

  # add in the source elements to tie them together
    for (k in 2:length(used_structure$files)) {
      con <- file(used_structure$files[k], open = "w")
      cat(paste0('source("',used_structure$files[k-1],'")'), file = con)
      close(con)
    }
  # add in additional changes, if needed.
  if(!is.null(used_structure$additional_changes)) {
    for (k in seq_along(used_structure$additional_changes$file)) {
      con <- file(used_structure$additional_changes$file[k], open = "a")
      cat("\n\n", file = con, append = TRUE)
      cat(used_structure$additional_changes$text[k], file = con, append = TRUE)
      close(con)
    }
  }
}
