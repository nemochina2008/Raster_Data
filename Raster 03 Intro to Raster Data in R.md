## R中使用栅格数据的计算—从一个栅格数据提取另一个栅格数据和提取一个定义位置的像素值

### 关于
为了生成一个新的栅格数据，我们通常需要合并栅格数据的值以及对栅格数据计算。这一节主要包含使用基本栅格数据方法和overlay()函数从一个栅格数据中提取一个栅格数据，以及如何从一系列位点提取像素值。例如野外样地的缓冲区。

**R 技能水平:** 中级 - 你已经掌握了R的基础知识

#### 目标

在这一节后，你将：

* 能够使用栅格方法对两个栅格数据进行提取
* 知道如何使用R的overlay()函数对两个栅格数据进行一个更加有效的提取

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

### 栅格数据的计算

为了生成一个新的栅格数据，我们常常要对两个或者更多的栅格数据进行计算。例如，如果我们对把树高映射到整个样地非常感兴趣，我们需要比较数字表面模型(DSM,树木顶端的高度)和数字地形模型间的差异(DTM, 地面水平)。结果数据集常被称为冠层高度模型。它通常是指树木和建筑物的实际高度(去除了地面平均海拔的影响)。

#### 数据的加载

我们使用raster包对栅格数据进行导入和计算。我们将使用NEON上的哈佛森林样地的DTM(NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif

)和DSM(NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif

)数据。

```
# load raster package
library(raster)

# view info about the dtm & dsm raster data that we will work with.
GDALinfo("NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")

## rows        1367 
## columns     1697 
## bands       1 
## lower left origin.x        731453 
## lower left origin.y        4712471 
## res.x       1 
## res.y       1 
## ysign       -1 
## oblique.x   0 
## oblique.y   0 
## driver      GTiff 
## projection  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
## file        NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif 
## apparent band summary:
##    GDType hasNoDataValue NoDataValue blockSize1 blockSize2
## 1 Float64           TRUE       -9999          1       1697
## apparent band statistics:
##     Bmin   Bmax    Bmean      Bsd
## 1 304.56 389.82 344.8979 15.86147
## Metadata:
## AREA_OR_POINT=Area

GDALinfo("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

## rows        1367 
## columns     1697 
## bands       1 
## lower left origin.x        731453 
## lower left origin.y        4712471 
## res.x       1 
## res.y       1 
## ysign       -1 
## oblique.x   0 
## oblique.y   0 
## driver      GTiff 
## projection  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
## file        NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif 
## apparent band summary:
##    GDType hasNoDataValue NoDataValue blockSize1 blockSize2
## 1 Float64           TRUE       -9999          1       1697
## apparent band statistics:
##     Bmin   Bmax    Bmean      Bsd
## 1 305.07 416.07 359.8531 17.83169
## Metadata:
## AREA_OR_POINT=Area
```

正如geoTiff标签显示的那样，两个数据数据：

* 有相同的坐标参考系统
* 有相同的分辨率
* 定义了最大值和最小值

接下来，我们加载数据。

```
# load the DTM & DSM rasters
DTM_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
DSM_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

# create a quick plot of each to see what we're dealing with
plot(DTM_HARV,
     main="Digital Terrain Model \n NEON Harvard Forest Field Site")
     
plot(DSM_HARV,
     main="Digital Surface Model \n NEON Harvard Forest Field Site")
```

#### 栅格数据的两种计算方法

我们可以使用两种不同的方法计算栅格数据：

* 在R中使用栅格数据方法直接对两个栅格数据进行提取

为了寻找更加有效的方法—尤其是在栅格数据或者计算量很大的时候：

* 使用overlay()函数

##### 栅格数据方法和观测高度模型

我们可以通过对两个栅格数据简单提取的方法进行栅格数据的计算。在空间地里中，我们称之为栅格数学方法。

接下来，我们从DSM中减去DTM生成一个观测高度模型。

```
# Raster math example
CHM_HARV <- DSM_HARV - DTM_HARV 

# plot the output CHM
plot(CHM_HARV,
     main="Canopy Height Model - Raster Math Subtract\n NEON Harvard Forest Field Site",
     axes=FALSE) 
```

我们查看一下我们新生成的观测高度模型(CHM)的值的分布状况。

```
# histogram of CHM_HARV
hist(CHM_HARV,
  col="springgreen4",
  main="Histogram of Canopy Height Model\nNEON Harvard Forest Field Site",
  ylab="Number of Pixels",
  xlab="Tree Height (m) ")
```

注意到CHM的值的范围在0到30m之间。这对哈佛森林的树木有什么意义呢？

##### 高效的栅格计算：overlay() 函数

栅格的数学方法，如同我们上面做的那样，是一个很适合的栅格数据计算方法，条件是：

1. 我们使用的栅格数据比较小
2. 我们进行的计算比较简单

无论如何，当计算变得复杂，数据量较大的时候，栅格数学方法并不是一个高效的方法。overlay() 函数是在下面的情况下是一个更加高效的方法。语法如下：

```
outputRaster <- overlay(raster1, raster2, fun=functionName)
```

**数据提示：** 如果删格数据被存放到了R的RasterStack或者RasterBrick对象当中，我们应该使用calc() 函数。overlay() 函数对堆栈型的栅格数据不起作用。

```
CHM_ov_HARV<- overlay(DSM_HARV,
                      DTM_HARV,
                      fun=function(r1, r2){return(r1-r2)})

plot(CHM_ov_HARV,
  main="Canopy Height Model - Overlay Subtract\n NEON Harvard Forest Field Site")
```

用栅格数学方法和overlay()函数计算出来的CHM画出的图可以比较吗？

**数据提示：** 一个函数通常定义了许多命令，来对输入的对象进行计算。

函数在重复计算的时候是十分有用的。R中函数的语法形式如下：

```
functionName <- function(variable1, variable2){WhatYouWantDone, WhatToReturn}
```

#### 导出GeoTIFF对象

现在我们已经生成了一个新的删格数据，我们可以使用writeRaster()函数把数据以GeoTIFF的格式导出去。

当我们把栅格对象写入到一个GeoTFF文件的时候，我们需要把它命名为chm_HARV.tiff。这个名称能够让我们快速记起这个数据的内容以及数据采集的地方。如果你没有指定一个完整的文件路径，writeRaster()函数会把结果文件生成到你的默认工作目录当中。

```
# export CHM object to new GeotIFF
writeRaster(CHM_ov_HARV, "chm_HARV.tiff",
            format="GTiff",  # specify output format - GeoTIFF
            overwrite=TRUE, # CAUTION: if this is true, it will overwrite an
                            # existing file
            NAflag=-9999) # set no data value to -9999
```

## writeRaster()函数参数##

我们上面使用到函数参数有：

* format: 指定文件的格式为GTiff或者GeoTiFF。
* overwrite: 其值为TRUE时，R将会重新写入到工作目录任何相同名称的文件当中。使用这个参数，一定要注意。
* NAflag: 为geotiff标签设置NodatValue为-9999，这是国家生态观测网络(NEON)的标准的NodataValue值。