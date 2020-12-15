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

sSCC <- sSCC[sSCC$fips=="24510",]


# Graph no. 3
sSCC$type <- factor(sSCC$type, levels = c("ON-ROAD", "NON-ROAD", "POINT", "NONPOINT")) # Re-order 

g <- ggplot(sSCC,aes(factor(year),Emissions),fill = type) 
g <- g + geom_bar(aes(fill = type),stat = "identity") + guides(fill=FALSE) + facet_grid(. ~ type)
g <- g  + labs(x="year", y="Total PM25 Emission (Tons)",title="PM2.5 Emissions Baltimore City 1999-2008 by Source Type")
g <- g + theme(axis.text.x=element_text(angle = 90, vjust = 0.5, hjust = 1))

print(g)



# Copy my plot to a PNG file
dev.copy(png, file = "plot3.png")  
dev.off()