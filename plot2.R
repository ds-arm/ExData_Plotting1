######## Getting and transforming data
### Read in the data
#   Set location of data
dataFilePath <- "./exdata_data_household_power_consumption/household_power_consumption.txt"

# Make read more efficient by specifying column classes and using a slight 
#   overestimate of number of rows
fullData <- read.table(dataFilePath, header=TRUE, sep=';', na.strings = '?', 
                       colClasses = c(rep('character', times=2), 
                                      rep('numeric', times=7)), 
                       nrows=2100000   
)

### Subset and transform the data into a more usable form (and tidy)
#   Filter to the two dates sought using character version of dates
twoDates <- c('1/2/2007', '2/2/2007')
projData <- subset(fullData, fullData$Date %in% twoDates)
# Free up some memory by removing the full dataset
rm(fullData)

# Create a DateTime variable from the Date and Time variables
projData$DateTime <-strptime(paste(projData$Date, projData$Time, sep=' '), 
                             format='%d/%m/%Y %H:%M:%S')

# Drop the 'Date' and 'Time' columns now we have 'DateTime' which is class POSIXlt
projData <- subset(projData, select=-c(Date,Time))

# Make DateTime the first column without changing order of other columns
newColOrder <- c(which(colnames(projData)=='DateTime'), 
                 which(colnames(projData)!='DateTime'))
projData <- projData[,newColOrder]

######## Plotting
### Create the plot

# Open a graphics device that writes png to file
png(file='plot2.png', width=480, height=480)

# Construct the plot which will be directed to that graphics device
# First draw an axis without any data
plot(projData$DateTime, projData$Global_active_power, bg='white', type='n', 
     xlab='', 
     ylab='Global Active Power (kilowatts)'
     )

# Add lines to the plot
lines(projData$DateTime, projData$Global_active_power)

dev.off()