##Plot total emissions from PM2.5 in Baltimore City, MD, from 1999-2008 for all
##all motor vehicle sources. It is assumed that motor vechile sources can be
##identified by selecting all NEI type is "ON-ROAD".  

##This script assumes the NEI database is are in the current working directory.

NEI<-readRDS("summarySCC_PM25.rds")

##Plot 5
baltVehicleSubset<-subset(NEI, fips == "24510" & type == "ON-ROAD")
baltTypeAggregate <- aggregate(baltVehicleSubset$Emissions, list(baltVehicleSubset$year, baltVehicleSubset$type), sum)
baltTypeNames<-c("year", "type", "TotalEmissions")
colnames(baltTypeAggregate)<-baltTypeNames
qplot(year, TotalEmissions, data=baltTypeAggregate, geom=c("point", "smooth"), 
      method="lm", se=FALSE, 
      main="PM2.5 Emissions Baltimore City, MD \n 1999-2008 for \n Motor Vehicle Sources \n", 
      ylab="Total Emissions")

dev.copy(png, file = "plot5.png", width=600, height=480) ## Copy my plot to a PNG file
dev.off()                                                ## close the PNG device