# Initialise paths ################################################
# Copy paste at beginning of every R script
# Edit as appropriate

library(googledrive)
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

# Download ####

# Load ####

fact.path <- file.path(cache.path, "data01u_fixed trans and ref.RData")
load(fact.path)

lookup.path <- file.path(cache.path, "data02u_fixed loc ref.RData")
load(lookup.path)

# Write ####

## Fact ####

fact.path <- file.path(cache.path, "data03u_Monthly product segment sales per customer.csv")
sales.df %>% write.csv(fact.path, row.names = FALSE)
drive_upload(fact.path, as_id(data.folder.id))

## Lookup ####

library(XLConnect)

lookup.ls <- list(
	"Customer" = cust.ref,
	"Product segment" = prod.ref,
	"Store" = store.df,
	"Districts" = district.df
)

ref.path <- file.path(cache.path, "data04u_cleaned lookup.xlsx")
ref.xl <- loadWorkbook(ref.path, create = TRUE)
createSheet(ref.xl, names(lookup.ls))
writeWorksheet(ref.xl, lookup.ls, names(lookup.ls))
saveWorkbook(ref.xl)
drive_upload(ref.path, as_id(data.folder.id))
