# A script to create the third plot "Energy sub metering"
# based on household power consumption data
# (household_power_consumption.txt)

library(methods)
library(data.table)

localDataFileName <- "./household_power_consumption.txt"
localPlotFileName <-  "./plot3.png"
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

with(householdPowerConsumptionDataTable,
     plot(DateTime, Sub_metering_1,
          type = "l",
          col = "black",
          xlab = "",
          ylab = "Energy sub metering"))

with(householdPowerConsumptionDataTable,
     lines(DateTime, Sub_metering_2,
           col = "red")
     )
     
with(householdPowerConsumptionDataTable,
     lines(DateTime, Sub_metering_3,
           col = "blue")
     )
 
legend("topright", lty=1, lwd=1,
       col=c("black", "red", "blue"), 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()
