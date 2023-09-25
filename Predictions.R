require(raster)
require(tidyverse)
require(sf)

DEM <- raster("./CroppedRasters/DEM.tif")
FH <- raster("./CroppedRasters/ForestHeight.tif")
TRI <- raster("./CroppedRasters/TRI.tif")
FL <- raster("./CroppedRasters/EliseData/FocalForestLoss.tif")
names(FL) <- "ForestLoss"
FP <- raster("./CroppedRasters/EliseData/FocalForest.tif")
names(FP) <- "ForestTot"

blop <- stack(DEM,TRI,FH, FL, FP)

plot(blop)

#finding the mean of the ranges 
# mean(c(0.1802, 0.2034, 0.2491, 0.1197,0.0437, 0.0778,0.3643,0.0892, 0.0564))


ef <- data.frame(coordinates(blop),
                 values(blop))

# doop <- values(blop)
# doop <- doop %>% na.omit



ef <- ef %>% na.omit

ef <- ef %>% mutate(pred = -2.7*(TRI) +0*(DEM) + 0*(ForestHeight) + 162*(log(ForestLoss+1/ForestTot))
                    + 125)

pred <- rasterFromXYZ(ef)

bound <- read_sf("./CroppedRasters/EliseData/comatsa_sud_boundary.shp")
crs(bound)

bound2 <- st_transform(bound, crs(DEM))

plot(pred$pred)
plot(bound2$geometry, add = TRUE)
