##Plot total emissions from PM2.5 in the US from 1999-2008 by reading in the 
##NEI (National Emissions Inventory database).
##This script assumes the NEI database is in the current working directory.

NEI<-readRDS("summarySCC_PM25.rds")

##Plot#1
NEIyearTot<-aggregate(NEI$Emissions, list(NEI$year), sum)
NEIyearTotnames<-c("year", "TotalEmissions")
colnames(NEIyearTot)<-NEIyearTotnames
barplot(NEIyearTot$TotalEmissions/1e6, col="blue", main="Total PM2.5 Emissions in US 1999-2008", ylab="Emissions (in millions)")
axis(1,at=c(.7, 1.9, 3.1, 4.3),labels=NEIyearTot$year, tick=FALSE)

dev.copy(png, file = "plot1.png") ## Copy my plot to a PNG file
dev.off()                         ## close the PNG device