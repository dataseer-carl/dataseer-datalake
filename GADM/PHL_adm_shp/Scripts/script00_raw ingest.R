# Initialise paths ####
# Copy paste at beginning of every R script
# Edit as appropriate

data.source <- "GADM"
data.set <- "PHL_adm_shp"

cache.path <- file.path(".", data.source, data.set, "Data")
stage.path <- file.path("~/Data/DataLake", data.source, data.set, "data")

library(googledrive)
drive_auth()

#*********************#

# ! No chunk to DL files yet

# Province ####

library(rgdal)

prov.shp <- readOGR(cache.path, "PHL_adm1", p4s = "+proj=longlat +datum=WGS84 +no_defs")
ncr.shp <- prov.shp[prov.shp$NAME_1 == "Metropolitan Manila",]

saveRDS(ncr.shp, file.path(cache.path, "data00_shp_ncr.rds"))

# Brgy ####

library(rgdal)
library(rgeos)
library(maptools)
library(ggplot2)
library(ggmap)

load("./Uber/Uber Movement/Data/NCR_hex.RData")

ggmap(ncr.map)

brgy.shp <- readOGR(cache.path, "PHL_adm3", p4s = "+proj=longlat +datum=WGS84 +no_defs")

makati.idx <- which(brgy.shp$NAME_1 == "Metropolitan Manila" & brgy.shp$NAME_2 == "Makati City")
makati.shp <- brgy.shp[makati.idx,]

belair.shp <- makati.shp[makati.shp$NAME_3 == "Bel-Air",]

ggmap(ncr.map) +
	geom_polygon(
		aes(x = long, y = lat, group = group),
		fill = NA, colour = "black",
		data = fortify(belair.shp)
	)
saveRDS(belair.shp, file.path(cache.path, "data01_shp_belair.rds"))
