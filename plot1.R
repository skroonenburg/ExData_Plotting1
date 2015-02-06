library(data.table)
require(data.table)

readData <- function()
{
  # Only read the data from the relevant dates
  # I've done this by hardcoding the lines from the text file to read,
  # such that only the required lines are read and the performance
  # of this script is optimised
  data <- read.table('household_power_consumption.txt', sep = ';', na.strings="?", skip=66637,nrows=2880, stringsAsFactors = FALSE)
  
  # Because only specific lines are read, the header line is not -- and therefore the column 
  # names must be specified manually
  names(data) = c('Date','Time','Global_active_power','Global_reactive_power','Voltage','Global_intensity','Sub_metering_1','Sub_metering_2','Sub_metering_3')

  # Convert the Time & Date columns to appropriate data types
  data$Time = strptime(paste(data$Date, data$Time, sep = ' '), "%d/%m/%Y %H:%M:%S")
  data$Date = as.Date(data$Date, "%d/%m/%Y")
  
  data
}

# Open the PNG device
png(file = "plot1.png", bg = "transparent", width = 480, height = 480)

# Read the relevant data from a file
data <- readData()

# Render the histogram
hist(data$Global_active_power,
     col = 'RED',
     xlab = 'Global Active Power (kilowatts)',
     ylab = 'Frequency',
     main = 'Global Active Power')

# Close the PNG device
dev.off()
