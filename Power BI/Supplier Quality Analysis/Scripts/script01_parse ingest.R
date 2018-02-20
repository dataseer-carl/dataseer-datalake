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

# Load raw ingest ####

data00.file <- "data00_raw ingest.rds"
data00.path <- file.path(cache.path, data00.file)

raw.ls <- readRDS(data00.path)

# Iso data from lookup tables ####

metrics.raw <- raw.ls$Metrics

# Get lookup values ####

library(dplyr)

metrics.df <- metrics.raw %>% 
	mutate(
		Date = as.Date(Date, origin = "1899-12-30")
	) %>% 
	## Get part of process where defect occurred
	# raw.ls$Category
	left_join(
		raw.ls$Category %>% select(-`Sub Category`), # Subcat and Cat redundant
		by = "Sub Category ID"
	) %>% 
	select(-`Sub Category ID`) %>% 
	## Get Plant location
	# View(raw.ls$Plant); correct typoes and impute City-State
	left_join(raw.ls$Plant) %>%
	select(-`Plant ID`) %>% 
	## Get Vendor of defective supply
	# raw.ls$Vendor %>% group_by(Vendor) %>% summarise(Count = n()) %>% arrange(desc(Count)) %>% View()
	# raw.ls$Vendor; 2 Vendors have more than one entry
	left_join(raw.ls$Vendor) %>% 
	select(-`Vendor ID`) %>% 
	## Get Material of defective supply
	# raw.ls$`Material Type`
	left_join(raw.ls$`Material Type`) %>% 
	select(-`Material Type ID`, -`Material ID`) %>% # Latter is broken lookup
	## Get defect and type thereof
	# raw.ls$`Defect Type` %>% select(-Sort) %>% View()
	left_join(
		raw.ls$`Defect Type` %>% select(-Sort), # Seems to be useless
		by = "Defect Type ID"
	) %>% 
	select(-`Defect Type ID`) %>% 
	## Get defect description
	# raw.ls$Defect %>% View()
	left_join(raw.ls$Defect) %>% # not cleaned (some redundant entries)
	select(-`Defect ID`) %>% 
	mutate(
		## Rearrange Defect Type factor levels
		`Defect Type` = factor(`Defect Type`, levels = c("No Impact", "Impact", "Rejected"))
	) %>% 
	select(
		Date,
		Plant, Category,
		Vendor, `Material Type`,
		`Defect Type`, Defect,
		`Defect Qty`, `Downtime min`
	)

# Store parsed ingest ####

### Create local file
data01.file <- "data01_parsed ingest.rds"
data01.path <- file.path(cache.path, data01.file)
metrics.df %>% saveRDS(data01.path)

### Upload to dump
drive_upload(data01.path, paste0(stage.path, "/"))
