if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               ggeffects,
               sf,
               terra,
               tidyterra,
               exactextractr,
               mapview, here)

# prepare ecological data ------------------------------------------------

df_finsync <- read_csv(here("data/data_finsync_nc.csv"))

## pick data from 1 site 
df_st1 <- df_finsync %>% 
  filter(site_id == "finsync_nrs_nc-10013")


df_w <- df_finsync %>% 
  pivot_wider(id_cols = c(site_id, lon, lat ),
              names_from = latin,
              values_from = presence,
              values_fill = 0)

## lepomis auritus
## site_id, lat, lon
df_rds <- df_w %>% 
  select(site_id,
         lon,
         lat,
         "Lepomis auritus") %>% 
  rename(y = 'Lepomis auritus')

##create sf object
sf_rds <- st_as_sf(df_rds,coords = c("lon","lat"),
                   crs = 4326)


#Linking to the Environment------------------------

spr_tmp_nc <- rast(here("data/spr_tmp_nc.tif"))

sf_rds_w_tmp <- extract(x = spr_tmp_nc,
        y = sf_rds,
        bind = TRUE) %>% 
  st_as_sf()

##mapping
## raster layer with temp gradient
##survey sites 

ggplot() +
  geom_spatraster(data = spr_tmp_nc) +
  geom_sf(data = sf_rds_w_tmp) +
scale_fill_viridis_c()

#Statistical analysis -------------------------------------------

## draw figure relating fish presence to temperature
df_rbs_w_tmp <- as_tibble( sf_rds_w_tmp)

df_rbs_w_tmp %>% 
ggplot(aes(x = temperature,
           y = y)) +
  geom_point() +
  theme_bw()


m_rbs <- glm(y ~ temperature,
    data = df_rbs_w_tmp,
    family ="binomial")

summary(m_rbs)


## draw predicted line 

df_pred <- ggpredict(m_rbs, terms = "temperature [all]")

ggplot() +
  geom_point(data = df_rbs_w_tmp,
             aes(x = temperature,
                 y = y)) +
  geom_line(data = df_pred,
            aes(x = x,
                y = predicted)) +
  geom_ribbon(data = df_pred,
              aes(x = x,
                  ymin = conf.low,
                  ymax = conf.high),
              fill = "pink",
              alpha = 0.2) +
theme_bw() +
  labs(x = "Air temperature",
       y = "probability od occurence")

df_finsync %>% 
  pull(latin) %>% 
  unique() %>% 
  sort()

df_finsync %>% 
  filter(latin == "Cyprinella analostana")


