if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               terra,
               tidyterra,
               exactextractr,
               here)

## finsync survey site
sf_site <- readRDS(here("data/sf_finsync_nc.rds"))

## county polygons
sf_nc_county <- readRDS(here("data/sf_nc_county.rds"))

## precipitation raster
spr_prec_nc <- rast(here("data/spr_prec_nc.tif"))

#Point-wise extraction--------------------------------------------

## Visualize data 
ggplot() +
  geom_spatraster(data = spr_prec_nc) +
  geom_sf(data = sf_site) +
  scale_fill_viridis_c() + # change color palette for raster
  theme_bw()

sf_site_prec <- extract(x = spr_prec_nc,
        y = sf_site,
        bind = TRUE) %>% 
  st_as_sf()

ggplot() +
  geom_sf(data = sf_nc_county,       # Plot county boundaries as a grey background
          fill = "grey") + 
  geom_sf(data = sf_site_prec,       # Plot survey points colored by precipitation
          aes(color = precipitation)) +
  scale_color_viridis_c() +          # Apply a perceptually uniform color scale
  theme_bw()                        # Use a clean black-and-white theme


##ZONAL STATISTICS----------------------------------------------------------  

## transform sf_site to 32617: use st_transform()

sf_nc_county_proj <- st_transform(sf_nc_county,
                                  crs = 32617)

## transform spr_prec_nc to 32617: use project()

spr_prec_nc_proj <- project(spr_prec_nc,
                            y = "EPSG:32617",
                                   method = "bilinear")

df_prec_county <- exact_extract(x = spr_prec_nc_proj,
              y = sf_nc_county_proj,
              fun = "mean",
              append_cols = TRUE) %>% 
  as_tibble() %>% 
  rename(precipitation = mean)

sf_nc_county_prec <- left_join(sf_nc_county,
          df_prec_county,
          by = "county")

ggplot() +
  geom_sf(data = sf_nc_county_prec,
          aes(fill = precipitation)) +
  scale_fill_viridis_c()


# Buffer-based analysis

sf_site_proj <- sf_site %>% 
  st_transform(crs = 32617)

## create buffer around the point 

sf_site_buff_proj <- sf_site_proj %>% 
  st_buffer(dist = 10000)

ggplot() + 
  geom_sf(data = sf_nc_county) +
geom_sf(data = sf_site_buff_proj) +
  geom_sf(data = sf_site_proj)


## get the mean precipitation for each site buffer


## link these values to site layer 


## map the precipitation value at each site 


## identify top 3 high-precipitation site 
