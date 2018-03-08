# Initialise paths ################################################
# Copy paste at beginning of every R script
# Edit as appropriate

library(magrittr)
library(dplyr)
library(stringr)

library(googledrive)
drive_auth()

drive_ls_from_id <- function(drive.id){
	require(googledrive)
	
	# drive.id := as.character()
	
	x.id <- as_id(drive.id)
	x.dribble <- drive_get(x.id)
	x.ls <- drive_ls(x.dribble)
	
	return(x.ls)
}

drive_subdir_id <- function(drive.id, subdir.name){
	require(googledrive)
	require(magrittr)
	require(dplyr)
	
	# drive.id := id of GDrive directory to navigate from
	# subdir.name := name of subdirectory
	
	drive.dribble <- drive_ls_from_id(drive.id)
	subdir.id <- drive.dribble %>% filter(name == subdir.name) %>% use_series(id)
	return(subdir.id)
}

drive_file_id <- function(drive.id, file.name){
	require(googledrive)
	require(magrittr)
	require(dplyr)
	
	# drive.id := id of GDrive directory to navigate from
	# file.name := name of file
	
	drive.dribble <- drive_ls_from_id(drive.id)
	file.id <- drive.dribble %>% filter(name == file.name) %>% use_series(id)
	return(file.id)
}

# ID of Datalake folder
datalake.id = "1IQXPXMZSEK4QK_gKK2ERp9pOs4wJ_dog"
(datalake <- drive_ls_from_id(datalake.id))

# Author of dataset
author.name <- "IBM Watson"
author.folder.id <- drive_subdir_id(datalake.id, author.name)
(author.folder <- drive_ls_from_id(author.folder.id))

# Dataset folder
data.source <- "HR Employee Attrition" 
datasource.folder.id <- drive_subdir_id(author.folder.id, data.source)
(datasource.folder <- drive_ls_from_id(datasource.folder.id))

## Path to local (proxy for repo://)
proxy.path <- file.path(".", author.name, data.source)
cache.path <- file.path(proxy.path, "Data")

## Path to data://
# Raw folder
raw.folder.id <- drive_subdir_id(datasource.folder.id, "raw")
(raw.folder <- drive_ls_from_id(raw.folder.id))

# Data folder
data.folder.id <- drive_subdir_id(datasource.folder.id, "data")
(data.folder <- drive_ls_from_id(data.folder.id))

# Scenario folder
scenario.name <- "Employee Satisfaction and Performance"
case.path <- file.path(proxy.path, "Scenarios", scenario.name)
case.dump <- file.path(case.path, "Data")

#*****************************************************************#

# Get inputs ####

### List extant data files
(dataset.files <- drive_ls_from_id(data.folder.id))

#### download
input.file <- "data01_parsed ingest.rds"
dataset.id <- drive_file_id(data.folder.id, input.file)
raw.path <- file.path(case.path, "Data", input.file) ## Set destination path for download
drive_download(as_id(dataset.id), path = raw.path, overwrite = TRUE) ## Download raw data file

##### load
raw.df <- readRDS(raw.path)

# Fabricate ####

## Isolate satisfaction survey columns ####
satisfaction.df <- raw.df %>% 
	select(
		EmployeeNumber,
		EnvironmentSatisfaction, RelationshipSatisfaction, JobSatisfaction,
		JobInvolvement, WorkLifeBalance
	)

## Remove variables already in satisfaction survey
rmSatis.df <- raw.df %>% 
	select(
		-one_of(
			names(satisfaction.df) %>% str_subset("[^(EmployeeNumber)]")
		)
	)

## Isolate employee record ####
employee.df <- rmSatis.df %>% 
	select(
		EmployeeNumber,
		# Bio
		Sex, Age, MaritalStatus, DistanceFromHome,
		Education, EducationField, 
		NumCompaniesWorked, TotalWorkingYears,
		# Record
		Department, JobLevel, JobRole,
		YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion,
		MonthlyIncome, StockOptionLevel, SalaryHike,
		Separated
	)

rm.df <- rmSatis.df %>% 
	select(
		-one_of(
			c(names(employee.df)) %>% str_subset("[^(EmployeeNumber)]")
		)
	)

employee.df %<>%
	mutate(
		Status = ifelse(Separated, "Inactive", "Active") %>% 
			factor(levels = c("Active", "Inactive"))
	) %>% 
	select(-Separated)

## Isolate performance survey columns ####

performance.df <- rm.df %>% 
	select(
		EmployeeNumber, PerformanceRating,
		OverTime, YearsWithCurrManager,
		BusinessTravel, TrainingTimesLastYear
	)

# Store devised raw data ####

# library(googledrive)

## RData ####

### Create local file
case.file <- paste0("case_", scenario.name)
cache.file <- paste0(case.file, ".RData")
cache0.path <- file.path(case.dump, cache.file)
save(satisfaction.df, employee.df, performance.df, file = cache0.path)

### Upload to dump
drive_upload(cache0.path, as_id(data.folder.id), cache.file)

## csv ####

### Fashion raw data files

staged.ls <- list(
	"Satisfaction survey" = satisfaction.df,
	"Employee records" = employee.df,
	"Performance rating survey" = performance.df
)

#### Upload each
lapply(
	names(staged.ls),
	function(temp.name){
		temp.df <- staged.ls[[temp.name]]
		out.file <- paste0(case.file, "-", temp.name, ".csv")
		out.path <- file.path(case.dump, out.file)
		write.csv(temp.df, out.path, row.names = FALSE)
		drive_upload(out.path, as_id(data.folder.id), out.file)
	}
)

## xlsx ####

library(XLConnect)

### Create workbook

xlsx.file <- paste0(case.file, ".xlsx")
xlsx.path <- file.path(case.dump, xlsx.file)

out.xl <- loadWorkbook(xlsx.path, create = TRUE)
createSheet(out.xl, names(staged.ls))
writeWorksheet(out.xl, staged.ls, names(staged.ls))
saveWorkbook(out.xl)

### Upload workbook
drive_upload(xlsx.path, as_id(data.folder.id), xlsx.file)
