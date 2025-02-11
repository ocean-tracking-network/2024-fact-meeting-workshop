## Requirements------

### R version: 3.6.x or newer (recommend 4.0.x) and RStudio.

# Once R/RStudio is installed: open RStudio and run this install script. Please run it line-by-line instead of all at once in case there are errors.

#Note: When running through the installs, you may encounter a prompt asking you to upgrade dependent packages.
      #Choosing Option `3: None`, works in most situations and will prevent upgrades of packages you weren't explicitly looking to upgrade.

#Tidyverse (data leaning and arrangement)
install.packages('tidyverse')
install.packages('dplyr')

# Lubridate - part of Tidyverse, improves the process of creating date objects
install.packages('lubridate')

#ggplot2 - common and well-supported package for data visualisation
install.packages('ggplot2')

# GGmap - complimentary to ggplot2, which is in the Tidyverse
install.packages('ggmap') #note: must have ggmap 4.0.0 to run this workshop - please update

#Some lessons require a Stadia Maps API key. You can set up your own if you want, or use the
#one provided below:
library(ggmap)
#This is a temporarily available API key you can use for this workshop. You SHOULD NOT rely on this key being available after the workshop.
ggmap::register_stadiamaps("b01d1235-69e8-49ea-b3bd-c35b42424b00")

# Plotly - Interactive web-based data visualization
install.packages('plotly')

# Viridis - color scales in this package are easier to read by those with colorblindness, and print well in grey scale.
install.packages('viridis')                            

### Dataset and Code -----
# Once the packages are installed, you can download the datasets and code for this workshop from https://github.com/ocean-tracking-network/2024-fact-meeting-workshop/tree/master.
# 1) Select the GREEN "code" button at the top and choose "Download ZIP"
# 2) Unzip the folder and move to secure location on your computer (Documents, Desktop etc.)
# 3) Copy the folder's path and use it to set your working directly in R using `setwd('<path-to-folder>')`.

# If you are familiar with Git and Github, feel free to clone this repository as you normally would,
# by running `git clone https://github.com/ocean-tracking-network/2024-fact-meeting-workshop.git` in a terminal program
# and following from step 3 above.
