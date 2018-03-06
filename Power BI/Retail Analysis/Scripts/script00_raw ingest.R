# Initialise paths ################################################
# Copy paste at beginning of every R script
# Edit as appropriate

datalake.id <- "1IQXPXMZSEK4QK_gKK2ERp9pOs4wJ_dog" # ID of Datalake folder
datalake <- drive_get(as_id(datalake.id)) # Get file directory of Datalake folder
datalake.files <- drive_ls(datalake)

author.name <- "Power BI" # Author of dataset
author.name.id <- datalake.files %>% filter(name == author.name) %>% use_series(id) # Get folder ID of author
author.folder <- drive_get(as_id(author.name.id)) # Get file directory of author folder
author.files <- drive_ls(author.folder) 

data.source <- "Retail Analysis" # Dataset folder
datasource.id <- author.files %>% filter(name == data.source) %>% use_series(id)  # Get folder ID of dataset
datasource.folder <- drive_get(as_id(datasource.id)) # Get file directory of dataset folder
datasource.files <- drive_ls(datasource.folder) 

raw.folder <- "raw" # Raw folder
raw.id <- datasource.files %>% filter(name == raw.folder) %>% use_series(id) # Get folder ID of raw
raw.folder <- drive_get(as_id(raw.id))
raw.files <- drive_ls(raw.folder) 

data.folder <- "data" # Data folder
data.id <- datasource.files %>% filter(name == data.folder) %>% use_series(id) # Get folder ID of raw
data.folder <- drive_get(as_id(data.id))
data.files <- drive_ls(data.folder) 

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

# Sales.csv ####

## Download input data file
filename <- "Sales.csv"
file.id <- raw.files %>% filter(name == filename) %>% use_series(id) 
dataset.path <- file.path(cache.path, filename)
drive_download(as_id(file.id), path = dataset.path, overwrite = TRUE)

## Read in

library(readr)

 system.time({sales.raw <- read_csv(dataset.path, locale = locale(encoding = "ASCII"))})
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
lookup.file <- "Retail Analysis.xlsx" ## Select file for download
lookup.id <- raw.files %>% filter(name == lookup.file) %>% use_series(id) 
lookup.path <- file.path(cache.path, lookup.file)
drive_download(as_id(lookup.id), path = lookup.path, overwrite = TRUE) ## Download raw data file

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

parsed.path <- file.path(cache.path, "data00u_raw ingest.RData")
save(sales.raw, lookup.ls, file = parsed.path)
drive_upload(parsed.path, as_id(data.id))
