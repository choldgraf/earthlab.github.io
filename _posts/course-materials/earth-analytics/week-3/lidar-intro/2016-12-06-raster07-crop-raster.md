---
layout: single
title: "Crop a raster in R using a shapefile."
excerpt: "This lesson presents how to classify a raster dataset and export it as a
new raster in R."
authors: ['Leah Wasser']
modified: '2017-02-03'
category: [course-materials]
class-lesson: ['class-lidar-r']
permalink: /course-materials/earth-analytics/week-3/crop-raster/
nav-title: 'Crop a raster'
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 7
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Crop a raster dataset in `R` using a vector extent object derived from a shapefile.
* Open a shapefile in `R`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / RStudio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)
* [Intro to the R & RStudio Interface](/course-materials/earth-analytics/week-1/intro-to-r-and-rstudio)

### R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>

In this lesson, we will learn how to crop a raster dataset in `R`. Previously,
we reclassified a raster in R, however the edges of our raster dataset were uneven.
In this lesson, we will learn how to crop a raster - to create a new raster
object / file that we can share with colleagues and / or open in other tools such
as QGIS.

## Load libraries


```r
# load the raster and rgdal libraries
library(raster)
library(rgdal)
```

## Open raster and vector layers

First, we will use the `raster()` function to open a raster layer. Let's open the
canopy height model that we created in the previous lesson


```r
# open raster layer
lidar_chm <- raster("data/week3/BLDR_LeeHill/outputs/lidar_chm.tif")

# plot CHM
plot(lidar_chm,
     col=rev(terrain.colors(50)))
```

![lidar chm plot]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster07-crop-raster/open-raster-1.png)

## Open vector layer

Next, let's open up a vector layer that contains the crop extent that we want
to use to crop our data. To open a shapefile we use the `readOGR()` function.

`readOGR()` requires two components:

1. The directory where our shapefile lives: data/week3/BLDR_LeeHill/
2. The name of the shapefile (without the extension): clip-extent



```r
# import the vector boundary
crop_extent <- readOGR("data/week3/BLDR_LeeHill",
                       "clip-extent")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week3/BLDR_LeeHill", layer: "clip-extent"
## with 1 features
## It has 1 fields
## Integer64 fields read as strings:  id

# plot imported shapefile
# notice that we use add=T to add a layer on top of an existing plot in R.
plot(crop_extent,
     main="Shapefile imported into R - crop extent",
     axes=T,
     border="blue")
```

![shapefile crop extent plot]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster07-crop-raster/plot-w-legend-1.png)

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/spatial_extent.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/spatial_extent.png" alt="The spatial extent of a shapefile or R spatial object represents
    the geographic "edge" or location that is the furthest north, south east and
    west."></a>
    <figcaption>The spatial extent of a shapefile or R spatial object represents
    the geographic "edge" or location that is the furthest north, south east and
    west. Thus is represents the overall geographic coverage of the spatial
    object. Image Source: Colin Williams, NEON.
    </figcaption>
</figure>

Now that we have imported the shapefile. We can use the crop() function in R to
crop the raster data using the vector shapefile.


```r
# crop the lidar raster using the vector extent
lidar_chm_crop <- crop(lidar_chm, crop_extent)
plot(lidar_chm_crop, main="Cropped lidar chm")

# add shapefile on top of the existing raster
plot(crop_extent, add=T)
```

![lidar chm cropped with vector extent on top]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster07-crop-raster/crop-and-plot-raster-1.png)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge - crop change over time layers

In the previous lesson, you created 2 plots:

1. A classified raster map that shows **positive and negative change** in the canopy height model before and after the flood. To do this you will need to calculate the difference
between two canopy height models.
2. A classified raster map that shows **positive and negative change** in terrain extracted from the pre and post flood Digital Terrain Models
before and after the flood.

Create the same two plots except this time CROP each of the rasters that you plotted
using the shapefile: `data/week3/BLDR_LeeHill/crop_extent.shp`

For each plot, be sure to:

* Add a legend that clearly shows what each color in your classified raster represents
* Use better colors that I used in my example above!.
* Add a title to your plot.

You will include these plots in your final report due next week.

Check out <a href="https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf" target="_blank">this cheatsheet for more on colors in `R`. </a>

Or type: `grDevices::colors()` into the r console for a nice list of colors!
</div>
