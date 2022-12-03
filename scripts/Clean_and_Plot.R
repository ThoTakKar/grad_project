# Cleaning and printing script.
# Paul Markley
# Computational Biology
# This script will take in any dataframe with a column 'species' that also has the columns
# latitude, longitude, year, month, and date. It then cleans the species identity based on the
# World Flora Online (WFO) taxonomic backbone. After, the script plots the counts of species
# and genus in the data frame, followed by spatial plotting. It lastly runs a mantel randomization
# test on the date and locations to see if there is any correlation between the space and time 
# dimensions of the data. 

# This script is intended to be used with a dataset downloaded from GBIF.

# Packages step.
  
if (!require("data.table", quietly = TRUE))
  install.packages("data.table")
if (!require('tidyverse', quietly = T))
  install.packages('tidyverse')
if (!require('ade4', quietly = T))
  install.packages('ade4')
if (!require('sf', quietly = T))
  install.packages('sf')
if (!require('terra', quietly = T))
  install.packages('terra')
if (!require('WorldFlora', quietly = T))
  install.packages('WorldFlora')

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
df <- read.csv('../data/heaths.csv') # On onedrive
back <- data.table::fread("../data/classification.txt") # on onedrive
S <- intersect(df$species, back$scientificName)

# remove rows that have matched with backbone, then gets all unique species names
# takes these species names and matches with accepted taxonomy.
df <- clean.sp(df, sp.list = S)

# Final check: if it worked the number of species matched to the backbone should
# equal to the number of species in the dataset and prints TRUE.
S <- intersect(df$species, back$scientificName); length(S) == length(unique(df$species))

# Convert the YMD columns to DOY for plotting and brief analysis.
DOY = lubridate::yday(as.Date(paste0(df$year, '-', df$month, '-', df$day)))
df$DOY = DOY

# Making a few plots to visualize what happened here in the data.
library(tidyverse)

# This script contains a function that summarizes the data frame into a table by species
# It then makes a genus column from the species binomial.
source('../scripts/freq.sp.tbl.R')
tbl <- freq.sp.tbl(df)

# Now the plots
# First is frequency of species colored by genus
 ggplot(tbl, aes(y = Var1, x = Freq)) +
   geom_col(aes(fill = genus)) +
   theme_bw() +
   labs(y='Species', x= 'Number of Observations', title = 'GBIF observations by Species')
ggsave('../figures/Speciestbl.png')


#Second is just genus frequencies
ggplot(tbl, aes(y = genus, x = Freq)) +
 geom_col(aes(fill = genus)) +
 theme_bw() +
 labs(y='Genus',x = 'Number of Observations', title = 'GBIF observations by Genus') 
ggsave('../figures/genustbl.png')


# Third is a density plot of DOY by genus
ggplot(data = df, aes(x = DOY, fill = genus)) +
geom_density(alpha = 0.3) + 
theme_bw() +
labs(title = 'Density Plot of Date of Year by Genus')
ggsave('../figures/densdoy.png')

#Fourth is a density plot of year by genus.
ggplot(data = df, aes(year, color = genus)) +
   geom_density() +
   labs(title = 'Density Plot of Year by Genus') +
  theme_bw()
ggsave('../figures/densyear.png')

# Making GIS maps. This requires the sf and terra packages.
# I make from the dataframe a sf object in WGS84
sf1 <- sf::st_as_sf(df, coords = c('lon','lat'), crs = 'EPSG:4326')
ggplot(data = sf1)+
geom_sf()
ggsave('../figures/map.png')

                                        
#Next I make a blank raster to rasterize the number of observations within each cell.
#The resolution of each cell is 50km by 50km, roughly a degree by a degree.
rst <- terra::rast(nrows = 57, ncols = 720, nlyrs = 1, resolution = c(0.5,0.5),
                   xmin = -180, xmax = 180, ymin = 55.5, ymax = 84, crs = 'EPSG:4326')

# I take the log of the observations to make the plot a bit easier to read.
abd <- log(terra::rasterize(terra::vect(sf1), rst, fun=length, touches = T))
png(filename = '../figures/rasterlogobs.tif', width = 500, height = 275)
plot(abd)
dev.off()

# My dataset is too big, so I will reduce it with a predetermined subset of observations
# Original dataset: ~20,000 observations, restricted data has ~4,000
# These were based on whether or not the points were within a polygon.
df1 <- df[df$in_s %in% 'PM',]
df1 = df1[complete.cases(df1) == T,]

# Minor Analysis of DOY vs Location and Year vs Location using the Mantel randomization test
d1 <- dist(cbind(df1$lon, df1$lat))
d2 <- dist(df1$DOY)
d3 <- dist(df1$year)

(mtl <- ade4::mantel.rtest(d1, d2)); saveRDS(mtl, '../figures/mantel_out.RData')
# H0: Location and DOY are not linearly correlated.
# Ha: Location and DOY have some linear correlation.
# pvalue = 0.01 < alpha 0.05: reject null hypothesis
# There is sufficient evidence to conclude that location and DOY are significantly positively correlated.

(mtl2 <- ade4::mantel.rtest(d1,d3)); saveRDS(mtl2, '../figures/mantel_out2.RData')
# H0: Location and year are not linearly correlated.
# Ha: Location and year have some linear correlation.
# pvalue = 0.01 < alpha 0.05: reject null hypothesis.
# There is sufficient evidence to conclude that location and year are significantly positively correlated.