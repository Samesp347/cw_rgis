if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars,
               here)



# Read/Export Raster data -------------------------------------

# Read geotiff
(spr_ex <- rast(here("data/spr_example.tif")))

## export geotiff
writeRaster(spr_ex,
            filename = "data/spr_elev.tif",
            overwrite = TRUE)

## Mapping Raster data ------------------------------------------
ggplot() + geom_spatraster(data = spr_ex)

## mapview function

star_ex <- st_as_stars(spr_ex)
class(spr_ex)

mapview(star_ex)

## Raster data type-----------------------------------------------

#Continous raster
v_elev <- values(spr_ex)
head(v_elev, 10)

na.omit(v_elev) %>% 
  mean()

## extract data from given location
#xy specifies longitude/laditude
xy <- cbind(6.0000, 50.0000)
extract(spr_ex, xy)

## xy can be multiple sites
df_point <- tibble(lon = c(6, 5.9),
                   lat = c(50, 49.96))
extract(spr_ex,
        y = df_point)

# discrete Raster
spr_forest <- rast(here("data/spr_forest_nc.tif"))

ggplot() +
  geom_spatraster(data = spr_forest)

unique(spr_forest)
unique(spr_ex)

v_binary <- values(spr_forest)
 mean(v_binary)
 
 ## distrete, coded values
 spr_land <- rast(here("data/spr_land_reclass.tif"))
unique(spr_land) 

extract(spr_land, cbind(-79.8063, 36.0701))


# Reclass-------------------------------------------------  

#create a conversion matrix
cm <- cbind(c(0, 1001, 1010, 1100),
            c(0, 1, 0, 0))

# reclass
spr_bin <- classify(spr_land,
         rcl = cm)

unique(spr_bin)

v_bin <- values(spr_bin)
mean(v_bin)

#Exercise

#Read a Geotiff file
spr_prec_ncne <- rast(here("data/spr_prec_ncne.tif"))

# Inspect Raster properties
# number of rows and columns: 162 rows, 532 column
# Resolution: 0.008333333, 0.008333333
# spatial extent: -79.89181, -75.45847, 35.24153, 36.59153
# Coordinate referance system: lon/lat WGS 84 (EPSG:4326)
# Max and Min predicted values:  Max-1063.1, Min- 1501.5 

#Visualize the Raster
ggplot() + geom_spatraster(data = spr_prec_ncne)

#Etract the Values 
sf_site <- readRDS(here("data/sf_finsync_nc.rds"))

df_xy <- st_coordinates(sf_site)

df_land <- extract(spr_land,
                    df_xy)

# Reclassify
cu <- cbind(c(0, 1001, 1010, 1100),
            c(0, 0, 0 , 1))

spr_urban <- classify(spr_land, 
                      rcl = cu )

# calculate the proportion 

values(spr_urban) %>% 
mean()

