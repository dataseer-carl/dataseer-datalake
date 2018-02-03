library(magrittr)

# Paths ####

data.source <- "IBM Watson"
data.set <- "HR Employee Attrition"
case.dir <- "Salary Benchmarking"

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
	drive_get()
dataset.id <- as_id(dataset.file) ## Get ID for download
raw.path <- file.path(case.path, "Data", dataset.file$name) ## Set destination path for download
drive_download(dataset.id, path = raw.path, overwrite = TRUE) ## Download raw data file

##### load
raw.df <- file.path(raw.path) %>% readRDS()

# Fabricate ####

library(dplyr)

data.df <- raw.df %>% 
	mutate(
		priorYearsOfWork = TotalWorkingYears - YearsAtCompany
	) %>% 
	select(
		# Key
		EmployeeNumber,
		# Bio
		Sex, Age, MaritalStatus, DistanceFromHome,
		Education, EducationField, 
		# Work XP
		priorNumCompaniesWorked = NumCompaniesWorked, priorYearsOfWork,
		# Company
		Tenure = YearsAtCompany,
		Department, JobLevel, JobRole,
		StockOptionLevel,
		# Response
		MonthlyIncome
	)

# Store devised raw data ####

# library(googledrive)

## RData ####

### Create local file
case.file <- paste0("case_", case.dir)
cache.file <- paste0(case.file, ".RData")
cache.path <- file.path(case.path, "Data", cache.file)
save(data.df, file = cache.path)

### Upload to dump
dump.path <- file.path(paths.ls$datastage.prod, cache.file)
drive_upload(cache.path, dump.path)

## csv ####

### Fashion raw data files
stage.path <- file.path(paths.ls$datastage.prod, case.file)
drive_mkdir(stage.path)

staged.ls <- list(
	"employee record" = data.df
)

#### Upload each
lapply(
	as.list(names(staged.ls)),
	function(temp.name){
		# temp.name = "active employees"
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
