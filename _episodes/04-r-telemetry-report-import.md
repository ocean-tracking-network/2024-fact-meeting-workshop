---
title: Telemetry Reports - Imports
teaching: 10
exercises: 0
questions:
    - "What datasets do I need from the Network?"
    - "How do I import all the datasets?"
---

## Importing all the datasets
Now that we have an idea of what an exploratory workflow might look like with Tidyverse libraries like `dplyr` and `ggplot2`, let's look at how we might implement a common telemetry workflow using these tools. 

We are going to use OTN-style detection extracts for this lesson. If you're unfamiliar with detection extracts formats from OTN-style database nodes, see the documentation [here](https://members.oceantrack.org/data/otn-detection-extract-documentation-matched-to-animals). 

For the FACT Network you will receive Detection Extracts which include (1) Matched to Animals YYYY, (2) Detections Mapped to Other Trackers - Extended YYYY (also called Qualified Extended) and (3) Unqualified Detections YYYY. In each case, the YYYY in the filename indicates the single year of data contained in the file and "extended" refers to the extra column provided to FACT Network members: "species detected". The types of detection extracts you receive will differ depending on the type of project you have registered with the Network. If you have both an Array project and a Tag project you will likely need both sets of Detection Extracts.

To illustrate the many meaningful summary reports which can be created use detection extracts, we will import an example of Matched and Qualified extracts.

First, we will confirm we have our Tag Matches stored in a dataframe.
~~~
View(tqcs_matched_10_11) #already have our Tag matches, from a previous lesson.

# if you do not have the variable created from a previous lesson, you can use the following code to re-create it:

tqcs_matched_2010 <- read_csv("tqcs_matched_detections_2010.zip", guess_max = 117172) #Import 2010 detections
tqcs_matched_2011 <- read_csv("tqcs_matched_detections_2011.zip", guess_max = 41881) #Import 2011 detections
tqcs_matched_10_11_full <- rbind(tqcs_matched_2010, tqcs_matched_2011) #Now join the two dataframes
# release records for animals often appear in >1 year, this will remove the duplicates
tqcs_matched_10_11_full <- tqcs_matched_10_11_full %>% distinct() # Use distinct to remove duplicates. 
tqcs_matched_10_11 <- tqcs_matched_10_11_full %>% slice(1:100000) # subset our example data to help this workshop run smoother!
~~~
{: .language-r}

Next, we will load in and join our Array matches.

~~~
teq_qual_2010 <- read_csv("teq_qualified_detections_2010.zip")
teq_qual_2011 <- read_csv("teq_qualified_detections_2011.zip")
teq_qual_10_11_full <- rbind(teq_qual_2010, teq_qual_2011) 

teq_qual_10_11 <- teq_qual_10_11_full %>% slice(1:100000) #subset our example data for ease of analysis!
~~~
{: .language-r}

To give meaning to these detections we should import our Instrument Deployment Metadata and Tagging Metadata as well. These are in the standard VEMBU/FACT-style templates which can be found [here](https://secoora.org/fact/projects-species/projects/acoustic-telemetry-resources/).

~~~
# Array metadata

teq_deploy <- read.csv("TEQ_Deployments_201001_201201.csv")
View(teq_deploy)

# Tag metadata

tqcs_tag <- read.csv("TQCS_metadata_tagging.csv") 
View(tqcs_tag)

#remember: we learned how to switch timezone of datetime columns above, if that is something you need to do with your dataset!!
~~~
{: .language-r}



