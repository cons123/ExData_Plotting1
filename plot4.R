## file: plot4.R
## Downloads household power consumption data and generates a PNG format 
## image depicting 4 plots covering the period beginning 
## 2007-01-02 and ending 2007-02-02
##
## plot 1 is a plot showing global average power
## plot 2 is a plot showing Voltage
## plot 3 is a plot showing sub metering values
## plot 4 is a plot showing reactive power
##
## Args: 
##   None
##
## Returns:
##   writes out a PNG named plot1.png in the current working directory  


##
## configuration variable initialization to control behavior
##
## cv_plot_id   : plot instance... plot1, plot2, etc.
## cv_use_url   : flag used to specify if data is loaded via URL or local copy
## cv_url       : URL to source data
## cv_filename  : filename within source data zip file

cv_plot_id = "plot4"
cv_use_url = TRUE
cv_url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
cv_filename="household_power_consumption.txt"#

##
## set colclasses for use in read.table. 
##
cv_colclasses=c('character','character','numeric','numeric','numeric','numeric',
               'numeric','numeric','numeric')

if(cv_use_url == TRUE){
##
##  download source data from URL to temporary file
##  unzip and extract desired data file
##  use read.table to load line data
##  remove temporary file
##
  cat("downloading data from URL: ", cv_url, "\n")
  tf <- tempfile()
  download.file(cv_url,tf,method="curl")
  flines <- readLines(cv_filename)
  unlink(tf)
} else {
##
##  alternative code to use local file source
##
  flines <- readLines(cv_filename)
}

##
## identify rows of interest (header and February 1-2 of 2007) with grep
## use read.table and textconnection to load only lines of interest
##
cat("extracting relevant data for 2007-02-01 and 2007-02-02\n")
lidx <- grep("^Date|^1/2/2007|^2/2/2007",flines)
gdata <-read.table(textConnection(flines[lidx]), header=TRUE, sep=";", 
                   na.strings="?", colClasses=cv_colclasses)

##
##  add DateTime column combining Date and Time columns in data 
##

gdata$DateTime <- as.POSIXct(strptime(paste0(gdata$Date," ",gdata$Time),"%d/%m/%Y %H:%M:%S"))

##
## generate png file
##
cat(paste0("generating PNG plot in file ",cv_plot_id,".png\n"))

png(paste0(cv_plot_id,".png"),width=480,height=480,bg="transparent")
par(mfrow=c(2,2))
## plot 1
with(gdata,plot(DateTime,Global_active_power,type="l",lty=1,xlab="", 
                ylab="Global Active Power"))

## plot 2
with(gdata,plot(DateTime,Voltage,type="l",lty=1,xlab="datetime",
                ylab="Voltage"))

## plot 3
with(gdata,plot(DateTime,Sub_metering_1,col="black",typ="l",lty=1,
                ylab="Energy sub metering",xlab=""))
with(gdata,lines(DateTime,Sub_metering_2,col="red"),typ="l",lty=1)
with(gdata,lines(DateTime,Sub_metering_3,col="blue"),typ="l",lty=1)
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1),bty="n",col=c("black","red","blue"),cex=0.9)

## plot 4
with(gdata,plot(DateTime,Global_reactive_power, typ="l",lty=1,xlab="datetime",
                ylab="Global_reactive_power"))



##
## shutting off graphics device
##
dev.off()

##
## routine complete.  file should be in working directory
##

cat("complete\n")




