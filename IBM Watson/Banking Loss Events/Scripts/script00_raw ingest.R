data.source <- "IBM Watson"
data.set <- "Banking Loss Events"

library(googledrive)
drive_auth() # Select Google Account to use

# Set paths ####

source("./paths.R") # Path to Dump
repo.path <- file.path(".", data.source, data.set) # Path to local working directory
dataset.path <- file.path(data.stage, data.source, data.set) # Path to dump

## Dir for temp data
data.path <- file.path(repo.path, "Data") # data dump in local working directory
cache.path <- file.path(dataset.path, "data") # path to processed data in dump

paths.ls <- list(
	local = repo.path, prod = dataset.path,
	datastage.local = data.path, datastage.prod = cache.path
)
saveRDS(paths.ls, file.path(repo.path, "Scripts", "paths.rds"))

# Get raw files ####

## List extant data files
(dataset.files <- file.path(paths.ls$prod, "raw") %>% drive_ls())

## Download input data file
dataset.file <- file.path(paths.ls$prod, "raw") %>% 
	## Select file for download
	file.path("WA_Fn-UseC_-Banking-Loss-Events-2007-14.xlsx") %>% 
	drive_get()
dataset.id <- as_id(dataset.file) ## Get ID for download
raw.path <- file.path(paths.ls$datastage.local, dataset.file$name) ## Set destination path for download
drive_download(dataset.id, path = raw.path, overwrite = TRUE) ## Download raw data file

# Parse raw files ####

library(readxl)

excel_sheets(raw.path) ## Only one sheet

## Raw ingest
loss.raw <- read_excel(raw.path, sheet = excel_sheets(raw.path))

### Create local file
data00.file <- "data00_raw ingest.rds"
data00.path <- file.path(data.path, data00.file)

loss.raw %>% saveRDS(data00.path)

### Upload to dump
dump00.path <- file.path(cache.path, data00.file)
drive_upload(data00.path, dump00.path)
