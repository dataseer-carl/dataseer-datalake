# Initialise paths ################################################
# Copy paste at beginning of every R script
# Edit as appropriate

author.name <- "Power BI"
data.source <- "Retail Analysis"

## Path to local (proxy for repo://)
cache.path <- file.path(".", author.name, data.source, "Data")

## Path to data://
data.path <- file.path("~/Data/DataLake", author.name, data.source)
stage.path <- file.path(data.path, "data")
raw.path <- file.path(data.path, "raw")

library(googledrive)
drive_auth()

#*****************************************************************#

# Download ####

# Load ####

fact.path <- file.path(cache.path, "data01_fixed trans and ref.RData")
load(fact.path)

lookup.path <- file.path(cache.path, "data02_fixed loc ref.RData")
load(lookup.path)

# Write ####

## Fact ####

fact.path <- file.path(cache.path, "data03_Monthly product segment sales per customer.csv")
sales.df %>% write.csv(fact.path, row.names = FALSE)
drive_upload(fact.path, paste0(stage.path, "/"))

## Lookup ####

library(XLConnect)

lookup.ls <- list(
	"Customer" = cust.ref,
	"Product segment" = prod.ref,
	"Store" = store.df,
	"Districts" = district.df
)

ref.path <- file.path(cache.path, "data04_cleaned lookup.xlsx")
ref.xl <- loadWorkbook(ref.path, create = TRUE)
createSheet(ref.xl, names(lookup.ls))
writeWorksheet(ref.xl, lookup.ls, names(lookup.ls))
saveWorkbook(ref.xl)
drive_upload(ref.path, paste0(stage.path, "/"))
