# Grad Project 2022
## Paul Markley
## Computational Biology

## Executive Summary
This is the github repo for the class project final for graduate students in Computational Biology spring 2022. After deleting all the files off my computer several times while attempting to sync to the repo and having files that are simply way too large, you're reading this so that means that I've finally gotten it right.

The purpose of this repo and project is to clean and plot data files from GBIF. GBIF files are typically, quite variable in quality. I'm going to focus solely on cleaning the taxonomy as opposed to cleaning coordinates because coordinate cleaning can be done with just one function from another package. The end product of this project is to produce plots of species and genus by the number of observation, plot these points in space, and lastly examine any correlations between the location and the time of observation.

This repo contains three directories: 'scripts' 'data' and 'figures'

### Scripts
This folder contains all scripts used in the graduate project. The 'cleansp.R' and 'freqsptbl.R' scripts are helper functions that are used in the main script 'Clean_and_Plot.R' (CaP). Please run that script to get the full output.

### Data
This folder likely will be empty. Both of the files I am working with are larger than 100MB. Check the onedrive for the files.

### Figures
This folder contains the outputs of the CaP script. It will have ggplot outputs, one terra output, and two RData files from the mantel randomization test.

