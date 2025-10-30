if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars,
               here)

#Crop -------------------------------------------------------------------

## US-wide precipitation layer
(spr_prec <- rast("data/spr_prec_us.tif"))

## visualization
ggplot() +
  geom_spatraster(data = spr_prec)

## ext returns the extent of layer
ext(spr_prec)

## copp function, direct entry of lat/lon
## order matters C(xmin, xmax, ymin, ymax)
spr_prec_crop <- crop(x = spr_prec,
     y = c(-80, -75, 34, 37))

ext(spr_prec_crop)

## check coverage visully
sf_nc_county <- readRDS("data/sf_nc_county.rds")

ggplot() +
  geom_spatraster(data = spr_prec_crop) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)

## use vector layer as a mask layer '
## no need to enter raw lat/lon directly 
spr_prec_nc <- crop(x = spr_prec,
     y = sf_nc_county)

ggplot() +
  geom_spatraster(data = spr_prec_nc) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)
##MERGE-----------------------------------------------------

spr_nw <- rast("data/spr_prec_ncnw.tif") # Northwest NC
spr_ne <- rast("data/spr_prec_ncne.tif") # Northeast NC
spr_sw <- rast("data/spr_prec_ncsw.tif") # Southwest NC
spr_se <- rast("data/spr_prec_ncse.tif") # Southeast NC

##visualize northwest
ggplot() +
  geom_spatraster(data = spr_nw) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)

## use merge() function
spr_n <- merge(spr_nw, spr_ne)

ggplot() +
  geom_spatraster(data = spr_n) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)

## compare extent btwn spr_nw and spr_n
ext(spr_nw)
ext(spr_n)

## merge more than 2 raster layers
## 1st step: create a list of raster layers
list_spr <- list(spr_ne,
     spr_nw,
     spr_se,
     spr_nw)

spr_col<- sprc(list_spr)
spr_merge <- merge(spr_col)

ggplot() +
  geom_spatraster(data = spr_merge) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


writeRaster(spr_merge, 
            filename = "data/spr_prec_nc.tif",
            overwrite = TRUE)

##STACK------------------------------------------------------------------

spr_prec_nc <- rast("data/spr_prec_nc.tif")
spr_tmp_nc <- rast("data/spr_tmp_nc.tif")

spr_pt_nc <- c(spr_prec_nc,
               spr_tmp_nc)

print(spr_pt_nc)


##access each layer separatley
# precipitation
spr_pt_nc$precipitation
spr_pt_nc$temperature

###Reprojection-----------------------------------------------------------

print(spr_prec_nc)

## reprojection for raster

spr_prec_nc_proj <- project(x = spr_prec_nc,
        y = "EPSG:32617",
        method = "bilinear")

##Exercise----------------------------------------------------------------

#merge raster
spr_tmp_ncnw <- rast("data/spr_tmp_ncnw.tif")
spr_tmp_ncne <- rast("data/spr_tmp_ncne.tif")
spr_tmp_ncsw <- rast("data/spr_tmp_ncsw.tif")
spr_tmp_ncse <- rast("data/spr_tmp_ncse.tif")

spr_tmp <- merge(spr_tmp_ncnw,
                 spr_tmp_ncne,
                 spr_tmp_ncsw,
                 spr_tmp_ncse)
ggplot() +
  geom_spatraster(data = spr_tmp) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


##crop raster to a defined text 

sf_nc_county <- readRDS("data/sf_nc_county.rds")

sf_camden <- filter(sf_nc_county, county == "camden")

ext(sf_camden)

spr_tmp_camden <- crop(x = spr_merge,
                       y = sf_camden)


ggplot() +
  geom_spatraster(data = spr_tmp_camden) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25) +
  theme_bw()

##reprojection
spr_tmp_camden_proj <- project(x = spr_tmp_camden,
        y = "EPSG:32618")




