#!/usr/bin/Rscript
#
# The script needs an internet connection to download data.
# Otherwise you have to provide either unzipped data file
# ('household_power_consumption.txt') or the downloaded
# ZIP archive (named 'data.zip') in the working directory.
#
# The output file (PNG image) is written to the working directory.

#data download and extraction (if necessary)
wd <- getwd()
filename <- 'household_power_consumption.txt'
csvfile <- file.path(wd, filename)
if (!file.exists(csvfile))
{
  zipfile <- file.path(wd, 'data.zip')
  if (!file.exists(zipfile))
  {
    url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    download.file(url, zipfile, method="curl")
  }
  unzip(zipfile, c(filename), exdir = wd)
}

#data loading
data <- read.table(csvfile, header=T, sep=';', na.strings='?',
                   colClasses=c('factor', 'factor', 'numeric', 'numeric', 'numeric',
                                'numeric', 'numeric', 'numeric', 'numeric'))
datatransformed <- transform(data, datetime=strptime(paste(Date, Time), format='%e/%m/%Y %H:%M:%s'))
datatransformed$Date <- NULL
datatransformed$Time <- NULL

#filtering
start <- strptime('2007-02-01', format='%Y-%m-%d')
end <- strptime('2007-02-03', format='%Y-%m-%d')
dataofinterest <- subset(datatransformed, start <= datetime & datetime < end)

#plotting
library(graphics)
png(file=file.path(wd, 'plot2.png'), width=480, height=480, res=72,
    bg='transparent')
with(dataofinterest,
{
  plot(datetime, Global_active_power, type='n',
       xlab='', ylab='Global Active Power (kilowatts)')
  lines(datetime, Global_active_power, col='black')
})
dev.off()
