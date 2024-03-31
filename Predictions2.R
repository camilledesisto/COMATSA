require(raster)
require(tidyverse)
require(sf)
library(terra)

DEM <- raster("COMATSA_GitHub/Data/covariate_tif/ASTGTMV003_S15E049_dem.tif")
FH <- raster("COMATSA_GitHub/Data/covariate_tif/Forest_height_2019_SAFR.tif")
TRI <- raster("COMATSA_GitHub/Data/covariate_tif/TRI_Nov2023.tif")
FL <- raster("COMATSA_GitHub/Data/covariate_tif/Forest_Loss.tif")
names(FL) <- "ForestLoss"
bound <- read_sf("COMATSA_GitHub/Data/covariate_tif/comatsa_sud_boundary.shp")
buffer <- read_sf("COMATSA_GitHub/Data/covariate_tif/comatsa_buffer_sites.shp")
buffer <- st_transform(buffer, crs = 4326)
crs(FL)
crs(buffer)
FP <- raster("COMATSA_GitHub/Data/covariate_tif/FocalForest.tif")
names(FP) <- "ForestTot"

bb <- extent(buffer)

FL <- crop(x = FL, y = bb)
FH <- crop(x = FH, y = bb)
DEM <- crop(x = DEM, y = bb)
TRI <- crop(x = TRI, y = bb)
FP <- crop(x = FP, y = bb)

plot(TRI)
plot(DEM)
plot(FL)
plot(FH)
plot(FP)

extent(TRI)
extent(DEM)
extent(FL)
extent(FH)

ncol(TRI)
ncol(DEM)
ncol(FL)
ncol(FH)

FL <- projectRaster(FL,DEM,method = 'bilinear')
FH <- projectRaster(FH,DEM,method = 'bilinear')

stacked_habitat <- stack(DEM,TRI,FH, FL)
area(stacked_habitat)
plot(stacked_habitat)

ef <- data.frame(coordinates(stacked_habitat),
                 values(stacked_habitat))

colnames(ef)

ef <- ef %>% na.omit

ef <- ef %>%rename(DEM = Band.1.1, FL = ForestLoss, FH = Layer_1, TRI =Band.1.2) %>%mutate(pred =  0.2976*(TRI) + (-0.2939*(DEM)) + (11.9261*(FH)) + (-0.1255 *FL)
                    + 162.6222 )

pred <- rasterFromXYZ(ef)
pred$pred@data@values[pred$pred@data@values <0] <- 0

bound2 <- st_transform(bound, crs(DEM))

plot(pred$pred)
plot(bound2$geometry, add = TRUE)
plot(buffer$geometry, add = TRUE)
