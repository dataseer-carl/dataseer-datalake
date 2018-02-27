# Initialise paths ################################################
# Copy paste at beginning of every R script
# Edit as appropriate

author.name <- "Power BI"
data.source <- "Retail Analysis"

## Path to local (proxy for repo://)
cache.path <- file.path(".", author.name, data.source, "Data")

## Path to data://
data.path <- file.path("~/Data/DataLake", author.name, data.source)
stage.path <- file.path(data.path, "data")
raw.path <- file.path(data.path, "raw")

library(googledrive)
drive_auth()

#*****************************************************************#

# View extant data files ####

library(magrittr)

(dataset.files <- raw.path %>% drive_ls())

# Sales.csv ####

## Download input data file
dataset.file <- raw.path %>% 
	file.path("Sales.csv") %>% ## Select file for download
	drive_get()
dataset.id <- as_id(dataset.file) ## Get ID for download
dataset.path <- file.path(cache.path, dataset.file$name) # Assumes nrow = 1
drive_download(dataset.id, path = dataset.path, overwrite = TRUE) ## Download raw data file

## Read in

library(readr)

# system.time({sales.raw <- read_csv(dataset.path, locale = locale(encoding = "ASCII"))})
   # user  system elapsed 
   # 0.61    0.08    1.22 
system.time(
	{
		sales.raw <- read.csv(
			dataset.path,
			colClasses = c(
				"character", # MonthID
				"character", # ItemID
				"character", # LocationID
				"numeric", # Sum_GrossMarginAmount
				"numeric", # Sum_Regular_Sales_Dollars
				"numeric", # Sum_Markdown_Sales_Dollars
				"character", # ScenarioID
				"character", # ReportingPeriodID
				"integer", # Sum_Regular_Sales_Units
				"integer" # Sum_Markdown_Sales_Units
			)
		)
	}
)
	## default colClasses
   # user  system elapsed 
   # 3.95    0.08    4.16 
	## specific colClasses
   # user  system elapsed 
   # 3.48    0.08    3.62 

# Retail Analysis.xlsx ####

## Download input data file
lookup.file <- raw.path %>% 
	file.path("Retail Analysis.xlsx") %>% ## Select file for download
	drive_get()
lookup.id <- as_id(lookup.file) ## Get ID for download
lookup.path <- file.path(cache.path, lookup.file$name) # Assumes nrow = 1
drive_download(lookup.id, path = lookup.path, overwrite = TRUE) ## Download raw data file

## Read in

library(readxl)

## Raw ingest
sheets.ls <- excel_sheets(lookup.path)
lookup.ls <- lapply(
	sheets.ls,
	function(temp.sheet){
		temp.df <- read_excel(lookup.path, sheet = temp.sheet)
	}
)
names(lookup.ls) <- sheets.ls

# Save ####

parsed.path <- file.path(cache.path, "data00_raw ingest.RData")
save(sales.raw, lookup.ls, file = parsed.path)
drive_upload(parsed.path, paste0(stage.path, "/"))
