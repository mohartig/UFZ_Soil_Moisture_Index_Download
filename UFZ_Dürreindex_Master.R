
#------------------------------------------------------------------#
## This R script automates the process of downloading and visualizing 
## soil moisture across Germany's NUTS-3 regions, using data from the 
## UFZ Dürreindex (drought index). Initially, it clears the workspace 
## and loads necessary libraries (terra for spatial data manipulation 
## and ggplot2 for plotting). It sets the working directory to a 
## specified location where all files related to the UFZ Soil Moisture 
## Index are stored. The script defines a Coordinate Reference System (CRS) 
## for spatial data, downloads the UFZ soil moisture dataset (in NetCDF format),
## and then processes this data by setting an appropriate CRS, renaming raster 
## layers based on dates, and handling missing values. It calculates yearly 
## averages from the monthly data and associates these averages with 
## corresponding NUTS-3 polygons, adjusting for spatial consistency. 
## Finally, it visualizes these averaged values in maps for each year,
## saving both the plots and the data frames with NUTS IDs and average 
## soil moisture values for further use. The process involves spatial 
## transformation, extraction of average values for polygons, and the 
## creation of visually maps to represent the soil moisture index over time.
# 
## for questions, contact: moritz.hartig@icloud.com 
#------------------------------------------------------------------#

rm(list = ls())

library("terra")
library("ggplot2")

setwd("C:/Users/hartig3/Desktop/UFZ_Soil_Moisture_Index/")

#------------------------------------------------------------------#
####-------------- 1. LOAD NUTS-3 POLYGONS / OTHERS ------------####
#------------------------------------------------------------------#

## DO YOU NEED TO RE-DOWNLOAD THE NUTS-POLYGONS?
re.download <- FALSE
if(re.download == TRUE){source("01_R_Objects/03_download_NUTS.R")}

## SET CRS FOR ALL INPUTS
crs.EEA <- readRDS("01_R_Objects/EEA_crs.rda")

#------------------------------------------------------------------#
####-------------- 2. DOWNLOAD UFZ DÜRREINDEX ------------------####
#------------------------------------------------------------------#

## URL of the NetCDF file
file.url <- "https://files.ufz.de/~drought/SMI_Gesamtboden_monatlich.nc"

## Download the file
download.file(file.url, destfile = "02_Data/SMI_Gesamtboden_monatlich.nc", mode = "wb")

#------------------------------------------------------------------#
####-------------- 3. MODIFY UFZ DÜRREINDEX --------------------####
#------------------------------------------------------------------#

## check nc file
nc.data <- nc_open("02_Data/SMI_Gesamtboden_monatlich.nc")
print(nc.data)
nc_close(nc.data)

## load nc file
UFZ.SMI <- terra::rast("02_Data/SMI_Gesamtboden_monatlich.nc")

## set proper CRS
crs(UFZ.SMI) <- crs("EPSG:31468")

## rename raster layers
names(UFZ.SMI) <- format(seq(as.Date("1951-01-01"), as.Date("2022-12-01"), by="month"), "%Y-%m")

## Replace NaN values with NA
values(UFZ.SMI)[is.nan(values(UFZ.SMI))] <- NA

## Number of years in the dataset
num.years <- dim(UFZ.SMI)[3] / 12

## Initialize an empty raster to store the yearly sums
UFZ.SMI.Year <- terra::rast(UFZ.SMI, nlyr = num.years)

## Loop through each year and sum up the layers
for (i in 1:num.years) {
  yearly.layers <- (1:12) + (i - 1) * 12
  yearly.subset <- subset(UFZ.SMI, yearly.layers)
  
  # Calculate the mean for each cell across the yearly subset
  # Note: terra::mean calculates the mean for each cell across layers
  UFZ.SMI.Year[[i]] <- terra::mean(yearly.subset)
}

## Set names for the yearly layers, optional
names(UFZ.SMI.Year) <- 1951:(1950 + num.years)

#------------------------------------------------------------------#
####-------------- 4. ADD THE AVERAGE VALUE TO NUTS3 -----------####
#------------------------------------------------------------------#

for (year.UFZ in 1:dim(UFZ.SMI.Year)[3]) {
  
  ## load NUTS 3
  years <- year.UFZ + 1950
  source("01_R_Objects/01_load_NUTS.R")
  
  ## Tranform polygon to fit crs
  NUTS3.germany.ttransformed <- st_transform(NUTS3.germany.transformed, st_crs(UFZ.SMI.Year))
  
  ## Calculate the average values for each polygon
  average_values <- terra::extract(UFZ.SMI.Year[[year.UFZ]], NUTS3.germany.ttransformed, fun = mean, na.rm = TRUE)
  names(average_values) <- c("ID", "UFZ_SMI")
  
  ## Add the average values as a new column to NUTS3.germany.transformed
  NUTS3.germany.transformed$average.raster.value <- average_values$UFZ_SMI
  
  ## Create the plot with a minimal theme
  p <- ggplot(data = NUTS3.germany.transformed) +
    geom_sf(aes(fill = cut(average.raster.value, breaks = 5)), size = 0.01, show.legend = TRUE) +  # Set size for thinner borders
    scale_fill_manual(values = viridis::viridis(5), guide = guide_legend(title = "Index Value")) + # Manual scale for discrete values
    labs(title = "UFZ Soil Moisture Index") +
    theme_void() +  # Use theme_void for minimal non-data ink
    theme(legend.position = "right", # Adjust legend position
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  ## save plot
  ggsave(paste0("03_Graphics/UFZ_SMI_", (1950 + year.UFZ),".png"),
         plot = p, width = 10, height = 8, units = "in")
  
  ## Combine NUTS IDs and average raster values into a single dataframe
  data <- data.frame("NUTS_ID" = NUTS3.germany.transformed$NUTS_ID,
                     "UFZ_SMI" = as.numeric(NUTS3.germany.transformed$average.raster.value))
  
  ## Save the dataframe as an RDS file at the specified location
  saveRDS(data, file = paste0("02_Data/UFZ_SMI_", (1950 + year.UFZ),".Rds"))
}
