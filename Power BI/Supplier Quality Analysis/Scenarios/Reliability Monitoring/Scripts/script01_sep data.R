# Initialise paths ################################################
# Copy paste at beginning of every R script
# Edit as appropriate

author.name <- "Power BI"
data.source <- "Supplier Quality Analysis"
scenario.name <- "Reliability Monitoring"

## Path to scenario
case.path <- file.path(".", author.name, data.source, "Scenarios", scenario.name)

## Path to local (proxy for repo://)
cache.path <- file.path(".", author.name, data.source, "Data")
# cache.path <- file.path(case.path, "..", "..", "Data")

## Path to data://
data.path <- file.path("~/Data/DataLake", author.name, data.source)
stage.path <- file.path(data.path, "data")
# # raw.path <- file.path(data.path, "raw")

library(googledrive)
drive_auth()

#*****************************************************************#

library(magrittr)
library(dplyr)

data02.file <- "data02_metrics with plant address.RData"

data02.id <- stage.path %>% 
	file.path(data02.file) %>% ## Select file for download
	drive_get() %>% 
	as_id()

data02.path <- file.path(case.path, "Data", data02.file)

drive_download(data02.id, path = data02.path, overwrite = TRUE) ## Download raw data file

## Load cleaned data source
load(data02.path)

## Separate
plant.path <- file.path(case.path, "Data", "Plant Submissions")
dir.create(plant.path)

plant.names <- unique(plant.df$Plant)
plants.ls <- lapply(
	plant.names,
	function(temp.plant){
		temp.df <- metrics.df %>% 
			filter(Plant == temp.plant) %>% 
			select(
				Plant, Category, Date,
				`Material Type`, Vendor,
				`Defect Type`, Defect, `Defect Qty`, `Downtime min`
			)
		temp.path <- file.path(plant.path, paste0(temp.plant, ".tsv"))
		write.table(temp.df, temp.path, sep = "\t", row.names = FALSE)
		return(temp.df)
	}
)
names(plants.ls) <- plant.names

library(writexl)

lookup.path <- file.path(plant.path, "Plant Addresses.xlsx")
write_xlsx(plant.df, lookup.path)

### Upload
library(purrr)

store.path <- file.path(stage.path, paste0("case_", scenario.name, "_plant submissions"))
drive_mkdir(store.path)

plant.path %>% 
	list.files(full.names = TRUE) %>% 
	map(drive_upload, paste0(store.path, "/"))
