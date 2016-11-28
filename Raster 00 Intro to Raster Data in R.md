## 初始R中的栅格数据

### 关于
在这个一节中，我们将回顾一下在R中处理栅格数据的基本原则、包和元数据(栅格属性)。在R中处理栅格数据时，我们需要讨论三个核心元数据元素：CRS，extent和resolution。这里将讲述如何处理栅格数据中的缺失和坏数据以及如何处理这些元素。最后，将介绍GeoTiff文件的格式。

**R 技能水平:** 中级 - 你已经掌握了R的基础知识

#### 目标

在这一节过后，你将：

* 明白什么是栅格数据，它基本属性是什么
* 知道如何在R中分析栅格数据
* 能够利用raster包把栅格数据导入到R中
* 能够快速地画一个栅格文件
* 理解单波段和多波段栅格数据的差异

#### 为了这个完成这个指南你需要做的事情

为了完成这一节，你将需要最新版本的R，最好，在你的电脑上也安装上的Rstudio。

#### 安装R包
* raster: install.packages("raster")
* rgdal: install.packages("rgdal")
* 更多的R包

#### 下载数据

激光雷达和影像数据可以用来生成栅格数据集，而激光雷达和影像数据本身由National Ecological Observatory Network’s Harvard Forest和San Joaquin Experimental Range收集，经由NEON总部处理。全部数据可以通过申请从NEON的网站获得。

**设置工作空间:** 本节假定你已把工作空间设置为下载和解压后的数据所在的位置。设置工作空间的大致方法可以从这里找到。
**R脚本和挑战性代码：** NEON数据课程具有一些挑战，它能增强你的技能。你可以在每节课的最后，获取本节课的所有R脚本代码。

### 关于栅格数据

栅格数据以网格值的形式被储存，在地图上以像素点的形式呈现。每个像素点代表着地球表面的一个区域。

![img](http://neondataskills.org/images/dc-spatial-raster/raster_concept.png)

图片：来自美国国家生态监测网络(National Ecological Observatory Network, NEON)

### 以栅格形式存储的数据的类型

栅格数据包括分类型和连续型。连续型栅格数据通常有一个变化范围。常见的连续型栅格数据有，

1. 降水图
2. 来自雷达数据的树高图
3. 一个地区的海拔图

哈佛森林的海拔图如下。在这个地图中，海拔是连续型数值变量。图例显示了数据值的变化范围，从300到420。

![img](http://neondataskills.org/images/rfigs/dc-spatial-raster/00-Raster-Structure/elevation-map-1.png)




一些栅格数据是分类型变量。每个像素点都是一个离散值(如土地覆盖类型，其值为森林或草地)而非海拔和温带这类连续型的变量。常见的分类地图有,

1. 土地覆盖和土地利用图。
2. 树高图被分为小树，中树和大树。
3. 海拔图被分为低海拔，中海拔和高海拔。

美国土地覆盖图

![img](http://neondataskills.org/images/spatialData/NLCD06_conus_lg.gif)

ENON哈佛森林分类海拔地图

地图图例中颜色表示的海拔类型。

![img](http://neondataskills.org/images/rfigs/dc-spatial-raster/00-Raster-Structure/classified-elevation-map-1.png)



### 什么是GEoTIFF??

栅格数据可以有不同的格式类型。在这个指南中，我们使用geotiff格式。它是基于.tif格式的扩展。一个.tif文件可以存储元数据，这些元数据描述了内嵌的标签信息。例如，当照片被保存为tif格式时，你的照相机信息可以存储为一个标签。这个标签描述了照相机的品牌和型号以及照片生成的日期。一个GeoTIFF是附加了空间信息作为标签的.tif标准文件。这些标签包含以下元数据。
1. 坐标参考系统(Coordinate Reference System, CRS)
2. 空间范围(extent)
3. 缺失值(NoDataValue)
4. 数据的分辨率(resolution)

在这个指南中，我们将讨论所有这些元数据标签。

更多关于.tif格式
* GeoFIFF on Wikipedia
* OSGEO TIFF documentation

### R中的栅格数据

让我们首先导入栅格数据集到R中，并分析它的元数据。为了在R中打开栅格数据，我们将使用raster和rgdal包。

```
# load libraries
library(raster)
library(rgdal)

# set working directory to ensure R can find the file we wish to import
# setwd("working-dir-path-here")
```
#### 用R打开栅格数据

我们在R中可以使用raster("栅格文件的路径")函数打开栅格数据。

> 数据提示： 对象名称。为了增加代码的可读性，文件和对象的名称应清晰地表明它指代的文件的内容。这个指南中的数据都收集自哈佛森林，因此我们按惯例命名它为datatype_HARV。

```
# Load raster into R
DSM_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

# View raster structure
DSM_HARV 

## class       : RasterLayer 
## dimensions  : 1367, 1697, 2319799  (nrow, ncol, ncell)
## resolution  : 1, 1  (x, y)
## extent      : 731453, 733150, 4712471, 4713838  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif 
## names       : HARV_dsmCrop 
## values      : 305.07, 416.07  (min, max)

# plot raster
# note \n in the title forces a line break in the title
plot(DSM_HARV, 
     main="NEON Digital Surface Model\nHarvard Forest")
```

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/00-Raster-Structure/open-raster-1.png)

这个地图展示的是哈佛森林的海拔。最高处的海拔是比400米高还是400英尺高？可能需要我们从元数据中了解更多数据属性信息。

#### 坐标参考系统(Coordinate Reference System, CRS)

坐标参考系统(Coordinate Reference System, CRS)告诉R栅格数据在地里空间中所处的位置。同时，也会告诉R栅格数据应该展平或者投影到地里空间当中。

![img](https://source.opennews.org/media/cache/b9/4f/b94f663c79024f0048ae7b4f88060cb5.jpg)

采用不同投影方式的美国地图。注意形状的不同于投影方式相关。这些不同是由把数据平铺在二维平面上的计算方式不同造成的。

##### 什么使空间数据线在地图上规则显示

大量的资源可以详细地来描述坐标参考系统和投影方式(更多相关阅读，参考下面)。为了这个项目的目的，最重要的是理解来自同一个位置而用不同的投影存储方式的数据在GIS和其它软件并不能规则显示。因此，在用像R这样的软件处理空间数据时，识别数据利用的参考系，在数据处理和分析时利用它是十分重要的。

更多相关阅读

* 一个综合的CRS信息在线库
* QGIS文件-CRS概览
* 选择正确的地图投影方式
* NCEAS对R中CRS的概览


##### 用R查看栅格数据的坐标系统(CRS)

我们可以查看用crs函数查看相关R对象的CRS。我们也能把CRS赋值给R对象。

```
# view resolution units
crs(DSM_HARV)

## CRS arguments:
##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0

# assign crs to an object (class) to use for reprojection and other tasks
myCRS <- crs(DSM_HARV)
myCRS

## CRS arguments:
##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
```
对象DSM_HARV的参考坐标系统(CRS)告诉我们这个数据使用的UTM投映方式。

![img](https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Utm-zones-USA.svg/720px-Utm-zones-USA.svg.png)

美国跨过的UTM时区图


在这个例子中坐标参考系使用的是PROJ 4格式。这意味着投影信息作为一系列字符元素串联在了一起，每部分用+表示开始。

```
+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0
```

在这份指南当中，我们将更加关注CRS的前几个部分。

* +proj=utm	数据的投影方式。我们数据使用的是统一横轴墨卡托投影(Universal Transverse Mercator, UTM)

* +zone=18       UTM把世界分隔成不同的时区，这个元素告诉你你使用的数据属于哪个区。Harvard Forest属于18区。

* +dattum=WGS84   datum用于定义投影的中心。我们的栅格数据采用WGS84 标准。

* +units=m        数据在水平面上的单位。我们的单位是m。


#### 广度(Eextent)

空间广度是我们数据所包含的地理区域。

![img](http://neondataskills.org/images/dc-spatial-raster/spatial_extent.png)

图片来源: National Ecological Observatory Network (NEON)

R中的空间对象的空间广度是指最北、南、东和西的边界或位置。换句话说，extent 表示的是空间对象的整个地理范围。

#### 分辨率(Resolution)

栅格数据都有水平面上(x和y)的分辨率。分辨率指的是每个像素点所代表地面区域的大小。我们的数据单位是m。鉴于我们数据分辨率是1X1，这意味着每个像素点代表着水平面上1X1m的面积。

![img](http://neondataskills.org/images/dc-spatial-raster/raster_resolution.png)



查看分辨率单位的最好方法是查看坐标系统。注意到我们的数据是包含：+units=m。

```
crs(DSM_HARV)

## CRS arguments:
##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
```

#### 计算栅格数据的最小值和最大值

知道栅格数据的最大值和最小值是非常有用的。在这个例子当中，鉴于我们处理的是海拔数据，这些值表示的是我们样地中海拔的最小和最大值范围。

对我们来说，栅格指标的计算常常嵌入到了geotiff数据当中。无论如何，如果它们没有被计算，我们可以使用setMinMax函数来计算它们。

```
# This is the code if min/max weren't calculated: 
# DSM_HARV <- setMinMax(DSM_HARV) 

# view the calculated min value
minValue(DSM_HARV)

## [1] 305.07

# view only max value
maxValue(DSM_HARV)

## [1] 416.07
```

我们可以看出我们样地的海拔范围是从305.07m到416.07m。

#### 栅格数据中的缺失值(NoDataValue)

栅格数据常会有缺失数据出现。这个像素点代表的数据缺失或者数据没有收集到。

栅格数据通常是正方形或长方形。因此，如果我们的数据形状不是正方形或者长方形，栅格数据边界处的像素点将会有数据缺失。通过航天飞机收集的数据经常会发生这种状况，因为航天飞机只能飞过部分指定区域。

下面这张图像中，黑色的像素点是缺失数据(NodataValue)。影像并没有收集到这些区域的数据。

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/00-Raster-Structure/demonstrate-no-data-black-1.png)

接下来这幅图，黑色的边界被赋值为NodataValue。R并不能处理包含NodataValue的像素点。R中会把缺失数据(NoDataValule)赋值为NA。

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/00-Raster-Structure/demonstrate-no-data-1.png)

 

**缺失数据标准**

缺失数据有不同的规则。-9999经常在遥感技术和大气数据中使用。它也被 National Ecological Observatory Network (NEON)当作标准使用。

如果幸运的话，GeoTIFF文件会有一个标签，这个标签告诉我们什么是缺失数据。要是不够幸运，我们可以通过栅格数据的元数据找到这个信息。如果缺失数据被储存到了GeoTIFF标签当中，当用R打开栅格数据的时候，它将会把每个缺失值赋值为NA。如同上面展示的那样，NA将会被R忽略掉。

#### 栅格数据中的坏数据

坏数据不同于缺失数据。坏数据会出现在数据适用范围之外。

坏数据例子。

* 归一化植被指数(The normalized difference vegetation index, NDVI)。它是绿色的衡量，其值在-1到1之间。任何超出这个区间的值都被认为是坏数据或者不能计算的值。
* 图像的反射率依据数据缩放的指标不同通常在0-1或0-10000之间变化。因此，任何大于1或者大于10000的值都可能是在数据收集和处理过程中的错误造成的。

**找出坏数据**

有时候，栅格数据的元数据会告诉你这个数据的预期范围。不在这个范围内的数据是受怀疑的，在分析的数据时，我们要仔细考虑。有时候，在查看数据时，我们需要有一些常识和学科知识。只有这样，我们才能发现数据中存在的问题。

#### 创建栅格数据的直方图

我们要分析栅格数据当中的值的分布的时候，我们可以使用hist()函数，它会产生一个直方图。直方图在鉴别异常值和坏数据是非常有用的。

```
# view histogram of data
hist(DSM_HARV,
     main="Distribution of Digital Surface Model Values\n Histogram Default: 100,000 pixels\n NEON Harvard Forest",
     xlab="DSM Elevation Value (m)",
     ylab="Frequency",
     col="wheat")

## Warning in .hist1(x, maxpixels = maxpixels, main = main, plot = plot, ...):
## 4% of the raster cells were used. 100000 values used.
```

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/00-Raster-Structure/view-raster-histogram-1.png)



需要注意的是用R创建直方图的时候，错误信息的信息会提示。

```
Warning in .hist1(x, maxpixels = maxpixels, main = main, plot = plot, ...): 4% of the raster cells were used. 100000 values used.
```

这个错误是因为直方图中默认包含的像素最大值是100000。这个最大值确保我们的数据非常大的时候能够高效的运行。

* 可以在R-bloggers上查看更多关于R的直方图

我们可以定义最大的像素点以确保所有像素点的数据都包含在了直方图当中。这样做的时候一定要注意当数据量非常大的时候迫使R画出所有像素点值的直方图可能存在问题的。

```
# View the total number of pixels (cells) in is our raster 
ncell(DSM_HARV)

## [1] 2319799

# create histogram that includes with all pixel values in the raster
hist(DSM_HARV, 
     maxpixels=ncell(DSM_HARV),
     main="Distribution of DSM Values\n All Pixel Values Included\n NEON Harvard Forest Field Site",
     xlab="DSM Elevation Value (m)",
     ylab="Frequency",
     col="wheat4")
```

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/00-Raster-Structure/view-raster-histogram2-1.png)

#### 栅格数据的波段

我们使用的数字表面图像(Digital Surface Model object, DSM_HARV)是一个单波段的栅格数据。这意味着仅有一个数据集被存储到了栅格数据当中，即一个时期当中地表海拔。

![img](http://neondataskills.org/images/dc-spatial-raster/single_multi_raster.png)



栅格数据集可以包含一个或多个波段。我们可以使用raster()函数把单波段或多波段的栅格数据的一个波段导入进来。我们可以使用nlayers()查看栅格数据有几个波段。

```
# view number of bands
nlayers(DSM_HARV)

## [1] 1
```

无论如何，多波段的栅格数据是指每个栅格多个变量值，或者是变量在不同时期的值。通常，raster()函数只能导入删格数据的第一个波段值，无论栅格数据是单波段还是多波段。关于多波段的说明可以查看这个指南的第四节，使用R对多波段栅格数据处理。

#### 查看栅格文件的属性

需要记住的是，GeoFIFF文件包含了一系列的内嵌标签，这些标签包含了栅格数据的元数据信息。目前，在把栅格数据导入到R之后，我们已经研究了一些元数据信息。无论如何，我们可以使用GDALinfo('path-to-raster-here')函数在栅格数据导入R之前查看元数据信息。

```
# view attributes before opening file
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

这个输出当中要注意的一些事情：

1. 投影方式使用的是proj4形式的字符串：+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs
2. 我们可以发现缺失数据(NoDataValue)：-9999
3. 我们可以看出这个文件包含几个波段(band)：1
4. 我们可以这个数据x和y分辨率(resolution)：1
5. 我们可以查看这个数据的最小值和最大值：Bmin 和 Bmax

在把数据导入R之前，用GDALinfo查看数据信息是十分理想的。

