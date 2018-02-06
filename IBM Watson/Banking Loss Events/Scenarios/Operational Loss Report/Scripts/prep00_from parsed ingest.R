library(magrittr)

# Paths ####

data.source <- "IBM Watson"
data.set <- "Banking Loss Events"
case.dir <- "Operational Loss Report"

paths.ls <- file.path(".", data.source, data.set, "Scripts", "paths.rds") %>% readRDS()

## Initialise case.path for scenario
case.path <- file.path(paths.ls$local, "Scenarios", case.dir)

# Get inputs ####

library(googledrive)

### List extant data files
(dataset.files <- file.path(paths.ls$prod, "data") %>% drive_ls())

#### parsed ingest
input.file <- "data01_parsed ingest.rds"

##### download
dataset.file <- file.path(paths.ls$prod, "data") %>% 
	file.path(input.file) %>% 
	drive_get() ## Isolate entry
dataset.id <- as_id(dataset.file) ## Get ID for download
raw.path <- file.path(case.path, "Data", dataset.file$name) ## Set destination path for download
drive_download(dataset.id, path = raw.path, overwrite = TRUE) ## Download raw data file

##### load
raw.df <- file.path(raw.path) %>% readRDS()

# Fabricate ####

library(dplyr)
library(lubridate)
library(XLConnect)

## Simulated Raw files

dump.path <- file.path(case.path, "Data", "case_raw")
dir.create(dump.path)

year.names <- raw.df$`Occurrence Start Date` %>% year() %>% unique()

lapply(
	year.names,
	function(temp.year){# Create folder for each year
		# temp.year <- 2014
		year.path <- temp.year %>% paste0("CY", .) %>% file.path(dump.path, .)
		dir.create(year.path)
		
		year.df <- raw.df %>% filter(year(`Occurrence Start Date`) == temp.year)
		
		biz.names <- unique(year.df$Business)
		lapply( # Create xlsx-file per biz line
			biz.names,
			function(temp.biz){
				# temp.biz <- "Retail Banking"
				biz.df <- year.df %>% filter(Business == temp.biz)
				
				biz.xl <- year.path %>% 
					file.path(paste0(temp.biz, ".xlsx")) %>% 
					loadWorkbook(create = TRUE)
				
				region.names <- unique(biz.df$Region)
				region.ls <- lapply(
					region.names,
					function(temp.region){
						# temp.region <- "Asia Pac"
						region.df <- biz.df %>% filter(Region == temp.region)
						return(region.df)
					}
				)# for all regions
				names(region.ls) <- region.names
				
				createSheet(biz.xl, names(region.ls))
				writeWorksheet(biz.xl, region.ls, names(region.ls))
				saveWorkbook(biz.xl)
				invisible(temp.biz)
				cat("Done with", temp.year, temp.biz, "\n")
			}
		)# for all biz
	}
)# for all years

### upload raw files

library(purrr)

case.file <- paste0("case_", case.dir)

raw.zip <- paste(case.file, "raw std files", sep = "_")
raw.path <- file.path(paths.ls$datastage.prod, raw.zip)
drive_mkdir(raw.path) ### Create "zip file" in dump://

cy.names <- dir(dump.path)
lapply(
	cy.names,
	function(temp.cy){
		# temp.cy <- cy.names[1]
		cy.local <- file.path(dump.path, temp.cy)
		cy.prod <- file.path(raw.path, temp.cy) %>% drive_mkdir()
		
		## Upload each file for current CY
		list.files(cy.local, full.names = TRUE, recursive = FALSE) %>% 
			map(drive_upload, cy.prod) # googledrive.tidyverse.org/articles/articles/multiple-files.html
	}
)## Upload raw std setup

# Store devised raw data ####

# library(googledrive)

## RData ####

### Create local file

cache.file <- paste0(case.file, ".RData")
cache.path <- file.path(case.path, "Data", cache.file)
save(satisfaction.df, employee.df, performance.df, file = cache.path)

### Upload to dump
dump.path <- file.path(paths.ls$datastage.prod, cache.file)
drive_upload(cache.path, dump.path)

## csv ####

### Fashion raw data files
stage.path <- file.path(paths.ls$datastage.prod, case.file)
drive_mkdir(stage.path)

staged.ls <- list(
	"Satisfaction survey" = satisfaction.df,
	"Employee records" = employee.df,
	"Performance rating survey" = performance.df
)

#### Upload each
lapply(
	as.list(names(staged.ls)),
	function(temp.name){
		temp.df <- staged.ls[[temp.name]]
		file.name <- paste0(temp.name, ".csv")
		out.path <- file.path(case.path, "Data", file.name)
		write.csv(temp.df, out.path, row.names = FALSE)
		dump.path  <- file.path(stage.path, file.name)
		drive_upload(out.path, dump.path)
	}
)

## xlsx ####

library(XLConnect)

### Create workbook

xlsx.file <- paste0(case.file, ".xlsx")
xlsx.path <- file.path(case.path, "Data", xlsx.file)

out.xl <- loadWorkbook(xlsx.path, create = TRUE)
createSheet(out.xl, names(staged.ls))
writeWorksheet(out.xl, staged.ls, names(staged.ls))
saveWorkbook(out.xl)

### Upload workbook

store.path <- file.path(paths.ls$datastage.prod, xlsx.file)
drive_upload(xlsx.path, store.path)
