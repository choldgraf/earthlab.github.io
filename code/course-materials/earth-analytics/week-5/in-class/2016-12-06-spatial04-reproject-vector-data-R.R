## ----load-libraries------------------------------------------------------
# load spatial data packages
library(rgdal)
library(raster)
library(rgeos)
options(stringsAsFactors = F)
# set working directory to data folder
# setwd("pathToDirHere")


## ----read-csv------------------------------------------------------------
# Import the shapefile data into R
state_boundary_us <- readOGR("data/week5/usa-boundary-layers",
          "US-State-Boundaries-Census-2014")

# view data structure
class(state_boundary_us)

## ----find-coordinates, fig.cap="Plot of the continental united states."----
# view column names
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n US Census Bureau Data")

## ----check-out-coordinates, fig.cap="Plot of the US overlayed with states and a boundary."----
# Read the .csv file
country_boundary_us <- readOGR("data/week5/usa-boundary-layers",
          "US-Boundary-Dissolved-States")

# look at the data structure
class(country_boundary_us)

# view column names
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n US Census Bureau Data",
     border="gray40")

# view column names
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)


## ----explore-units, fig.cap="plot aoi"-----------------------------------
# Import a polygon shapefile
sjer_aoi <- readOGR("data/week5/california/SJER/vector_data",
                      "SJER_crop")
class(sjer_aoi)

# plot point - looks ok?
plot(sjer_aoi,
     pch = 19,
     col = "purple",
     main="San Joachin Experimental Range AOI")

## ----layer-point-on-states, fig.cap="plot states"------------------------
# plot state boundaries
plot(state_boundary_us,
     main="Map of Continental US State Boundaries \n with SJER AOI",
     border="gray40")

# add US border outline
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)

# add AOI boundary
plot(sjer_aoi,
     pch = 19,
     col = "purple",
     add = TRUE)


## ----crs-exploration-----------------------------------------------------
# view CRS of our site data
crs(sjer_aoi)

# view crs of census data
crs(state_boundary_us)
crs(country_boundary_us)

## ----view-extent---------------------------------------------------------
# extent & crs for AOI
extent(sjer_aoi)
crs(sjer_aoi)

# extent & crs for object in geographic
extent(state_boundary_us)
crs(state_boundary_us)


## ----crs-sptranform------------------------------------------------------
# reproject data
sjer_aoi_WGS84 <- spTransform(sjer_aoi,
                                crs(state_boundary_us))

# what is the CRS of the new object
crs(sjer_aoi_WGS84)
# does the extent look like decimal degrees?
extent(sjer_aoi_WGS84)

## ----plot-again, fig.cap="US Map with SJER AOI Location"-----------------
# plot state boundaries
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n With SJER AOI",
     border="gray40")

# add US border outline
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)

# add AOI
plot(sjer_aoi_WGS84,
     pch = 19,
     col = "purple",
     add = TRUE)


## ----plot-centroid, fig.cap="figure out AOI polygon centroid."-----------
# get coordinate center of the polygon
aoi_centroid <- coordinates(sjer_aoi_WGS84)

# plot state boundaries
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n With SJER AOI",
     border="gray40")

# add US border outline
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)

# add point location of the centroid to the plot
points(aoi_centroid, pch=8, col="magenta", cex=1.5)


## ----challenge-code-MASS-Map, include=TRUE, results="hide", echo=FALSE, warning=FALSE, message=FALSE, fig.cap="challenge plot"----

# import data
sjer_aoi <- readOGR("data/week5/california/SJER/vector_data",
                      "SJER_crop")
sjer_roads <- readOGR("data/week5/california/madera-county-roads",
                      "tl_2013_06039_roads")

sjer_plots <- readOGR("data/week5/california/SJER/vector_data",
                      "SJER_plot_centroids")

# reproject line and point data
sjer_roads_utm  <- spTransform(sjer_roads,
                                crs(sjer_aoi))
# crop data
sjer_roads_utm <- crop(sjer_roads_utm, sjer_aoi)
sjer_roads_utm$RTTYP[is.na(sjer_roads_utm$RTTYP)] <- "unknown"
sjer_roads_utm$RTTYP <- as.factor(sjer_roads_utm$RTTYP)

par(xpd = T, mar = par()$mar + c(0,0,0,7))
# plot state boundaries
plot(sjer_aoi,
     main="SJER Area of Interest (AOI)",
     border="gray18",
     lwd=2)

# add point plot locations
plot(sjer_plots,
     pch = c(19, 8, 19)[factor(sjer_plots$plot_type)],
     col = c("green", "brown", "grey")[factor(sjer_plots$plot_type)],
     add = TRUE)

# add roads
plot(sjer_roads_utm,
     col = c("orange", "black", "brown")[sjer_roads_utm$RTTYP],
     add = TRUE)

# add legend
# to create a custom legend, we need to fake it
legend(258867.4, 4112362,
       legend=c("Study Area Boundary", "Roads", "Road Type 1",
                "Road Type 2", "Road Type 3", "Plot Type", levels(factor(sjer_plots$plot_type))),
       lty=c(1, NA, 1, 1, 1, NA, NA, NA, NA),
       pch=c(NA, NA, NA, NA, NA, NA, 19, 8, 19),
       col=c("black", "orange", "black", "brown", "gray18","purple","green", "brown", "grey"),
       bty="n",
       cex=.9)


## ----dev-off, echo=F, warning=F, message=F-------------------------------
# clean out the plot area
dev.off()

