##Plot total emissions from PM2.5 in the United States from 1999-2008 for coal
##combustion-related source.  It is assumed that combustion-related sources can
##be identified by selecting all Source Code Classifications (SSCs) from the 
##Source Code Classification table where the term "coal" is found in the EI.Sector
##field.

##This script assumes the NEI and Source Classification Code databases are in
##the current working directory.

NEI<-readRDS("summarySCC_PM25.rds")
SCC<-readRDS("Source_Classification_Code.rds")

##Plot 4
coalSSCs<-SCC[grep("Coal", SCC$EI.Sector),1]
coalSubset<-NEI[NEI$SCC %in% coalSSCs,]
NEIcoalTot<-aggregate(coalSubset$Emissions, list(coalSubset$year), sum)
NEIyearTotnames<-c("year", "TotalEmissions")
colnames(NEIcoalTot)<-NEIyearTotnames

plot(NEIcoalTot$year, NEIcoalTot$TotalEmissions, ylim=c(330000,600000), pch=7, 
     col="red", xlab="Year", ylab="Total Emission", 
     main="Coal Combustion-related Emissions, US 1999-2008 \n (downward trend)")
TrendLine<-lm(NEIcoalTot$TotalEmissions~NEIcoalTot$year,data=NEIcoalTot)
abline(TrendLine, lty=3)
legend("topright", pch=7, col=c("red"), legend=c("Total Emissions"), cex=.8, pt.cex=.8)

dev.copy(png, file = "plot4.png", width=600) ## Copy my plot to a PNG file
dev.off()                                                ## close the PNG device