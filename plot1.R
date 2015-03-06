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
pdf(file=file.path(wd, 'plot1.png'))
with(dataofinterest,
     hist(Global_active_power, col='red',
          main='Global Active Power',
          xlab='Clobal Active Power (kilowatts)'))
dev.off()
