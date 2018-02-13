# Initialise paths ####
# Copy paste at beginning of every R script
# Edit as appropriate

data.source <- "Fitch"
data.set <- "Sovereign Ratings History"

cache.path <- file.path(".", data.source, data.set, "Data")
stage.path <- file.path("~/Data/DataLake", data.source, data.set, "data")

library(googledrive)
drive_auth()

#*********************#

# Load ####

library(readxl)

data.path <- file.path(cache.path, "sovereign_ratings_history.xls")

ratings.raw <- read_excel(
	data.path, sheet = "Sovereign", range = "A6:G988", 
	col_names = c(
		"Country", "Date",
		"FC.rating.long", "FC.rating.short", "FC.rating.outlook",
		"LC.rating.long", "LC.rating.outlook"
	)
)

# Rating levels ####

longterm.rating.levels <- c(
	"AAA",
	"AA+", "AA", "AA-",
	"A+", "A", "A-",
	"BBB+", "BBB", "BBB-",
	# Investment grade
	"BB+", "BB", "BB-",
	"B+", "B", "B-",
	"CCC+", "CCC", "CCC-",
	"CC",
	"C",
	# Default
	"RD",
	"D"
)
	## DDD, DD, withdrawn, -, i
	# LC.rating.long == "DDD" : Argentina, Dominican Republic, Uruguay ['RD'?]
	# FC.rating.long == "DDD" : Argentina, Dominican Republic, Uruguay ['RD'?]
	# FC.rating.long == "DD" : Moldova 2002 ['RD'?]
	## Default ratings were DDD/DD/D until 2005, RD and D thereafter
	# FC.rating.long == "withdrawn" : Benin 2012 [no longer rated by Fitch]
	# LC.rating.long == "withdrawn" : Benin 2012 [no longer rated by Fitch]
	# FC.rating.long == "-" : Gambia, Iran, Libya, Malawi, Mali, Moldova, Papua New Guinea, Turkmenistan
	# LC.rating.long == "-" : a lot [suspension?]
	# LC.rating.long == "i" : South Africa 2008 [A?] ## http://www.treasury.gov.za/comm_media/press/2008/2008111001.pdf
	## Notes: if -, missing until next rating change; could be rating suspension or pre-assignment
	## Notes: if withdrawn, missing until present

shortterm.rating.levels <- c(
	"F1+", "F1",
	"F2",
	"F3",
	"B+", "B",
	"C",
	"D"
	# withdrawn, -
)

save(
	longterm.rating.levels, shortterm.rating.levels,
	file = file.path(cache.path, "ref_ratings.RData")
)

# Sanitise ####

library(dplyr)
library(stringr)

## Dup rating change entries
ratings.raw %>% 
	group_by(Country, Date) %>% 
	summarise(Entries = n()) %>% 
	filter(Entries > 1) %>% # More than one entry for Cyprus, Jamaica, and Libya
  select(-Entries) %>% 
  left_join(ratings.raw) %>% View()
	## Cyprus 2007-07-12: Rating Watch negative
	## Jamaica 2010-02-03: RD
	## General election for new government on Feb 15
	## > http://jamaica-gleaner.com/gleaner/20100107/int/int7.html
	## Libya 2011-04-13: -
	## Libyan civil war
	## > https://en.wikipedia.org/wiki/Timeline_of_the_2011_Libyan_Civil_War

## Remove duplicate rating change entries
ratings.unq <- ratings.raw %>% 
	mutate(Date = as.Date(Date)) %>% 
	## Remove deprecated rows
	filter(
		(Country != "Cyprus") | (Date != "2007-07-12") | (FC.rating.outlook != "stable")
	) %>% 
	filter(
		(Country != "Jamaica") | (Date != "2010-02-03") | (FC.rating.long != "CCC")
	) %>% 
	filter(
		(Country != "Libya") | (Date != "2011-04-13") | (FC.rating.long != "B")
	)
	
## Sanitise rating levels
ratings.df <- ratings.unq %>% 
	mutate(
		FC.rating.long = FC.rating.long %>% 
			str_replace_all(
				c(
					"^D{2,}$" = "RD" # DDD and DD to RD
				)
			),
		LC.rating.long = LC.rating.long %>% 
			str_replace_all(
				c(
					"^D{2,}$" = "RD", # DDD and DD to RD
					"^i$" = "A" # Assume affirmation of current rating
				)
			),
		FC.rating.short = FC.rating.short %>% 
			str_replace_all(
				c(
					"f(?=[[:digit:]])" = "F" # Correct lower-case F's
				)
			),
		FC.rating.outlook = str_to_title(FC.rating.outlook),
		LC.rating.outlook = str_to_title(LC.rating.outlook)
	)
	## Ratings not converted to factors yet b/c of "suspended" and "withdrawn"

clean.path <- file.path(cache.path, "data00_sanitised rating actions")
rds.path <- paste0(clean.path, ".rds")
saveRDS(ratings.df, rds.path)
csv.path <- paste0(clean.path, ".csv")
write.csv(ratings.df, csv.path, row.names = FALSE)

drive_upload(rds.path, paste0(stage.path, "/"))
drive_upload(csv.path, paste0(stage.path, "/"))
