# Make directory for work data (project only wants 8 files in top)
dir.create("./data")
# URL for data source
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# If data set not downloaded already, fetch it
if (!file.exists("./data/household_power_consumption.zip")) {
  download.file(URL, destfile = "./data/household_power_consumption.zip", method="curl")
}
# If data set not extracted already, extract it
if (!file.exists("./data/household_power_consumption.txt")) {
  unzip("./data/household_power_consumption.zip", exdir="./data")
}
# Load full data set from CSV (note semicolon sep) - make ? be NA, and force Time and Date to character
data <- read.csv("./data/household_power_consumption.txt", sep=';', na.strings="?",
                 colClasses=c('character', 'character', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric'))
# Prune rows to just dates 02/01/2007, 02/02/2007
ourdata <- data[data$Date %in% c('1/2/2007', '2/2/2007'),]
# Create timestamp column from Date and Time
ourdata$TS <- as.POSIXct(paste(ourdata$Date, ourdata$Time), format="%d/%m/%Y %H:%M:%S")
# Finally, open graphics file
png(filename="plot2.png", width=480, height=480)
# Plot line graph
with(ourdata, plot(Global_active_power ~ TS,type="l", xlab="", ylab="Global Active Power (kilowatts)"))
# And close the device
dev.off()
