# Scripts

Included here are the scripts used to generate the items in the figures folder.

The main script to run is Clean_and_Plot.R: the other two scripts are helper scripts called in CaP using the source command.

## cleansp
cleansp.R contains the clean.sp function used to clarify the taxonomy of the species column. It takes a dataframe and a vector of species and extracts species rows of the data frame not in the vector. It then calls unique on the species vector to simply the fuzzy checking process, which can be a bit slow. After resolving taxonomy, it then merges the updated rows into the data frame and returns it.

## freqsptbl
freqsptbl.R has the freq.sp.tbl function which is very simple. It takes in a dataframe with a species column and computes the frequency table. It then creates a genus vector in the data frame from the species binomial. This function includes an option to remove species with low observed counts.

## Clean_and_Plot
This is the main script to execute in your R session. CaP requires six packages: tidyverse, ade4, terra, sf, WorldFlora, and data.table. Below is an outline of the workflow.

### Step 1: Package Check
CaP first checks if all six packages above are present. If they are absent, they are then installed.

### Step 2: Read Data
CaP calls the data from the data folder: heaths.csv and classification.txt. It then creates the species vector S which is the intersection of both files species vectors.

### Step 3: Taxonomy Cleaning
CaP resolves taxonomy using WFO package WorldFlora. It is hidden in the clean.sp function. Here CaP uses clean.sp as described above. The script checks to see if all species in the data frame are present in the species vector using an updated intersection of the species in the data frame and the species in the backbone. That should print TRUE when the conditional is checked.

### Step 4: Date to DOY conversion
Using lubridate the three columns, year, month, and day are read into a new column as a Date object and converted using yday to DOY

### Step 5: Frequency Table
With the freq.sp.tbl.R script as source, the frequency table of the species is computed. This function works as described above.

### Step 6: Plotting
CaP uses ggplot for the bar charts of species and genus by observation and year and doy by density. The input data is the table generated above for the first two and the cleaned data frame for the last two plots. The cleaned data frame is then converted into a sf object to visualize the spatial pattern of observations. After, this object is converted into a terra method raster to create a heat map of observation density in space. All figures are saved into the figures folder.

### Step 7: Analysis
This script uses a Mantel Randomization to compare the distance matrices of the locations against that of the DOY and Year. The reason for this is to examine if there is a correlation between the time and spatial components of the data. This part creates distance objects using the base R method and then calls the ade4 package method for the Mantel test. These outputs are saved into the figures folder.
