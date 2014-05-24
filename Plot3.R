##Plot total emissions from PM2.5 in Baltimore City from 1999-2008 for each type 
##(NEI$type:  Non-road, Nonpoint, On-Road, Point) by reading in the 
##NEI (National Emissions Inventory database).
##This script assumes the NEI database is in the current working directory.

NEI<-readRDS("summarySCC_PM25.rds")

##Plot#3
baltSubset<-subset(NEI, fips == "24510")
baltTypeAggregate <- aggregate(baltSubset$Emissions, list(baltSubset$year, baltSubset$type), sum)
baltTypeNames<-c("year", "type", "TotalEmissions")
colnames(baltTypeAggregate)<-baltTypeNames
qplot(year, TotalEmissions, data=baltTypeAggregate, geom=c("point", "smooth"), 
      method="lm", facets=.~type, se=FALSE, 
      main="PM2.5 Emissions Baltimore City, MD \n 1999-2008 by Type \n", 
      ylab="Total Emissions")

dev.copy(png, file = "plot3.png", width=600, height=480) ## Copy my plot to a PNG file
dev.off()                                                ## close the PNG device