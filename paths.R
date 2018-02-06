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

periodTitle <- function(dates, frequency){
	require(lubridate)
	require(magrittr)
	require(stringr)
	
	# dates <- temp.dates
	# frequency <- c(
	# 	"annual", "Annual", "ANNUAL",
	# 	"Yearly", "yearly", "YEARLY",
	# 	"A", "Y", "a", "y",
	# 	"Semiannual", "semiannual", "Semi-annual", "semi-annual", "semi annual", "Semi annual",
	# 	"Semi", "SEMI", "semi",
	# 	"S", "H", "s", "h",
	# 	"Q",
	# 	"Quarterly", "quarterly",
	# 	"monthly", "monthly"
	# )
	# frequency <- sample.int(length(frequency), length(dates), replace = TRUE) %>% {frequency[.]}
	
	## Initialise frequency references
	freq.names <- c("annual", "semi-annual", "quarterly", "monthly")
	freq.c <- c(12, 6, 3, 1) # every how many months will period change?
	freq.pad <- c("", "", "", "0")
	freq.lab <- c("A", "H", "Q", "M")
	freq.regex <- c(
		"A" = "^[Aa]([Nn][Nn]?[Uu][Aa][Ll])?|^[Yy]([Ee][Aa][Rr][Ll][Yy])?",
		"H" = "^[SsHh]([Ee][Em][Ii][- ]*[Sa][Nn]+[Uu][Aa][Ll])?",
		"Q" = "^[Qq]([Uu][Aa][Rr][Tt][Ee][Rr][Ll][Yy])?",
		"M" = "^[Mm]([Oo][Nn][Tt][Hh][Ll][Yy])?"
	)
	
	## Detect frequency
	detect.freq <- sapply(freq.regex, function(x) str_detect(frequency, x))
	row.names(detect.freq) <- frequency

	## Construct period label
	period.idx <- detect.freq %>% apply(1, which)
	period.c <- freq.c[period.idx] ## Get modifier
	period.lab <- freq.lab[period.idx] ## Get label
	
	## Pad months
	period.pad <- freq.pad[period.idx]
	date.period <- ceiling(month(dates) / period.c)
	date.period %<>% paste0(period.pad, .) ## Will pad 0 to left of all months
	date.period %<>% str_replace_all(c("0(?=[[:digit:]]{2})" = ""))
	
	period.title <- paste0(period.lab, date.period)
	
	## Reporting period title
	year.title <- year(dates) %>% paste("CY", .)
	## Sanitise period title for annual
	full.title <- paste(year.title, period.title) %>% str_replace_all(c(" A1$" = ""))
	
	return(full.title)
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