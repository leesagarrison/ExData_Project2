##Plot total emissions from PM2.5 in the Baltimore City, MD, from 1999-2008 by 
##reading in the NEI (National Emissions Inventory database) to see if there 
##has been a decrease.  
##This script assumes the NEI database is in the current working directory.

NEI<-readRDS("summarySCC_PM25.rds")

##Plot #2
baltSubset<-subset(NEI, fips == "24510")
NEIbaltTot<-aggregate(baltSubset$Emissions, list(baltSubset$year), sum)
NEIyearTotnames<-c("year", "TotalEmissions")
colnames(NEIbaltTot)<-NEIyearTotnames
plot(NEIbaltTot$year, NEIbaltTot$TotalEmissions, pch=7, col="red", xlab="Year", ylab="Total Emission", 
     main="PM2.5 Emissions in Baltimore City, MD, 1999-2008 \n (downward trend)")
TrendLine<-lm(NEIbaltTot$TotalEmissions~NEIbaltTot$year,data=NEIbaltTot)
abline(TrendLine, lty=3)
legend("topright", pch=7, col=c("red"), legend=c("Total Emissions"))

dev.copy(png, file = "plot2.png", width=600, height=480) ## Copy my plot to a PNG file
dev.off()                         ## close the PNG device