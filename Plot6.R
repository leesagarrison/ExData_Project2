##This script plots the percentage of change in PM25 emissions in Baltimore City (fips=24510)
##and Los Angeles County (fips=06037) for motor vehicle sources for the period
##1999-2008.  It is assumed that motor vechile sources can be identified by selecting 
##all entries where NEI type is "ON-ROAD".

##This script assumes the NEI database is in the current working directory.

NEI<-readRDS("summarySCC_PM25.rds")

##Plot6
##retrieve and sum all entries for Baltimore and LA Country for motor vehicles
library(quantmod)  ##needed for delt function
VehicleSubsetMD<-subset(NEI, fips == "24510" & type == "ON-ROAD")
VehicleSubsetLA<-subset(NEI, fips == "06037" & type == "ON-ROAD")
VehicleAggregateMD <- aggregate(VehicleSubsetMD$Emissions, list(VehicleSubsetMD$fips, VehicleSubsetMD$year), sum)
VehicleAggregateLA <- aggregate(VehicleSubsetLA$Emissions, list(VehicleSubsetLA$fips, VehicleSubsetLA$year), sum)
##set column names to make it easier to work with the data
vehicleAggregrateNames<-c("City", "Year", "TotalEmissions")
colnames(VehicleAggregateMD)<-vehicleAggregrateNames
colnames(VehicleAggregateLA)<-vehicleAggregrateNames

##determine the %change for each reading period for both MD and LA
deltaMD<-Delt(VehicleAggregateMD$TotalEmissions)
deltaLA<-Delt(VehicleAggregateLA$TotalEmissions)

##change the structure from a matrix to a dataframe, and set the starting point to 0
##in first year as the baseline (to begin calculating percentage changes year-on-year)
deltaMD<-as.data.frame(as.table(deltaMD))
deltaMD<-data.frame(year=VehicleAggregateMD$Year, Delta=deltaMD$Freq)
deltaMD[1,2]<-0

deltaLA<-as.data.frame(as.table(deltaLA))
deltaLA<-data.frame(year=VehicleAggregateLA$Year, Deltal=deltaLA$Freq)
deltaLA[1,2]<-0

##plot the initial data for MD
plot(deltaMD$year, deltaMD$Delta, ylim=c(-0.6, 0.1), yaxt="n", xlab="Year", 
     ylab="PM2.5 Emisson Percentage Change Per Year",
     main="PM2.5 Emission Percent Change per Year \n Baltimore City vs Los Angeles County \n 1999-2008")

##set the axis lables and horizonal lines for easy reading
axis(2, at=seq(-.6, 0.1, by=.1), labels=paste(100*seq(-.6, 0.1, by=.1), "%"))
abline(h=seq(-.6, 0.1, by=.2), col="grey10", lty="dotted")

##add points for LA to ensure the plots look the same for MD and LA
##then add the lines for both the MD and LA deltas (changes period-to-period)
points(deltaLA$year, deltaLA$Delta, col="red")
lines(deltaMD$year, deltaMD$Delta, col="blue", lwd=2)
lines(deltaLA$year, deltaLA$Delta, col="red", lwd=2)

##claculate and plot the trend line for the changes
MDTrendLine<-lm(deltaMD$Delta~deltaMD$year,data=deltaMD)
abline(MDTrendLine, lty=3, lwd=3, col="blue")
LATrendLine<-lm(deltaLA$Delta~deltaLA$year,data=deltaLA)
abline(LATrendLine, lty=3, lwd=3, col="red")

##set the legend
legend("bottomright", cex=.5, pt.cex=.5, lty=c(1, 3, 1, 3), lwd=c(2, 3, 2, 3), col=c("red", "red", "blue", "blue"), 
       legend=c("Los Angeles County", "LA County Trend", "Baltimore City", "Baltimore Trend"))

##write plot
dev.copy(png, file = "plot6.png", width=600, height=480) ## Copy my plot to a PNG file
dev.off()                                                ## close the PNG device