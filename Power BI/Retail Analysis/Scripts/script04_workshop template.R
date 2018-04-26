library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(scales)
library(ggExtra)

end_month <- function(m,y) {
	d = ymd(paste(y,m,"01")) + months(1) - days(1)
	return (d)
}
author.name <- "Power BI"
data.source <- "Retail Analysis" 
cache.path <- file.path(".", author.name, data.source, "Data")

custcsv.file = "data03u_Monthly product segment sales per customer.csv"
custcsv.path = file.path(cache.path, custcsv.file)

custxl.file = "data04u_cleaned lookup.xlsx"
custxl.path = file.path(cache.path, custxl.file)

custcsv.raw = read_csv(custcsv.path, col_types = cols(
	MonthID = col_integer(),
	LocationID = col_character(),
	CustomerID = col_character(),
	Segment = col_character(),
	Sum_GrossMarginAmount = col_double(),
	Sum_Regular_Sales_Dollars = col_double(),
	Sum_Markdown_Sales_Dollars = col_double(),
	Sum_Regular_Sales_Units = col_integer(),
	Sum_Markdown_Sales_Units = col_integer()
))
custxl.raw = read_excel(custxl.path, sheet = "Customer")
loc.raw = read_excel(custxl.path, sheet = "Store")
seg.raw = read_excel(custxl.path, sheet = "Product segment")
cust.df <- left_join(custcsv.raw, custxl.raw, by = "CustomerID") %>% 
	left_join(loc.raw, by = "LocationID") %>% 
	left_join(seg.raw, by = "Segment") %>% 
	mutate(
		Year = substr(MonthID, 1, 4) %>% as.integer(),
		Month = substr(MonthID, 5, 6) %>% as.integer(),
		Date = end_month(Month, Year)
	) 

cust.df2 <- cust.df %>% 
	group_by(Buyer) %>% 
	summarise(
		`Number of stores visited` = n_distinct(LocationID),
		`Most recent purchase` = max(Date),
		Frequency = n_distinct(Date), 
		Visits = n(),
		`Total Sales in Dollars` = sum(Sum_Regular_Sales_Dollars + Sum_Markdown_Sales_Dollars),
		`Average Monthly Sales` = sum(Sum_Regular_Sales_Dollars + Sum_Markdown_Sales_Dollars) / Frequency
	) %>% 
	ungroup()


p1 <- ggplot(cust.df2) + geom_point(aes(x = Frequency, y = log(`Average Monthly Sales`), size = `Most recent purchase`), alpha = 1/3, position = "jitter") + theme(legend.position = "none")
ggMarginal(p1, type = "histogram")


monthly.sales <- cust.df %>% 
	group_by(Date) %>% 
	summarise(
		total.sales = sum(Sum_Regular_Sales_Dollars + Sum_Markdown_Sales_Dollars),
		distinct.customers = sum(n_distinct(CustomerID)),
		average.sales = total.sales/distinct.customers
	)

location.report <- cust.df %>%
	group_by(Name) %>% 
	summarise(
		total.sales = sum(Sum_Regular_Sales_Dollars + Sum_Markdown_Sales_Dollars),
		distinct.customers = sum(n_distinct(CustomerID)),
		average.sales = total.sales/distinct.customers
	) %>% 
	ungroup()

segment.report <- cust.df %>% 
	group_by(Category) %>% 
	summarise(
		total.sales = sum(Sum_Regular_Sales_Dollars + Sum_Markdown_Sales_Dollars),
		distinct.customers = sum(n_distinct(CustomerID)),
		average.sales = total.sales/distinct.customers
	) %>% 
	ungroup()

month_store <- cust.df %>% 
	group_by(Date, Category) %>% 
	summarise(
		total.sales = sum(Sum_Regular_Sales_Dollars + Sum_Markdown_Sales_Dollars),
		distinct.customers = sum(n_distinct(CustomerID)),
		average.sales = total.sales/distinct.customers
	) %>% 
	ungroup()
