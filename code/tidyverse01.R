library(tidyverse)

set.seed(123)

iris_sub <- as_tibble(iris) %>% 
  group_by(Species) %>% 
  sample_n(3) %>% 
  ungroup()

print(iris_sub)

filter(iris_sub, Species %in% c("virginica", "versicolor"))

filter(iris_sub, Species != "virginica")

filter(iris_sub,
       !(Species %in% c("virginica", "versicolor")))

filter(iris_sub,
       Sepal.Length > 5)

filter(iris_sub,
       Sepal.Length >= 5)

filter(iris_sub,
       Sepal.Length <= 5)
# Sepal.Length is less than 5 AND Species equals "setosa"

filter(iris_sub,
       Sepal.Length < 5 & Species == "setosa")

# same; "," works like "&"
filter(iris_sub,
       Sepal.Length < 5, Species == "setosa")

arrange(iris_sub, Sepal.Length)

arrange(iris_sub, desc(Sepal.Length))

## column Manipulation
select(iris_sub,
       Sepal.Length)

select(iris_sub,
       c(Sepal.Length, Sepal.Width))

select(iris_sub,
       -Sepal.Length)

select(iris_sub,
       -c(Sepal.Length, Sepal.Width))

# select columns starting with "Sepal"
select(iris_sub, starts_with("Sepal"))

# remove columns starting with "Sepal"
select(iris_sub, -starts_with("Sepal"))

# select columns ending with "Sepal"
select(iris_sub, ends_with("Width"))

# nrow() returns the number of rows of the dataframe
(x_max <- nrow(iris_sub))
## [1] 9

# create a vector from 1 to x_max
x <- 1:x_max

# add as a new column
# named `x` as `row_id` when added
mutate(iris_sub, row_id = x)

# twice `Sepal.Length` and add as a new column
mutate(iris_sub, sl_two_times = 2 * Sepal.Length)

(x_max <- nrow(iris_sub))

##piping 
iris_setosa <- filter(iris_sub, species == "setosa")

iris_sub %>% filter(spices)

# Excercise
filter(iris_sub, species == "virginica")

select(iris_sub,Sepal.width)
select(iris_sub,Sepal.width)

excersise #3 
df0 <- iris_sub %>% 
  filter(Species == "virginica") %>% 
  select(Sepal.width) %>% 
  mutate(sw3 = 3 * Sepal.width)

##Group operation 

#Calculate mean
mean(c(2,5,8))
m <- (c(2, 5, 8))
m_large <- mean(1:1000)

iris_sub$Sepal.length

# group_by() function
df_summary <- iris_sub %>% 
  group_by(Species) %>% 
  summarize(mean_sl = mean(Sepal.Length))
sum_sl = sum(Sepal.Length)
mean_pl = mean(Petal.Length)
sum_pl = sum(Petal.Length)
## Join
df1 <- tibble(Species = c("A", "B", "C"), 
              y = c(10, 12, 13))
df2 <- tibble(Species = c("A", "B", "C"), 
              y = c(10, 12, 13))      

left_join(x = df1,
          y = df2,
          by = "Species")       

df2_minus_c <- tibble(Species = c("A", "B"),
                      y = c(10, 12))

left_join(x = df1,
          y = df2_minus_c,
          by = "Species")                      