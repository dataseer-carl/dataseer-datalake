data.stage <- "~/Data/DataLake"

unqSort <- function(x) sort(unique(x))

countDistinct <- function(x) length(unique(x))

countNA <- function(x) sum(is.na(x))

eoMonth <- function(year.int, month.int, isWeekday = TRUE){
	is.yrEnd <- month.int == 12
	chr.date <- paste(
		year.int + is.yrEnd, 
		month.int + 1 - 12*is.yrEnd, 
		1, 
		sep = "-"
	)
	date.date <- as.Date(chr.date, format = "%Y-%m-%d")
	out.date <- date.date - 1
	
	if(isWeekday){
		kWeekdays <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
		temp.wday <- weekdays(out.date, abbreviate = TRUE)
		temp.wday.idx <- match(temp.wday, kWeekdays)
		temp.wday.adj <- pmax(temp.wday.idx - 5, 0)
		out.date <- out.date - temp.wday.adj
	}
	
	return(out.date)
}


theme_basic <- function(...){
	require(ggplot2)
	theme(
		panel.background = element_blank(),
		axis.line = element_line(colour = "black"),
		strip.background = element_rect(colour = NA, fill = rgb(120, 124, 132, maxColorValue = 255)),
		strip.text = element_text(colour = "white"),
		...
	)
}