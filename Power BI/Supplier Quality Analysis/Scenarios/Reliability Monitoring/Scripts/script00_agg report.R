metrics.df %>% mutate(Year = year(Date), Qtr = quarter(Date)) %>% group_by(Year, Qtr) %>% summarise(Downtime = sum(`Downtime min`)) %>% View()

ggplot(temp.df) + geom_line(aes(x = Qtr, y = Downtime, group = Year, colour = as.factor(Year)))