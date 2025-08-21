
# script begins with loading packages
# library() function would work, but pacman::p_load() allows you to load multiple packages at once
if(!require(pacman)) install.packages("pacman")
if(!require(tidyverse)) install.packages("tidyverse")

pacman::p_load(tidyverse)


# section label -----------------------------------------------------------
## you can create a section label with `Ctr + Shift + R`

## write codes as you need


z <- c("a", "b", "c")