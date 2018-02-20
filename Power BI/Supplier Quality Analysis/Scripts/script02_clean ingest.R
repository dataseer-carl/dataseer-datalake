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

# View cache ####

library(magrittr)

## List extant data files
(dataset.files <- stage.path %>% drive_ls())

# Load parsed ingest ####

data01.file <- "data01_parsed ingest.rds"
data01.id <- stage.path %>% 
	file.path(data01.file) %>% ## Select file for download
	drive_get() %>% 
	as_id()

data01.path <- file.path(cache.path, data01.file)

drive_download(data01.id, path = data01.path, overwrite = TRUE) ## Download raw data file

metrics.df <- readRDS(data01.path)

# Clean ####

library(dplyr)
library(stringr)

plant.df <- metrics.df %>% 
	mutate(
		State = Plant %>% # Isolate State from Plant name
			str_extract(",? [[:alpha:]]{2}$") %>% 
			str_replace_all(c(",? " = "")),
		# Isolate City from Plant name
		City = Plant %>% str_replace_all(c(",? [[:alpha:]]{2}$" = "", "^Detriot$" = "Detroit"))
	) %>% 
	select(Plant, City, State) %>% distinct()

# Fabricate ####

# library(openxlsx)
# Sys.setenv("R_ZIPCMD" = "C:/Program Files/Git/mingw64/bin")
# 
# xlsx.file <- "data02_metrics with plant address.xlsx"
# xlsx.path <- file.path(cache.path, xlsx.file)
# 
# data.xl <- createWorkbook()
# ## Write Metrics
# addWorksheet(data.xl, "Metrics")
# writeDataTable(
# 	data.xl, "Metrics", metrics.df,
# 	keepNA = TRUE, withFilter = TRUE
# )
# ## Write Addresses
# addWorksheet(data.xl, "Plant Address")
# writeData(data.xl, "Plant Address", plant.df)
# saveWorkbook(data.xl, file = xlsx.path)

library(XLConnect)

out.file <- "data02_metrics with plant address"

out.ls <- list("Metrics" = metrics.df, "Plant Addresses" = plant.df)
rdata.path <- file.path(cache.path, paste0(out.file, ".RData"))
save(metrics.df, plant.df, file = rdata.path)
drive_upload(rdata.path, paste0(stage.path, "/"))

xlsx.file <- paste0(out.file, ".xlsx")
xlsx.path <- file.path(cache.path, xlsx.file)

out.xl <- loadWorkbook(xlsx.path, create = TRUE)
createSheet(out.xl, names(out.ls))
writeWorksheet(out.xl, out.ls, names(out.ls))
saveWorkbook(out.xl)

ul.path <- file.path(stage.path, xlsx.file)
drive_upload(xlsx.path, ul.path)
