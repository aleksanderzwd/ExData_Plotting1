# A script to create the fourth plot (a set of four different plots)
# based on household power consumption data
# (household_power_consumption.txt)

library(methods)
library(data.table)

localDataFileName <- "./household_power_consumption.txt"
localPlotFileName <-  "./plot4.png"
plotStrDates      <- c("1/2/2007", "2/2/2007")

# -- Preparing data --

system.time(
        householdPowerConsumptionDataTable
        <- fread(localDataFileName, sep = ";",
                 header = TRUE,
                 data.table = TRUE,
                 na.strings = c("?",""),
                 nrows = -1,
                 colClasses = c(rep("character",9)))
)

dim(householdPowerConsumptionDataTable)
object.size(householdPowerConsumptionDataTable)

householdPowerConsumptionDataTable <-
        householdPowerConsumptionDataTable[
                householdPowerConsumptionDataTable$Date %in% plotStrDates,
                ]

householdPowerConsumptionDataTable[,
                                   DateTime := as.POSIXct(
                                           paste(Date, Time),
                                           format = "%d/%m/%Y %H:%M:%S")]

for(colName in names(householdPowerConsumptionDataTable)[3:9]) {
        householdPowerConsumptionDataTable[, (colName)
                                           := as.numeric(get(colName))]    
}

dim(householdPowerConsumptionDataTable)
object.size(householdPowerConsumptionDataTable)


# -- Creating a plot --

png(filename = localPlotFileName,
    width = 480, height = 480, units = "px")

Sys.setlocale("LC_TIME", "C");

par(mfcol=c(2,2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

with(householdPowerConsumptionDataTable, {
        
        # the plot number 1
        plot(DateTime, Global_active_power,
             type = "l",
             xlab = "",
             ylab = "Global Active Power")
        
        # the plot number 2
        plot(DateTime, Sub_metering_1,
             type = "l",
             col = "black",
             xlab = "",
             ylab = "Energy sub metering")
        lines(DateTime, Sub_metering_2, col = "red")
        lines(DateTime, Sub_metering_3, col = "blue")
        legend("topright", lty=1, lwd=1,
               col=c("black", "red", "blue"), 
               bty="n",
               legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

        # the plot number 3
        plot(DateTime, Voltage,
             type = "l",
             xlab = "datetime",
             ylab = "Voltage")
        
        # the plot number 4
        plot(DateTime, Global_reactive_power,
             type = "l",
             xlab = "datetime")
        
})

dev.off()
