---
title: Telemetry Reports for Array Operators
teaching: 30
exercises: 0
questions:
    - "How do I summarize and plot my deployments?"
    - "How do I summarize and plot my detections?"
---

### Mapping my stations - Static map

Since we have already imported and joined our datasets, we can jump in. This section will use the Deployment metadata for your array. We will make a static map of all the receiver stations in three steps, using the package `ggmap`. 

First, we set a basemap using the aesthetics and bounding box we desire. Then, we will filter our stations dataset for those which we would like to plot on the map. Next, we add the stations onto the basemap and look at our creation! If we are happy with the product, we can export the map as a `.tiff` file using the `ggsave` function, to use outside of R. Other possible export formats include: `.png`, `.jpeg`, `.pdf` and more.
~~~
library(ggmap)


#first, what are our columns called?
names(teq_deploy)


#make a basemap for your stations, using the min/max deploy lat and longs as bounding box

base <- get_stadiamap(
  bbox = c(left = min(teq_deploy$DEPLOY_LONG), 
           bottom = min(teq_deploy$DEPLOY_LAT), 
           right = max(teq_deploy$DEPLOY_LONG), 
           top = max(teq_deploy$DEPLOY_LAT)),
  maptype = "stamen_terrain_background", 
  crop = FALSE,
  zoom = 8)

#filter for stations you want to plot

teq_deploy_plot <- teq_deploy %>% 
  dplyr::mutate(deploy_date=ymd_hms(DEPLOY_DATE_TIME....yyyy.mm.ddThh.mm.ss.)) %>% #make a datetime
  dplyr::mutate(recover_date=ymd_hms(RECOVER_DATE_TIME..yyyy.mm.ddThh.mm.ss.)) %>% #make a datetime
  dplyr::filter(!is.na(deploy_date)) %>% #no null deploys
  dplyr::filter(deploy_date > 2010-07-03) %>% #only looking at certain deployments!
  dplyr::group_by(STATION_NO) %>% 
  dplyr::summarise(MeanLat=mean(DEPLOY_LAT), MeanLong=mean(DEPLOY_LONG)) #get the mean location per station
  
# you could choose to plot stations which are within a certain bounding box!
# to do this you would add another filter to the above data, before passing to the map
# ex: add this line after the mutate() clauses:
	# filter(latitude >= 0.5 & latitude <= 24.5 & longitude >= 0.6 & longitude <= 34.9)


#add your stations onto your basemap

teq_map <- 
  ggmap(base, extent='panel') +
  ylab("Latitude") +
  xlab("Longitude") +
  geom_point(data = teq_deploy_plot, #filtering for recent deployments
             aes(x = MeanLong,y = MeanLat), #specify the data
             colour = 'blue', shape = 19, size = 2) #lots of aesthetic options here!

#view your receiver map!

teq_map

#save your receiver map into your working directory

ggsave(plot = teq_map, file = "code/day1/teq_map.tiff", units="in", width=15, height=8)
~~~
{: .language-r}

### Mapping my stations - Interactive map

An interactive map can contain more information than a static map. Here we will explore the package `plotly` to create interactive "slippy" maps. These allow you to explore your map in different ways by clicking and scrolling through the output.

First, we will set our basemap's aesthetics and bounding box and assign this information (as a list) to a geo_styling variable.

~~~
library(plotly)

#set your basemap

geo_styling <- list(
  scope = 'usa',
  fitbounds = "locations", visible = TRUE, #fits the bounds to your data!
  showland = TRUE,
  showlakes = TRUE,
  lakecolor = toRGB("blue", alpha = 0.2), #make it transparent
  showcountries = TRUE,
  landcolor = toRGB("gray95"),
  countrycolor = toRGB("gray85")
)

~~~
{: .language-r}

Then, we choose which Deployment Metadata dataset we wish to use and identify the columns containing Latitude and Longitude, using the `plot_geo` function.
~~~
#decide what data you're going to use. Let's use teq_deploy_plot, which we created above for our static map.

teq_map_plotly <- plot_geo(teq_deploy_plot, lat = ~MeanLat, lon = ~MeanLong)  
~~~
{: .language-r}

Next, we use the `add_markers` function to write out what information we would like to have displayed when we hover our mouse over a station in our interactive map. In this case, we chose to use `paste` to join together the Station Name and its lat/long. 
~~~
#add your markers for the interactive map

teq_map_plotly <- teq_map_plotly %>% add_markers(
  text = ~paste(STATION_NO, MeanLat, MeanLong, sep = "<br />"),
  symbol = I("square"), size = I(8), hoverinfo = "text" 
)
~~~
{: .language-r}

Finally, we add all this information together, along with a title, using the `layout` function, and now we can explore our interactive map!
~~~
#Add layout (title + geo stying)

teq_map_plotly <- teq_map_plotly %>% layout(
  title = 'TEQ Deployments<br />(> 2010-07-03)', geo = geo_styling
)

#View map

teq_map_plotly

~~~
{: .language-r}

To save this interactive map as an `.html` file, you can explore the function htmlwidgets::saveWidget(), which is beyond the scope of this lesson.
 
### Summary of Animals Detected

Let's find out more about the animals detected by our array! These summary statistics, created using `dplyr` functions, could be used to help determine the how successful each of your stations has been at detecting tagged animals. We will also learn how to export our results using `write_csv`.

~~~
# How many of each animal did we detect from each collaborator, by species

library(dplyr)

teq_qual_summary <- teq_qual_10_11 %>% 
  filter(datecollected > '2010-06-01') %>% #select timeframe, stations etc.
  group_by(trackercode, scientificname, tag_contact_pi, tag_contact_poc) %>% 
  summarize(count = n()) %>% 
  select(trackercode, tag_contact_pi, tag_contact_poc, scientificname, count)

#view our summary table

teq_qual_summary #remember, this is just the first 100,000 rows! We subsetted the dataset upon import!

#export our summary table

write_csv(teq_qual_summary, "code/day1/teq_detection_summary_June2010_to_Dec2011.csv", col_names = TRUE)

~~~
{: .language-r}

You may notice in your summary table above that some rows have a value of `NA` for 'scientificname'. This is because this example dataset has detections of animals tagged by researchers who are not a part of the FACT Network, and therefore have not agreed to share their species information with array-operators automatically. To obtain this information you would have to reach out to the researcher directly. For more information on the FACT Data Policy and how it differs from other collaborating OTN Networks, please reach out to Data@theFACTnetwork.org.


### Summary of Detections

These `dplyr` summaries can suggest array performance, hotspot stations, and be used as a metric for funders.

~~~
# number of detections per month/year per station 

teq_det_summary  <- teq_qual_10_11  %>% 
  mutate(datecollected=ymd_hms(datecollected))  %>% 
  group_by(station, year = year(datecollected), month = month(datecollected)) %>% 
  summarize(count =n())

teq_det_summary #remember: this is a subset!

# number of detections per month/year per station & species

teq_anim_summary  <- teq_qual_10_11  %>% 
  mutate(datecollected=ymd_hms(datecollected))  %>% 
  group_by(station, year = year(datecollected), month = month(datecollected), scientificname) %>% 
  summarize(count =n())

teq_anim_summary # remember: this is a subset!

# Create a new data product, det_days, that give you the unique dates that an animal was seen by a station
stationsum <- teq_qual_10_11 %>% 
  group_by(station) %>%
  summarise(num_detections = length(datecollected),
            start = min(datecollected),
            end = max(datecollected),
            species = length(unique(scientificname)),
            uniqueIDs = length(unique(fieldnumber)), 
            det_days=length(unique(as.Date(datecollected))))
View(stationsum)

~~~
{: .language-r}

### Plot of Detections

Lets make an informative plot using `ggplot` showing the number of matched detections, per year and month. Remember: we can combine `dplyr` data manipulation and plotting into one step, using pipes!

~~~
#try with teq_qual_10_11_full if you're feeling bold! takes about 1 min to run on a fast machine

teq_qual_10_11 %>% 
  mutate(datecollected=ymd_hms(datecollected)) %>% #make datetime
  mutate(year_month = floor_date(datecollected, "months")) %>% #round to month
  group_by(year_month) %>% #can group by station, species etc.
  summarize(count =n()) %>% #how many dets per year_month
  ggplot(aes(x = (month(year_month) %>% as.factor()), 
             y = count, 
             fill = (year(year_month) %>% as.factor())
             )
         )+ 
  geom_bar(stat = "identity", position = "dodge2")+ 
  xlab("Month")+
  ylab("Total Detection Count")+
  ggtitle('TEQ Animal Detections by Month')+ #title
  labs(fill = "Year") #legend title

~~~
{: .language-r}