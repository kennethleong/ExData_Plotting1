
#Download the data if it isn't downloaded yet
txt <- "household_power_consumption.txt"
if(!file.exists(txt)) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  zip <- "exdata-data-household_power_consumption.zip"
  download.file(url, zip)
  unzip(zip)
}

#Estimate how much memory the dataset will require
#memory per record = (for each character variables * its max length * 8) + (number of numeric variables * 8)
#                  = (10 * 8 (for Date)) + (8 * 8 (for Time)) + (7 * 8)
memRec <- (10*8) + (8*8) +  (7*8)
#memory = number of record * memory per record * 2 (to handle overhead)
mem <- 2075259 * memRec * 2
memGB <- mem / (2^30)
#0.7730942

#Load only data from the dates 2007-02-01 and 2007-02-02
library(sqldf)
df <- read.csv.sql(txt, colClasses=c("dmy"), sep=";", sql="SELECT * FROM file WHERE Date='1/2/2007' OR Date='2/2/2007'")
df[df=="?"] <- NA #Replace '?'

#Create a continuous DataTime column
df$DateTime <- paste(strptime(df$Date, "%d/%m/%Y"), df$Time)
df$DateTime <- as.POSIXct(df$DateTime) 

#Plot
par(mar=c(3,5,1,1))
plot(df$Global_active_power ~ df$DateTime, type="l", ylab="Global Active Power (kilowatts)", xlab="") 

#Save as PNG
dev.copy(png, file="plot2.png", height=480, width=480)
dev.off() 

