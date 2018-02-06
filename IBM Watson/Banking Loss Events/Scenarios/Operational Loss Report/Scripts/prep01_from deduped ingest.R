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
input.file <- "data02_deduped ingest.rds"

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

## Raw ####

library(dplyr)
library(lubridate)
library(XLConnect)

source("./paths.R")

## Reference datasets
freq.df <- data.frame(
	Business = c(
		"Agency Services", "Asset Management", "Commercial Banking",
		"Corporate Finance", "Retail Banking", "Retail Brokerage", "Trading and Sales"
	),
	Freq = c(
		"Annual", "Annual", "Quarterly", 
		"Semi-Annual", "Monthly", "Semi-Annual", "Quarterly"
	),
	stringsAsFactors = FALSE
)

risk.df <- raw.df %>% 
	distinct(`Risk Category`, `Risk Sub-Category`) %>% 
	arrange(`Risk Category`, `Risk Sub-Category`)

ref.file <- "ref00_freq and cats.RData"
ref.path <- file.path(case.path, "Data", ref.file)
save(freq.df, risk.df, file = ref.path)
ref.loc <- file.path(paths.ls$datastage.prod, ref.file)
drive_upload(ref.path, ref.loc)

## Simulated Raw files

loss.df <- raw.df %>% 
	left_join(freq.df) %>% 
	mutate(
		Report.period = periodTitle(`Occurrence Start Date`, Freq)
	)

dump.path <- file.path(case.path, "Data", "case_raw")
dir.create(dump.path)

### Create directories
biz.names <- loss.df$Business %>% unique()
lapply(
	biz.names,
	function(temp.biz){# Create folder for each business unit
		# temp.biz <- "Retail Banking"
		biz.path <- file.path(dump.path, temp.biz)
		dir.create(biz.path)
		
		biz.df <- loss.df %>% filter(Business == temp.biz)
		
		region.names <- unique(biz.df$Region)
		lapply(
			region.names,
			function(temp.region){
				# temp.region <- "Asia Pac"
				
				region.df <- biz.df %>% filter(Region == temp.region)
				region.path <- file.path(biz.path, temp.region)
				dir.create(region.path)
				
				period.names <- unique(region.df$Report.period)
				
				lapply(
					period.names,
					function(temp.period){
						# temp.period <- "CY 2014 M11"
						
						period.df <- region.df %>% 
							filter(Report.period == temp.period) %>% 
							select(-Report.period, -Freq)
						
						risk.cats <- unique(period.df$`Risk Category`)
						perCat.ls <- lapply(
							risk.cats,
							function(temp.risk){
								temp.df <- period.df %>% 
									filter(`Risk Category` == temp.risk) %>% 
									arrange(`Discovery Date`)
								return(temp.df)
							}
						)# per category
						names(perCat.ls) <- risk.cats %>% 
							# Max 31 length for sheet name
							str_replace_all(c("[[:punct:]]" = "")) %>% abbreviate(30)
						
						## Create report
						report.name <- paste0("oprdataq_", temp.biz, "_", temp.region, "_", temp.period, ".xlsx")
						report.xl <- loadWorkbook(file.path(region.path, report.name), create = TRUE)
						
						## Create consolidated sheet
						createSheet(report.xl, "Conso")
						writeWorksheet(report.xl, period.df, "Conso")
						
						## Create categories sheet
						createSheet(report.xl, "Risk Categories")
						writeWorksheet(report.xl, risk.df, "Risk Categories")
						
						## Create indiv sheets
						createSheet(report.xl, names(perCat.ls))
						writeWorksheet(report.xl, perCat.ls, names(perCat.ls))
						
						## Save xlsx
						saveWorkbook(report.xl)
						
					}
				)# per period
			}
		)# per region
	}
)# per business unit

### upload raw files

library(purrr)

case.file <- paste0("case_", case.dir)
raw.zip <- paste(case.file, "raw files", sep = "_")
raw.path <- file.path(paths.ls$datastage.prod, raw.zip)
drive_mkdir(raw.path) ### Create "zip file" in dump://

bu.names <- dir(dump.path)
lapply(
	bu.names,
	function(temp.bu){
		# temp.bu <- bu.names[1]
		bu.local <- file.path(dump.path, temp.bu)
		bu.prod <- file.path(raw.path, temp.bu)# %>% drive_mkdir()
		drive_mkdir(bu.prod)
		
		reg.names <- dir(bu.local)
		lapply(
			reg.names,
			function(temp.reg){
				# temp.reg <- reg.names[1]
				reg.local <- file.path(bu.local, temp.reg)
				reg.prod <- file.path(bu.prod, temp.reg) %>% drive_mkdir()
				
				## Upload each file for current CY
				list.files(reg.local, full.names = TRUE, recursive = FALSE) %>% 
					map(drive_upload, reg.prod) # googledrive.tidyverse.org/articles/articles/multiple-files.html
			}
		)# per region
	}
)# per biz

# Per year ####

library(dplyr)
library(lubridate)
library(XLConnect)

## Simulated Raw files

dump.path <- file.path(case.path, "Data", "case_year")
dir.create(dump.path)

year.names <- raw.df$`Occurrence Start Date` %>% year() %>% unique()
lapply(
	year.names,
	function(temp.year){# Create folder for each year
		# temp.year <- 2014
		year.path <- temp.year %>% paste0("CY", .) %>% file.path(dump.path, .)
		# dir.create(year.path)
		
		year.df <- raw.df %>% 
			filter(year(`Occurrence Start Date`) == temp.year) %>% 
			arrange(`Occurrence Start Date`)
		
		year.xl <- year.path %>% 
			paste0(".xlsx") %>% 
			loadWorkbook(create = TRUE)
		
		createSheet(year.xl, "Bankwide")
		writeWorksheet(year.xl, year.df, "Bankwide")
		saveWorkbook(year.xl)
		cat("Done with", temp.year, "\n")
	}
)# for all years

### Upload per year

library(purrr)

case.file <- paste0("case_", case.dir)
raw.zip <- paste(case.file, "annual conso", sep = "_")
raw.path <- file.path(paths.ls$datastage.prod, raw.zip)
drive_mkdir(raw.path) ### Create "zip file" in dump://

# googledrive.tidyverse.org/articles/articles/multiple-files.html
list.files(dump.path, full.names = TRUE, recursive = FALSE) %>% 
	map(drive_upload, path = paste0(raw.path, "/")) # path needs to end with "/"
