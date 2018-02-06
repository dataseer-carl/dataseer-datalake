data.source <- "IBM Watson"
data.set <- "HR Employee Attrition"

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

## display raw data files
(dataset.files <- drive_ls(file.path(paths.ls$prod, "raw")))

## Get ID for download
dataset.id <- as_id(dataset.files) ## Only one data file

## Set destination path for download
raw.path <- file.path(paths.ls$datastage.local, dataset.files$name)

## Download raw data file
drive_download(dataset.id, path = raw.path, overwrite = TRUE)

# Parse raw files ####

library(readr)

hr.raw <- read_csv(raw.path)

### Create local file
data00.file <- "data00_raw ingest.rds"
data00.path <- file.path(data.path, data00.file)

hr.raw %>% saveRDS(data00.path)

### Upload to dump
dump00.path <- file.path(cache.path, data00.file)
drive_upload(data00.path, dump00.path)

