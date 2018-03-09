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

## Download and load RData with raw datasets

filename <- "data00u_raw ingest.RData"
file.id <- data.folder %>% filter(name == filename) %>% use_series(id) 
dataset.path <- file.path(cache.path, filename)
drive_download(as_id(file.id), path = dataset.path, overwrite = TRUE)
load(dataset.path)

lookup.ls$Item %>% use_series(ItemID) %>% as.character() -> lookup.ls$Item$ItemID

# Sales.csv with Buyer names - 67 rows
buyersinsales.df <- sales.raw %>%  
	left_join(lookup.ls$Item, by = "ItemID") %>% 
	select(Buyer, ItemID) %>%
	group_by(Buyer) %>% 
	summarise() %>% 
	ungroup()

# Buyer sheet with Sales records - 78 rows
salesinbuyers.df <- lookup.ls$Item %>% 
	left_join(sales.raw, by = "ItemID") %>% 
	select(Buyer, ItemID) %>% 
	group_by(Buyer) %>% 
	summarise() %>% 
	ungroup()

# Missing buyers in Sales records - 11 rows
missingbuyers.df <- anti_join(salesinbuyers.df, buyersinsales.df)

missingbuyers.item.df <- lookup.ls$Item %>% 
	left_join(sales.raw, by = "ItemID") %>% 
	select(Buyer, ItemID) %>% 
	right_join(missingbuyers.df, by = "Buyer") 

# Items in Buyer sheet with Sales record - 258268 rows
items.df <- lookup.ls$Item %>% 
	left_join(sales.raw, by = "ItemID") %>% 
	filter(is.na(MonthID))
nrow(items.df)

# Items in Sales.csv with identified buyer - 923371 rows
items2.df <- sales.raw %>% 
	left_join(lookup.ls$Item, by = "ItemID") %>% 
	filter(!is.na(Buyer))
nrow(items2.df)

