#Load Principle libraries
library(dplyr)
library(ggplot2)
library(scales)
library(data.table)


rfilename <- "exdata_data_NEI_data.zip"

# Checking if file exists.
if (!file.exists(rfilename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, rfilename)
}  

# Checking if folder exists
if (!file.exists("Source_Classification_Code.rds")) { 
  unzip(rfilename) 
}

# Reading rds Files in current working Directory
sSCC <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset coal combustion related data
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclessSCC <- sSCC[sSCC$SCC %in% vehiclesSCC,]

# Subset the vehicles data to Baltimore and Los Angeles fip
baltimoreVehicles <- vehiclessSCC[vehiclessSCC$fips=="24510",]
baltimoreVehicles$city <- "Baltimore"
laVehicles <- vehiclessSCC[vehiclessSCC$fips=="06037",]
laVehicles$city <- "Los Angeles"

totales <-  rbind(baltimoreVehicles,laVehicles)

#graph no.6
g <- ggplot(totales,aes(x=factor(year),y=Emissions,fill=city)) + facet_grid(. ~ city)
g <- g + geom_bar(stat="identity",width=0.75) + theme_bw() + guides(fill=FALSE) 
g <- g +  labs(x="year", y="Total PM 2.5 Emission (Tons)", title="PM 2.5 Motor Vehicle Source Emissions from 1999-2008")
print(g)

# Copy my plot to a PNG file
dev.copy(png, file = "plot6.png")  
dev.off()
