if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview,
               here)


# Read/export vector data -------------------------------------------------

# read a shapefile (e.g., ESRI Shapefile format)
# `quiet = TRUE` just for cleaner output
sf_nc_county <- st_read(dsn = here("data/nc.shp"),
                         quiet = TRUE)

# export as a shp file
st_write(sf_nc_county, 
         dsn = here("data/sf_nc_county.shp"),
         append = FALSE)

#Export as a geo package 
st_write(sf_nc_county, 
         dsn = here("data/sf_nc_county.gpkg"),
         append = FALSE)

# export as an RDS file 
saveRDS(sf_nc_county,
        file = here("data/sf_nc_county.rds"))

# read RDS file
# read from an RDS file
sf_nc_county <- readRDS(file = here("data/sf_nc_county.rds"))

## point Data
### as is 
sf_site <- readRDS(file = here("data/sf_finsync_nc.rds"))

mapview(sf_site,
        col.regions = "black", # point's fill color
        legend = FALSE) # disable legend

#Take the first ten sites
sf_site10 <- sf_site %>% 
  slice(1:10)

# line data
(sf_str <- readRDS(file = here("data/sf_stream_gi.rds")))

mapview(sf_str,
        color = "steelblue", # line's color
        legend = FALSE) # disable legend

# take the first 10 sites
sf_site10 <- sf_str %>% 
  slice(1:10)


# polygon 
mapview(sf_nc_county,
        col.regions = "tomato", # polygon's fill color
        legend = FALSE) # disable legend

## pick Guilford county 
sf_nc_gi <- sf_nc_county %>% 
  filter(county == "guilford")

mapview(sf_nc_gi,
        col.regions = "salmon",
        legand = FALSE)

# use ggplot to visualize a map
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site)



## a little better
ggplot() +
  geom_sf(data = sf_nc_gi) +
  geom_sf(data = sf_str)
  
##Exercise read stream line data for ashe County
sf_str_as <- readRDS(file = here("data/sf_stream_gi.rds"))


##Exercise Chack coordinate reference systems 


## Map streams and county Boundaries 
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str_as)



##subset county layer 
sf_nc_as <- sf_nc_county %>% 
  filter(county == "ashe")
ggplot() +
  geom_sf(data = sf_nc_as) +
  geom_sf(data = sf_str_as)
