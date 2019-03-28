rm(list=ls())

# Load necessary packages
library(ncdf4)
library(lattice)

### Extract NOAA MMM by lat/lon
nc <- nc_open("NOAA/ct5km_climatology_v3.1.nc") # Open netcdf file
lon <- ncvar_get(nc,"lon") # get longitude for reference
lat <- ncvar_get(nc,"lat") # get latitude for reference
names(nc$var) # Check the names to pick what to extract
sst_NOAA_clim_full <- ncvar_get( nc, "sst_clim_mmm") # Extract whole globe, can subset by lat/lon later
nc_close(nc) # Close the netcdf file --!!IMPORTANT!! otherwise you might corrupt your netcfd file

save(list=c("sst_NOAA_clim_full","lon","lat"), file="NOAA/ct5km_climatology_v3.1_MMM.RData")

