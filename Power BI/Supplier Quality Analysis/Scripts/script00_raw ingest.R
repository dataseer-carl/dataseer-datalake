# Initialise paths ################################################
# Copy paste at beginning of every R script
# Edit as appropriate

author.name <- "Power BI"
data.source <- "Supplier Quality Analysis"

## Path to local (proxy for repo://)
cache.path <- file.path(".", author.name, data.source, "Data")

## Path to data://
data.path <- file.path("~/Data/DataLake", author.name, data.source)
stage.path <- file.path(data.path, "data")
raw.path <- file.path(data.path, "raw")

library(googledrive)
drive_auth()

#*****************************************************************#

# Download raw ####

library(magrittr)

## List extant data files
(dataset.files <- raw.path %>% drive_ls())

## Download input data file
dataset.file <- raw.path %>% 
	file.path("Supplier Quality Analysis.xlsx") %>% ## Select file for download
	drive_get()
dataset.id <- as_id(dataset.file) ## Get ID for download
dataset.path <- file.path(cache.path, dataset.file$name) # Assumes nrow = 1
drive_download(dataset.id, path = dataset.path, overwrite = TRUE) ## Download raw data file

# Parse ####

library(readxl)

## Raw ingest
sheets.ls <- excel_sheets(dataset.path)
raw.ls <- lapply(
	sheets.ls,
	function(temp.sheet){
		temp.df <- read_excel(dataset.path, sheet = temp.sheet)
	}
)
names(raw.ls) <- sheets.ls

### Create local file
data00.file <- "data00_raw ingest.rds"
data00.path <- file.path(cache.path, data00.file)
raw.ls %>% saveRDS(data00.path)

### Upload to dump
drive_upload(data00.path, paste0(stage.path, "/"))
# Update readme.md