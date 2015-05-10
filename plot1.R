# A script to create the first plot "Global Active Power"
# based on household power consumption data
# (household_power_consumption.txt)

library(methods)
library(data.table)

localDataFileName <- "./household_power_consumption.txt"
localPlotFileName <-  "./plot1.png"
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

hist(
        householdPowerConsumptionDataTable$Global_active_power,
        main = "Global Active Power",
        xlab = "Global Active Power (kilowatts)",
        col = "red"
        )

dev.off()

