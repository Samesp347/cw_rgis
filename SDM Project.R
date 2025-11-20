# 1 select a response variable ------------------------

# I will be researching the Cyprinella analostana  and their
# presence/absence at each site 

# 2 select predictor variables ------------------------------------------------

# I will use Land classication to determine the presence/ absence of  Cyprinella analostana
# in NC because they inhabit sandy pools and run off. These place are now being inhabited
# by people and the land around them is being used I want to see how this 
# affects the fishes way of life. 

# 3 Conduct your analysis 

df_finsync %>% 
  filter(site_id == "spr_land_reclass.tif")

df_w <- df_finsync %>% 
  pivot_wider(id_cols = c(site_id, lon, lat ),
              names_from = latin,
              values_from = presence,
              values_fill = 0)

df_rds <- df_w %>% 
  select(site_id,
         lon,
         lat,
         "Cyprinella analostana")

 

sf_rds <- st_as_sf(df_rds, coords = c("lon", "lat"),
                   crs = 4326)


spr_nc_land <- rast("data/spr_land_reclass.tif")

unique(spr_nc_land)

extract(spr_nc_land, cbind(-79.8063, 36.0701))


(cm <- cbind(c(0, 1001, 1010, 1100),
             c(0, 1, 0, 0)))

spr_land_nc <- classify(spr_nc_land,
                        rcl = cm)

sf_rds_land <- extract(x = spr_land_nc,
                       y = sf_rds,
                       bind =TRUE) %>% 
                       st_as_sf()

ggplot() +
  geom_spatraster(data = spr_nc_land) +
  geom_sf(data = sf_rds_land) +
  scale_fill_viridis_c()

df_rbs_w_land <- as_tibble(sf_rds_land)
    
df_rbs_w_land %>%
  ggplot(aes( x = reclass,
              y = sf_rds_land)) +
  geom_point() +
  theme_bw()

df_pred <- ggpredict(m_rbs, terms = "land [all]")

ggplot() +
  geom_point(data = df_rbs_w_tmp,
             aes(x = reclass,
                 y = y)) +
  geom_line(data = df_pred,
            aes(x = x,
                y = predicted)) +
  geom_ribbon(data = df_pred,
              aes(x = x,
                  ymin = conf.low,
                  ymax = conf.high)
  
  

  
