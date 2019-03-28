# Load necessary packages
library(ncdf4)
library(lattice)

############################
# Extracting MMM from CoralStress data
# Extract NOAA MMM by lat/lon
nc <- nc_open("NetCDF/Maximum_Monthly_Means_Indices_Claar_V1.0.nc") # Open netcdf file
lon <- ncvar_get(nc,"Lon") # get longitude for reference
lat <- ncvar_get(nc,"Lat") # get latitude for reference
names(nc$var) # Check the names to pick what to extract
sst_CoralStress_clim_full <- ncvar_get( nc, "Mean_Monthly_Maximum_SST") # Extract whole globe, can subset by lat/lon later
nc_close(nc) # Close the netcdf file --!!IMPORTANT!! otherwise you might corrupt your netcfd file

save(sst_CoralStress_clim_full, file="Claaretal2018_data/Maximum_Monthly_Means_Indices_Claar_V1.0_MMM.RData")
