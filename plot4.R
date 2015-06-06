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

# Open graphics file
png(filename='plot4.png', width=480, height=480)

# Set for 2 x 2 plots (row order)
par(mfrow=c(2,2))
# First is same as plot 2 (except for no kilowatts)
with(ourdata, plot(Global_active_power ~ TS,type="l", xlab="", ylab="Global Active Power"))
# Second is plot of voltage versus time
with(ourdata, plot(Voltage ~ TS,type="l", xlab="datetime"))
# Third is same as plot 3 EXCEPT for outline of Legend (there is none)
with(ourdata, plot(Sub_metering_1 ~ TS, type="n", xlab="", ylab="Energy sub metering"))
with(ourdata, lines(Sub_metering_1 ~ TS, type="l"))
with(ourdata, lines(Sub_metering_2 ~ TS, type="l", col="Red"))
with(ourdata, lines(Sub_metering_3 ~ TS, type="l", col="Blue"))
legend("topright", legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col=c('Black', 'Red', 'Blue'), lty=c(1,1,1), bty="n")
# Fourth is graph of reactive power
with(ourdata, plot(Global_reactive_power ~ TS,type="l", xlab="datetime"))

# Close graphics file
dev.off()