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

# Graph no. 1
totales <- aggregate(Emissions ~ year,sSCC, sum)
barplot(totales$Emissions/1000000, names.arg=totales$year, col = "blue",xlab="Year", ylab="PM2.5 Emissions (Million Tons)",main="Total PM2.5 Emissions From All US Sources")

# Copy my plot to a PNG file
dev.copy(png, file = "plot1.png")  
dev.off()