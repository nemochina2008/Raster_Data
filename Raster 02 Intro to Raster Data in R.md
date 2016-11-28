## 当栅格数据不规则时在R中投影栅格数据

### 关于
有时候当我们画或者分析栅格数据时，我们会遇到栅格数据不规则。栅格不规则通常是由不同坐标参考系统造成的。这一节，我们将介绍如何处理不同坐标参考系统的栅格数据。具体主要介绍使用R的raster包中的projectRaster()函数处理投射栅格数据。

**R 技能水平:** 中级 - 你已经掌握了R的基础知识

#### 目标

在这项活动后，你将：

* 能够使用R投影栅格数据

#### 为了这个完成这个指南你需要做的事情

为了完成这个指南，你将需要最新版本的R，最好，在你的电脑上也安装上的Rstudio。

#### 安装R包
* raster: install.packages("raster")
* rgdal: install.packages("rgdal")
* 更多的R包

#### 下载数据

激光雷达和影像数据可以用来生成栅格数据集，而激光雷达和影像数据本身由National Ecological Observatory Network’s Harvard Forest和San Joaquin Experimental Range收集，经由NEON总部处理。全部数据可以通过申请从NEON的网站获得。

**设置工作空间:** 本节假定你已把工作空间设置为下载和解压后的数据所在的位置。设置工作空间的大致方法可以从这里找到。
**R脚本和挑战性代码：** NEON数据课程具有一些挑战，它能增强你的技能。你可以在每节课的最后，获取本节课的所有R脚本代码。

#### 更多的资源
* 阅读更多R的raster包的相关内容

### R中栅格数据的投影

上一节“使用R画栅格数据”中，为了得到一个漂亮的底图我们学习了如何把栅格数据放到山影图之上。这其中使用的所有的数据都使用的是相同的坐标参考系统。当数据不规则时，究竟会发生什么呢？

在这一节中，我们将使用raster和rgdal包。

```
# load raster package
library(raster)
library(rgdal)
```

我们将把哈佛森林的数字地形图(DTM_HARV)放在山影图之上(DTM_hill_HARV)。

```
# import DTM
DTM_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
# import DTM hillshade
DTM_hill_HARV <- 
  raster("NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_DTMhill_WGS84.tif")

# plot hillshade using a grayscale color ramp 
plot(DTM_hill_HARV,
    col=grey(1:100/100),
    legend=FALSE,
    main="DTM Hillshade\n NEON Harvard Forest Field Site")

# overlay the DTM on top of the hillshade
plot(DTM_HARV,
     col=terrain.colors(10),
     alpha=0.4,
     add=TRUE,
     legend=FALSE)
```

我们的结果是比较奇怪的。数字地形图(DTM_HARV)并不能放到山影图之上。山影图能够单独画出。我们把DTM单独画图已确定数据的确存在。

**代码提示：** 对R中布尔元素，例如add=T，你可以使用T和F代替TRUE和FALSE。 

``` 
# Plot DTM 
plot(DTM_HARV,
     col=terrain.colors(10),
     alpha=1,
     legend=F,
     main="Digital Terrain Model\n NEON Harvard Forest Field Site")
```

我们的数字地形图(DTM_HARV)包含有数据，也能够很好画出来。接下来，我们查看数据的坐标参考系统，同时把它山影图做对比。

```
# view crs for DTM
crs(DTM_HARV)

## CRS arguments:
##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0

# view crs for hillshade
crs(DTM_hill_HARV)

## CRS arguments:
##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
```

DTM_HARV从用的是UTM投影方式。DTM_hill_HARV采用的是Geographic WGS84，这指的是经纬度值。因为两个栅格数据从用不同的坐标参考系统，它们在R中不能规则显示。我们需要把DTM_HARV投影到UTM坐标参考系统中。同样，我们可以投影DTM_hill_HARV到WGS84中。

### 投影栅格数据

我们可以使用projectRaser()函数可以把栅格数据投影到新的坐标参考系统当中。切记当你定义了栅格数据的投影方式时，投影方式才能发挥作用。幸运的是，DTM_hill_HARV有一个定义好的坐标参考系统。

**数据提示：** 当我们投影栅格数据时，我们需要把它从一个栅格移动到另一个栅格。因此，我们需要更改数据。当我们处理栅格数据时，一定要记住这一点。

为了使用projectRaster()函数，我们需要定义两个事情：

1. 我们需要投影的对象
2. 我们投影对象的坐标参考系统

语法形式是这样的：projectRaster(RasterObject, crs=CRSToReprojectTo)

我们希望用山影图的坐标参考系统匹配DTM_HARV数据。因此，我们把DTM_HARV的坐标参考系系统放在projectRaster()函数赋给山影图中。

```
# reproject to UTM
DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, 
                                       crs=crs(DTM_HARV))

# compare attributes of DTM_hill_UTMZ18N to DTM_hill
crs(DTM_hill_UTMZ18N_HARV)

## CRS arguments:
##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0

crs(DTM_hill_HARV)

## CRS arguments:
##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0

# compare attributes of DTM_hill_UTMZ18N to DTM_hill
extent(DTM_hill_UTMZ18N_HARV)

## class       : Extent 
## xmin        : 731397.3 
## xmax        : 733205.3 
## ymin        : 4712403 
## ymax        : 4713907

extent(DTM_hill_HARV)

## class       : Extent 
## xmin        : -72.18192 
## xmax        : -72.16061 
## ymin        : 42.52941 
## ymax        : 42.54234
```

需要提醒的是上面的输出当中DTM_hill_UTMZ18N_HARV的crs()现在已经是UTM投影方式。无论如何，DTM_hill_UTMZ18N_HARV的范围是是不同于DTM_hill_HARV。

### 处理栅格数据分辨率

接下来我们将看一下我们重新投影的山影图的分辨率。

```
# compare resolution
res(DTM_hill_UTMZ18N_HARV)

## [1] 1.000 0.998
```

TM_hill_UTMZ18N_HARV的分辨率是1 × 0.998。然而，我们知道数据的分辨率是1m × 1m。通过一行代码我们能够使用R使我们的新投影的栅格数据的分辨率变成1m × 1m。

```
# adjust the resolution 
DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, 
                                  crs=crs(DTM_HARV),
                                  res=1)
# view resolution
res(DTM_hill_UTMZ18N_HARV)

## [1] 1 1
```

我们画我们重新投影的栅格数据。

```
# plot newly reprojected hillshade
plot(DTM_hill_UTMZ18N_HARV,
    col=grey(1:100/100),
    legend=F,
    main="DTM with Hillshade\n NEON Harvard Forest Field Site")

# overlay the DTM on top of the hillshade
plot(DTM_HARV,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)
```

现在我们已经成功把数字地形图放到了山影图之上生成一个漂亮的纹理图。