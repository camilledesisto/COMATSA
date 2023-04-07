require(raster)
require(tidyverse)
DEM <- raster("./CroppedRasters/DEM.tif")
FH <- raster("./CroppedRasters/ForestHeight.tif")
TRI <- raster("./CroppedRasters/TRI.tif")

blop <- stack(DEM,TRI,FH)

plot(blop)


ef <- data.frame(coordinates(blop),
                 values(blop))

# doop <- values(blop)
# doop <- doop %>% na.omit



ef <- ef %>% na.omit

ef <- ef %>% mutate(pred = 3.5*(TRI) -2.1*(DEM) + 2*(ForestHeight))


pred <- rasterFromXYZ(ef)
plot(pred$pred)
