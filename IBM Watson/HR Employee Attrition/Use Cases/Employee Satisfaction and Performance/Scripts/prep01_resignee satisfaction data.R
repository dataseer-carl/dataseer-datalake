data.source <- "IBM Watson"
data.set <- "HR Employee Attrition"
case.dir <- "Employee Satisfaction and Performance"

paths.ls <- file.path(".", data.source, data.set, "Scripts", "paths.rds") %>% readRDS()

case.path <- file.path(paths.ls$local, "Use Cases", case.dir)

# Get input data ####

library(googledrive)

## List extant data files
dataset.files <- file.path(paths.ls$prod, "data") %>% drive_ls()

## Download input data file
dataset.file <- file.path(paths.ls$prod, "data") %>% 
	file.path("case_Employee Satisfaction and Performance.RData") %>% 
	drive_get()
dataset.id <- as_id(dataset.file) ## Get ID for download
raw.path <- file.path(paths.ls$datastage.local, dataset.file$name) ## Set destination path for download
drive_download(dataset.id, path = raw.path, overwrite = TRUE) ## Download raw data file

# Process input data ####

library(dplyr)

load(raw.path)

## Get satisfaction results of resignees

resignees.df <- employee.df %>% 
	### Get whitelist of resignees
	filter(Separated) %>% 
	select(EmployeeNumber) %>% 
	### Get satisfaction results
	left_join(satisfaction.df)

# Stage data ####

### Name of data
case.file <- paste0("case_", case.dir, "_resignee satisfaction")

## rds ####

rds.file <- paste0(case.file, ".rds")
rds.path <- file.path(case.path, "Data", rds.file)
saveRDS(resignees.df, rds.path)

rds.dump <- file.path(paths.ls$datastage.prod, rds.file)
drive_upload(rds.path, rds.dump)

## csv ####

csv.file <- paste0(case.file, ".csv")
csv.path <- file.path(case.path, "Data", csv.file)
resignees.sdf <- resignees.df %>% 
	### Convert factors to numbers to allow segmentation
	mutate_at(vars(-EmployeeNumber), funs(as.integer))

write.csv(esignees.sdf, csv.path, row.names = FALSE)

csv.dump <- file.path(paths.ls$datastage.prod, csv.file)
drive_upload(csv.path, csv.dump)

## xlsx ####

library(writexl)

xlsx.file <- paste0(case.file, ".xlsx")
xlsx.path <- file.path(case.path, "Data", xlsx.file)

write_xlsx(resignees.sdf, xlsx.path)

xlsx.dump <- file.path(paths.ls$datastage.prod, xlsx.file)
drive_upload(xlsx.path, xlsx.dump)
