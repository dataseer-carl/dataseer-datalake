# Initialise paths ####
# Copy paste at beginning of every R script
# Edit as appropriate

data.source <- "Uber"
data.set <- "Uber Movement"

cache.path <- file.path(".", data.source, data.set, "Data")
stage.path <- file.path("~/Data/DataLake", data.source, data.set, "data")

library(googledrive)
drive_auth()

#*********************#

# Hexes ####

library(jsonlite)

hex.file <- "manila_hexes.json"
hex.path <- file.path(cache.path, hex.file)

hex.raw <- fromJSON(hex.path)
# .
# |-	type (1)
# |			L "FeatureCollection"
# |
# L		features (846)
#				|-	type
#				|			L "Feature"
#				|
#				|-	geometry
#				|			|-	type
#				|			|			L "Polygon"
#				|			L		coordinates
#				|						L	.
#				|							|-	.
#				|									|-	long
#				|									L		lat
#				|							|-	.
#				|									|-	long
#				|									L		lat
#				|							...
#				|							L		.
#				|									|-	long
#				|									L		lat
#				L		properties

## Remove dummy
hex.df <- hex.raw$features
hex.df$geometry$coordinates <- lapply(hex.df$geometry$coordinates, function(temp.arr) temp.arr[1,,])
hex.df$geometry$type <- NULL # All "Polygon"
hex.df$type <- NULL

## Unbox coordinates
hex.df$coordinates <- hex.df$geometry$coordinates
hex.df$geometry <- NULL

## Unbox properties
hex.df$MOVEMENT_ID <- hex.df$properties$MOVEMENT_ID
hex.df$DISPLAY_NAME <- hex.df$properties$DISPLAY_NAME
hex.df$properties <- NULL

library(dplyr)
library(magrittr)

hex.df %<>% select(MOVEMENT_ID, DISPLAY_NAME, coordinates)

hexDF.file <- "hex_df.rds"
hexDF.path <- file.path(cache.path, hexDF.file)
saveRDS(hex.df, hexDF.path)
hexDF.loc <- file.path(stage.path, hexDF.file)
drive_upload(hexDF.path, hexDF.loc)

## _sp ####

library(sp)
library(rgdal)
library(rgeos)
library(maptools)

hexPoly.ls <- lapply(hex.df$coordinates, Polygon, hole = FALSE)
hexPolygons.ls <- lapply(
	1:length(hexPoly.ls),
	function(poly.idx){
		# poly.idx <- 1
		temp.poly <- hexPoly.ls[poly.idx] # Must be list into Polygons
		temp.polygons <- Polygons(temp.poly, ID = hex.df$MOVEMENT_ID[poly.idx])
		return(temp.polygons)
	}
)
hex.sp <- SpatialPolygons(hexPolygons.ls)

### Intersect with NCR
ncr.shp <- file.path(".", "GADM", "PHL_adm_shp", "Data", "data00_shp_ncr.rds") %>% 
	readRDS()

isNCR <- gIntersects(hex.sp, ncr.shp, byid = TRUE)
# 1x846 matrix
isNCR <- isNCR[1,]

hexNCR.sp <- hex.sp[which(isNCR),]

### Identify hex for Bel-Air
belair.shp <- file.path(".", "GADM", "PHL_adm_shp", "Data", "data01_shp_belair.rds") %>% 
	readRDS()

isBelair <- gIntersects(hexNCR.sp, belair.shp, byid = TRUE)
hexBelair.sp <- hexNCR.sp[which(isBelair),]
Belair.sp <- gUnionCascaded(hexBelair.sp)

belair.center <- gCentroid(hexBelair.sp)
belair.center <- belair.center@coords[1,] # lon-lat
belair.map <- get_map(belair.center, maptype = "roadmap", zoom = 14)

ggmap(belair.map) +
	geom_polygon(
		aes(x = long, y = lat, group = group),
		fill = NA, colour = "black",
		data = hex.f %>% filter(id %in% names(hexBelair.sp))
	) +
	geom_polygon(
		aes(x = long, y = lat, group = group),
		fill = NA, colour = "black", size = 2,
		data = fortify(Belair.sp)
	) +
	labs(x = NULL, y = NULL) +
	theme(
		plot.background = element_blank(),
		panel.background = element_blank(),
		axis.text = element_blank(),
		axis.ticks = element_blank()
	)
ggsave(
	file.path(".", data.source, data.set, "Plots", "plot00_zone_belair.png"),
	height = 8.28, width = 8.28, units = "in"
)

### Overlay map

library(ggplot2)
library(rgdal)
library(rgeos)
library(maptools)
library(ggmap)
# library(stringr)

#### Get Map Tiles
ncr.center <- gCentroid(hex.sp)
ncr.center <- ncr.center@coords[1,] # lon-lat

ncr.map <- get_map(ncr.center, maptype = "roadmap", zoom = 12)

#### Plot
hex.f <- fortify(hexNCR.sp)

ggmap(ncr.map) +
	geom_polygon(
		aes(x = long, y = lat, group = group),
		fill = NA, colour = "black", size = 0.25,
		data = hex.f %>% filter(!(id %in% names(hexBelair.sp)))
	) +
	geom_polygon(
		aes(x = long, y = lat, group = group),
		fill = NA, colour = "black", size = 1,
		data = fortify(Belair.sp)
	) +
	labs(x = NULL, y = NULL) +
	theme(
		plot.background = element_blank(),
		panel.background = element_blank(),
		axis.text = element_blank(),
		axis.ticks = element_blank()
	)
ggsave(
	file.path(".", data.source, data.set, "Plots", "plot01_grid_belair.png"),
	height = 8.28, width = 8.28, units = "in"
)

NCRhex.file <- "NCR_hex.RData"
save(ncr.map, hex.f, hexNCR.sp, file = file.path(cache.path, NCRhex.file))

# Travel times ####

library(readr)
library(ggplot2)

travel.file <- "manila-hexes-2017-2-All-HourlyAggregate.csv"
travel.path <- file.path(cache.path, travel.file)

system.time({travel.df <- read_csv(travel.path)}) # 9.62 secs
# system.time({travel2.df <- read.csv(travel.path)}) # 29.61 secs

reach.df <- travel.df %>% 
	# group_by(sourceid, dstid) %>% # Aggregate over hour of day
	# summarise(
	# 	max.time = max(mean_travel_time)
	# ) %>% 
	# ungroup() %>% 
	filter(hod == 9) %>% # Isolate 8am
	select(sourceid, dstid, mean_travel_time) %>% 
	mutate(
		unit.dist = 1 / mean_travel_time
	)

test.df <- reach.df %>% filter(mean_travel_time == max(mean_travel_time))

getHr <- function(x){
	require(stringr)
	require(magrittr)
	mins <- x / 60
	hrs <- round(mins %/% 60)
	mins.rem <- round(mins %% 60)
	lab <- paste(
		paste0(hrs, "H"),
		paste0(mins.rem, "M")
	)
	lab %<>% str_replace_all(c("^0H 0M$" = "0"))
	return(lab)
}

ggplot(reach.df) +
	geom_histogram(
		aes(x = mean_travel_time)
	) +
	scale_y_continuous(name = NULL, expand = c(0, 0)) +
	scale_x_continuous(name = "Morning Rush Hour Travel Time", labels = getHr) +
	theme(
		plot.background = element_blank(),
		panel.background = element_blank(),
		axis.line.x = element_line(colour = "black"),
		axis.line.y = element_blank(),
		axis.ticks.y = element_blank(),
		axis.text.y = element_blank()
	)

library(igraph)

travel.graph <- graph_from_data_frame(reach.df, directed = TRUE)

E(travel.graph)$weight <- E(travel.graph)$unit.dist

V(travel.graph)$size <- 15 / 3
V(travel.graph)$frame.color <- NA
V(travel.graph)$label <- NA

plot(travel.graph)
