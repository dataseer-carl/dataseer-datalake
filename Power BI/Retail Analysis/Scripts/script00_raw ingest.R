# Initialise paths ################################################
# Copy paste at beginning of every R script
# Edit as appropriate

library(dplyr)
library(tidyr)
library(magrittr)
library(googledrive)
library(readxl)
drive_auth()

# ID of Datalake folder
datalake.id = "1IQXPXMZSEK4QK_gKK2ERp9pOs4wJ_dog"
datalake <- datalake.id %>% 
	as_id() %>% drive_get() %>% drive_ls 

# Author of dataset
author.name <- "Power BI"
author.folder <- datalake %>% filter(name == author.name) %>% use_series(id)  %>% 
		as_id() %>% drive_get() %>% drive_ls()

# Dataset folder
data.source <- "Retail Analysis" 
datasource.folder <- author.folder %>% filter(name == data.source) %>% use_series(id) %>% 
	as_id() %>% drive_get() %>% drive_ls()


## Path to local (proxy for repo://)
 cache.path <- file.path(".", author.name, data.source, "Data")

## Path to data://
 # Raw folder
 raw.folder <- datasource.folder %>% filter(name == "raw") %>% use_series(id) %>% 
 	as_id() %>% drive_get() %>% drive_ls()
 
 # Data folder
 data.folder.id <- datasource.folder %>% filter(name == "data") %>% use_series(id)
 data.folder <-	as_id(data.folder.id) %>% drive_get() %>% drive_ls()

#*****************************************************************#

# View extant data files ####


# Sales.csv ####

## Download input data file
filename <- "Sales.csv"
file.id <- raw.folder %>% filter(name == filename) %>% use_series(id) 
dataset.path <- file.path(cache.path, filename)
drive_download(as_id(file.id), path = dataset.path, overwrite = TRUE)

## Read in

library(readr)

 #system.time({sales.raw <- read_csv(dataset.path, locale = locale(encoding = "ASCII"))})
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
lookup.id <- raw.folder %>% filter(name == lookup.file) %>% use_series(id) 
lookup.path <- file.path(cache.path, lookup.file)
drive_download(as_id(lookup.id), path = lookup.path, overwrite = TRUE) ## Download raw data file

## Read in


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
drive_upload(parsed.path, as_id(data.folder.id))
