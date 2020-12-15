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

# Subset the vehicles data to Baltimore's fip
baltimoreVehicles <- vehiclessSCC[vehiclessSCC$fips=="24510",]

#graph no.5
g <- ggplot(baltimoreVehicles,aes(factor(year),Emissions)) 
g <- g + geom_bar(stat="identity",fill="magenta",width=0.75) + theme_bw() + guides(fill=FALSE) 
g <- g +  labs(x="year", y="Total PM 2.5 Emission (Tons)", title="PM 2.5 Motor Vehicle Source Emissions in Baltimore from 1999-2008")

print(g)

# Copy my plot to a PNG file
dev.copy(png, file = "plot5.png")  
dev.off()
