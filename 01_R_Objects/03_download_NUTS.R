#------------------------------------------------------------------#
####--------------- download in the NUTS -----------------------####
#------------------------------------------------------------------#

years.to.download <- c("2003", "2006", "2010", "2013", "2016" , "2021")

for (download.year in years.to.download) {
  for (NUTS.regions in 1:3) {
    NUTS.file <- get_eurostat_geospatial(resolution = "01", nuts_level = as.character(NUTS.regions), year = download.year)
    saveRDS(NUTS.file,
            file = paste0("01_R_Objects/01_NUTS/", download.year, "/NUTS", NUTS.regions, ".rds"))
  }
}