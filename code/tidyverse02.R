pacman::p_load(tidyverse)
# point
g_point <- ggplot(data = iris,
                  mapping = aes(x = Sepal.Length,
                                y = Sepal.Width)) +
  geom_point()


## with pipe
iris %>%
  ggplot(aes(x = Sepal.Length, 
             y = Sepal.Width)) +
  geom_point()


#color
g_point_col <- iris %>% 
  ggplot(aes(x = Sepal.Length,
             Y = Sepal.Width,
             color = Species)) +
  geom_point()

## pitfall - common mistake
iris %>% 
  ggplot(aes(x = Sepal.Length,
             y= Sepal.Width), 
         color = Species) +
  geom_point()


iris %>% 
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width),
         color = Species) +
  geom_point()

iris %>% 
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width)) +
  geom_point(color = "tomato")


#Line

df0 <-tibble(x = 1:50,
             y = 2 * x)

df0 %>% 
  ggplot(aes(x = x,
             y = y)) +
  geom_line() +
  geom_point()


# Histogram

iris %>% 
  ggplot(aes(x = Sepal.Length)) +
  geom_histogram()


# boxplot

iris %>% 
  ggplot(aes(x = Species,
             y = Petal.Length)) +
  geom_boxplot()

## change filling or color
iris %>% 
  ggplot(aes( x = Species,
              y = Sepal.Length,
              fill = Species)) +
  geom_boxplot()

iris %>% 
  ggplot(aes( x = Species,
              y = Sepal.Length,
              color = Species)) +
  geom_boxplot()


## ggplot Excercise

# draw a scatterplot of  Petal.Length (y)
#assign to g_petal

g_petal <- iris %>% 
  ggplot(aes(x = Petal.Width,
             y = Petal.Length)) +
  geom_point()

# draw a box plot between Species (x and Petal legnth (Y))
# fill the box
# assign it to g_petal box

g_petal_box <- iris %>% 
  ggplot(aes(x = Species,
             y = Petal.Length,
             fill = Species)) +
  geom_boxplot() 

# add a new layer of point , x = Species, y = Petal Length
g_petal_box +
  geom_point()

# change axis titles
g_petal_box +
  labs(x = "Plant species",
       y = "Petal Length")

#Excercise

df_mtcars <- as_tibble(mtcars)

# select rows with cyl is 4 
filter(df_mtcars, cyl == 4)

#select columns mpg, cyl, disp, vs, carb

select(df_mtcars,
       c(mpg, cyl, disp, wt ,vs, carb))

# select rows with cyl is greater than 4 
# then, select columns of mpg, cyl, disp, wt, vs, carb
#assign the output to df_sub

df_sub <- df_mtcars %>% 
  filter(cyl > 4) %>% 
  select(mpg, cyl, disp, wt, vs, carb)


# type the flollowing code and run
v_car <- rownames(mtcars)


# add a new column called "car" to the df_mtcars,
# then assign it to df_mtcars

df_mtcars <- mutate(df_mtcars,
                    car = v_car)

# identify the lightest car  (wt) with cyl= 8

df_mtcars %>% 
  filter(cyl == 8) %>% 
  arrange(wt)

#Calculate the average weight (wt) of the cars within each group of gear numbers (gear)
# consider using group_by() and summarize()
# assign to gt_mean 

df_mean <- df_mtcars %>% 
  group_by(gear) %>% 
  summarize(mu = mean(wt))



# combination of dplyr operations with ggplot
df_mtcars %>% 
  ggplot(aes(x = wt,
             y = qsec)) +
  geom_point()

#draw a figure between wt and qsec, but only those cyl = 6

df_mtcars %>% 
filter(cyl == 6) %>% 
  ggplot(aes(x = wt,
             y = qsec)) +
  geom_point()

# draw a figure btwn mean wt and mean qsec for each group of gear 

df_mtcars %>% 
  group_by(gear) %>% 
  summarize(mu_wt = mean(wt),
            mu_qsec = mean(qsec)) %>% 
ggplot(aes(x = mu_wt,
           y = mu_qsec)) +
  geom_point()



























