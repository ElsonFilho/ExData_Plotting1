# Course Project 1:  Electric power consumption 
#
# Elson Felix Mendes Filho - pricotu@outlook.com
# 05.08.2015

# Introduction
## This assignment uses data from the UC Irvine Machine Learning Repository, in particular, we will 
## be using the "Individual household electric power consumption Data Set" available on the
## course web site: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

# Description: 
## Measurements of electric power consumption in one household with a one-minute sampling rate 
## over a period of almost 4 years. Different electrical quantities and some sub-metering values 
## are available.

## The following descriptions of the 9 variables in the dataset are taken from the UCI web site:
## Date: Date in format dd/mm/yyyy
## Time: time in format hh:mm:ss
## Global_active_power: household global minute-averaged active power (in kilowatt)
## Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
## Voltage: minute-averaged voltage (in volt)
## Global_intensity: household global minute-averaged current intensity (in ampere)
## Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). 
##       It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave.
## Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). 
##       It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a 
##       refrigerator and a light.
## Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). 
##       It corresponds to an electric water-heater and an air-conditioner.


# I've used the sqldf package in order to read only the data about the required period.
#install.packages("sqldf")
library(sqldf)


# Download the zip file from the url and unzip it.
dataset_url <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataset_url, "exdata%2Fdata%2Fhousehold_power_consumption.zip")
unzip("exdata%2Fdata%2Fhousehold_power_consumption.zip")


# Read the data for the relavant period
EPCdata <- read.csv.sql("./household_power_consumption.txt", sep=";", 
                        sql = "select * from file where Date in ('1/2/2007', '2/2/2007')", 
                        colClasses = rep("character", 9))
# Change the Variables on colunms 3 to 9 to numeric
EPCdata[,3:9] <- lapply(EPCdata[,3:9], as.numeric)

# Create a DateTime variable. And convert the Date from character to Date. 
EPCdata$DateTime <- strptime(paste(EPCdata$Date, EPCdata$Time), format="%d/%m/%Y %H:%M:%S")
EPCdata$Date<-as.Date(EPCdata$Date,"%d/%m/%Y")
# class(EPCdata$DateTime)     # just to verify it
# class(EPCdata$Date)         # just to verify it


# Each of the Plots is saved at the current working directory of R as PNG file (480x480). 

# Plot 3 - Energy sub metering per datetime
## On this plot we have 3 lines, one per sub-metering series, with different colors and a legend. 

# Define the series and colors to be used
plot_series <- c("Sub_metering_1", "Sub_metering_2","Sub_metering_3")
plot_color <- c("black", "red", "blue")

# Create the plot
with(EPCdata, plot(DateTime, xlab="", Sub_metering_1, ylab="Energy sub metering", 
                   type="l", col=plot_color[1]))
with(EPCdata, lines(DateTime,Sub_metering_2, type="l", col=plot_color[2]))
with(EPCdata, lines(DateTime,Sub_metering_3, type="l", col=plot_color[3]))
legend("topright", legend = plot_series, lty=1, lwd=c(2.5,2.5, 2.5), col=plot_color,
       pch=1, cex = .7)

## Copy my plot to a PNG file
dev.copy(png, file = "Plot3.png", width = 480, height = 480, units = "px") 
dev.off()
