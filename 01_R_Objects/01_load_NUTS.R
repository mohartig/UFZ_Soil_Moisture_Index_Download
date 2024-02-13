#------------------------------------------------------------------#
####--------------- DEFINE THE NUTS FILE TO BE USED ------------####
#------------------------------------------------------------------#

## load function for next lower year
source("01_R_Objects/02_next_year_function.R")

## get the next smaller year
NUTS.year <- getNextYear(years, c("2003", "2006", "2010", "2013", "2016" , "2021"))

#------------------------------------------------------------------#
####--------------- LOAD IN THE NUTS POLYGONS ------------------####
#------------------------------------------------------------------#

NUTS1 <- readRDS(paste0("01_R_Objects/01_NUTS/", NUTS.year, "/NUTS1.rds"))
NUTS2 <- readRDS(paste0("01_R_Objects/01_NUTS/", NUTS.year, "/NUTS2.rds"))
NUTS3 <- readRDS(paste0("01_R_Objects/01_NUTS/", NUTS.year, "/NUTS3.rds"))

#### --------------------------- GERMANY ---------------------- ####
NUTS1.germany <- NUTS1[NUTS1$CNTR_CODE %in% "DE", ]
NUTS2.germany <- NUTS2[NUTS2$CNTR_CODE %in% "DE", ]
NUTS3.germany <- NUTS3[NUTS3$CNTR_CODE %in% "DE", ]

NUTS1.germany.transformed <- st_transform(NUTS1.germany, crs = crs.EEA)
NUTS2.germany.transformed <- st_transform(NUTS2.germany, crs = crs.EEA)
NUTS3.germany.transformed <- st_transform(NUTS3.germany, crs = crs.EEA)