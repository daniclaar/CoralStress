
# Load necessary packages
library(ncdf4)
library(chron)
library(lattice)
library(RColorBrewer)

# Clear the working environment
rm(list=ls())


############### Get DHW for every day of a year, at a specific lat/lon #####################
# Open the netcdf file
nc <- nc_open("DHW_1985_Daily_Claar_V1.0.nc")
# Look at the netcdf file metadata
print(nc)

# Choose a lat/lon pair to extract data from
LonIdx <- which( nc$dim$lon$vals == 157)
LatIdx <- which( nc$dim$lat$vals == 2)
# DayIdx <- which( nc$dim$day$vals > 10 & nc$dim$day$vals < 20)
dhw <- ncvar_get( nc, "DHW")[LonIdx, LatIdx, ]

# Close the netcdf file --!!IMPORTANT!! otherwise you might corrupt your netcfd file
nc_close(nc)



############### This is the whole netcdf file, as an R matrix #####################
############## It is very big, and probably not that useful... ####################
nc <- nc_open("DHW_1985_Daily_Claar_V1.0.nc")
dhw_full <- ncvar_get( nc, "DHW")
# get longitude and latitude
lon <- ncvar_get(nc,"Lon")
nlon <- dim(lon)
head(lon)
lat <- ncvar_get(nc,"Lat")
nlat <- dim(lat)
head(lat)
nc_close(nc)

str(dhw_full)

# Get a single slice or layer (day 100 of the year)
# Choose your day
d <- 100
# Slice the full dataset to only include that day
dhw_slice <- dhw_full[,,d]
# Check dimensions of the slice
# dim(dhw_slice)

# Basic image plot of this slice
image(lat,lon,dhw_slice, col=rev(brewer.pal(10,"RdBu")), zlim = c(0,12)) 

# If you want to extract the units, title, source, refs....etc:
# tunits <- ncatt_get(nc,"day","units")
# title <- ncatt_get(nc,0,"title")
# datasource <- ncatt_get(nc,0,"source")
# references <- ncatt_get(nc,0,"references")
# history <- ncatt_get(nc,0,"history")
# Conventions <- ncatt_get(nc,0,"Conventions")

# A prettier image plot of this slice
# levelplot of the slice
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(dhw_slice ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))))



# create dataframe -- reshape data
# matrix (nlon*nlat rows by 2 cols) of lons and lats
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)
# vector of `tmp` values
dhw_vec <- as.vector(dhw_slice)
length(dhw_vec)

# create dataframe and add names
dhw_df01 <- data.frame(cbind(lonlat,dhw_vec))
names(dhw_df01) <- c("lon","lat","dhw")
head(na.omit(dhw_df01), 10)

# Transform into a vector
dhw_vec_long <- as.vector(dhw_full)
length(dhw_vec_long)

# Transform into a long matrix
dhw_mat <- matrix(dhw_vec_long, nrow=nlon*nlat, ncol=365)
dim(tmp_mat)