---
title: Setup
---

## Requirements

You will requre 1) all the correct programs, 2) all the listed R packages 3) the dataset and code. Instructions for all these are below.


### Please see the attached document for program instructions: - [Program Install Instructions.docx](/Resources/install_instructions.docx)
-  R version: 3.6.x or newer (recommend 4.0.x) and RStudio are both **mandatory**
-  Rtools (Windows users only) and GDAL are only required if you decide to continue your learning with any Advanced OTN Telemetry Workshop content.

Once all of the programs are installed, open RStudio and run the below package install scripts. It's best to run it line by line instead of all at once in case there are errors.

<b>Note:</b> When running through the installs, you may encounter a prompt asking you to upgrade dependent packages. Choosing Option `3: None`, works in most situations and will prevent upgrades of packages you weren't explicitly looking to upgrade.

### R Workshop Requirements

```r

#Tidyverse - data leaning and arrangement
install.packages('tidyverse')
install.packages('dplyr')

# Lubridate - part of Tidyverse, improves the process of creating date objects
install.packages('lubridate')

#ggplot2 - common and well-supported package for data visualisation
install.packages('ggplot2')

# ReadXL - reads Excel format
install.packages('readxl')

# GGmap - complimentary mapping package to ggplot2, which is in the Tidyverse
install.packages('ggmap')

#Some lessons require a Stadia Maps API key. You can set up your own if you want, or use the
#one provided below:
library(ggmap)
#This is a temporarily available API key you can use for this workshop. You SHOULD NOT rely on this key being available after the workshop.
ggmap::register_stadiamaps("b01d1235-69e8-49ea-b3bd-c35b42424b00")

# Plotly - Interactive web-based data visualization
install.packages('plotly')

# Viridis - color scales in this package are easier to read by those with colorblindness, and print well in grey scale.
install.packages('viridis')  

```

# Dataset and Code

<b>Once the above packages are installed</b>, you can download the datasets and code for this workshop from <b>[this link](https://github.com/ocean-tracking-network/2024-fact-meeting-workshop/)</b>

1. Select the GREEN "Code" button at the top and choose "Download ZIP"
2. Unzip the folder and move to secure location on your computer (Documents, Desktop etc.)
3. Copy the folder's path and use it to set your working directly in R using `setwd('<path-to-folder>')`.

If you are familiar with Git and Github, feel free to clone this repository as you normally would, by running `git clone https://github.com/ocean-tracking-network/2024-fact-meeting-workshop.git` in a terminal program and following from step `3` above.






{% include links.md %}
