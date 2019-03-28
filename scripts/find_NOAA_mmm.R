load("NOAA/ct5km_climatology_v3.1_MMM.RData")

latIdx <- which(abs(lat-lat_in)==min(abs(lat-lat_in)))
lonIdx <- which(abs(lon-lon_in)==min(abs(lon-lon_in)))

mmm_out <- sst_NOAA_clim_full[lonIdx,latIdx]
