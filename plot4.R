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
combustionRelated <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coalRelated <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coalCombustion <- (combustionRelated & coalRelated)
combustionSCC <- SCC[coalCombustion,]$SCC
combustionNEI <- sSCC[sSCC$SCC %in% combustionSCC,]

#graph no.4
g <- ggplot(combustionNEI,aes(factor(year),Emissions/1000)) 
g <- g + geom_bar(stat="identity",fill="green",width=0.75) + theme_bw() + guides(fill=FALSE) 
g <- g +  labs(x="year", y="Total PM 2.5 Emission (Thousands Tons)", title="PM 2.5 Coal Combustion Source Emissions Across US from 1999-2008")

print(g)

# Copy my plot to a PNG file
dev.copy(png, file = "plot4.png")  
dev.off()
