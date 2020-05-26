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
png(file='plot4.png', width=480, height=480)

# Set parameters for the multi-plot so it looks close to the sample image
par(mfrow=c(2,2), mar=c(5,5,4,1), cex=0.75)

with(projData, {
    ## Plot 1
    plot(DateTime, Global_active_power, bg='white', type='n', 
         xlab='', 
         ylab='Global Active Power'
    )
    # Add lines to this plot
    lines(DateTime, Global_active_power)
    
    ## Plot 2
    plot(DateTime, Voltage, type='n', bg='white', 
         xlab='datetime', 
         ylab='Voltage'
    )
    lines(DateTime, Voltage)
    
    ## Plot 3
    plot(DateTime, Sub_metering_1, type='n', bg='white', 
         xlab='', 
         ylab='Energy sub metering'
    )
    # Add lines for each Sub_metering_n 
    lines(DateTime, Sub_metering_1, col='black')
    lines(DateTime, Sub_metering_2, col='red')
    lines(DateTime, Sub_metering_3, col='blue')
    
    # Add a legend
    legend('topright', bty='n', 
           legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
           col=c('black', 'red', 'blue'), 
           lty=1
    )
    
    ## Plot 4
    plot(DateTime, Global_reactive_power, type='n', bg='white', 
         xlab='datetime', 
         ylab='Global_reactive_power'
    )
    lines(DateTime, Global_reactive_power)
})
# Close the graphics device
dev.off()