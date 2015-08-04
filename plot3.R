## file: plot3.R
## Downloads household power consumption data and generates a PNG format 
## line plot for Sub Metering parameters 1,2,3 over period beginning
## 2007-01-02 and ending 2007-02-02
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

cv_plot_id = "plot3"
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
png(paste0(cv_plot_id,".png"),width=480,height=480)

with(gdata,plot(DateTime,Sub_metering_1,col="black",type="l",lty=1,ylab="Energy sub metering",xlab=""))
with(gdata,lines(DateTime,Sub_metering_2,col="red"))
with(gdata,lines(DateTime,Sub_metering_3,col="blue"))
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1),col=c("black","red","blue"))

dev.off()

##
## routine complete.  file should be in working directory
##

cat("complete\n")




