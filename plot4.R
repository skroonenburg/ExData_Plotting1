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

drawGlobalActivePowerGraph <- function(data)
{
  plot(data$Time, data$Global_active_power, type="l", ylab = 'Global Active Power (kilowatts)', xlab = '')
}

drawEnergySubmeteringGraph = function(data) {
  plot(data$Time, data$Sub_metering_1, type="n", ylab = 'Energy sub metering', xlab = '')
  lines(data$Time, data$Sub_metering_1, col = "black")
  lines(data$Time, data$Sub_metering_2, col = "red")
  lines(data$Time, data$Sub_metering_3, col = "blue")
  legend("topright", pch = "_", col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
}

drawVoltageGraph <- function(data)
{
  plot(data$Time, data$Voltage, type="l", ylab = 'Voltage', xlab = 'datetime')
}

drawGlobalReactivePowerGraph <- function(data)
{
  plot(data$Time, data$Global_reactive_power, type="l", ylab = 'global_reactive_power', xlab = 'datetime')
}

# Open the PNG device
png(file = "plot4.png", bg = "transparent", width = 480, height = 480)

# Read the relevant data from a file
data <- readData()

# Setup 2 rows and 2 columns of graphs to display
par(mfrow = c(2,2))
par(mfcol = c(2,2))

# Render the 4 graphs
drawGlobalActivePowerGraph(data)
drawEnergySubmeteringGraph(data)
drawVoltageGraph(data)
drawGlobalReactivePowerGraph(data)

# Close the PNG device
dev.off()