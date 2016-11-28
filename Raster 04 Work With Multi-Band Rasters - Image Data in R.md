

## R中处理多波段栅格数据—图像数据

### 关于
这一节介绍如何使用R导入和画多波段栅格数据图形。它也包括在R中如何使用plotRGG()函数画三个波段的颜色图。

**R 技能水平:** 中级 - 你已经掌握了R的基础知识

#### 目标

在这一节后，你将：

* 知道如何判别单波段和多波段图
* 能够使用raster包把多波段的栅格数据导入到R中
* 能够使用R中的plotRGB()函数画出多波段颜色的栅格数据
* 理解栅格数据中的缺失值的意义

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

### 图像的基础知识—关于光谱遥感数据

### R中关于栅格数据的波段

正如“初始的栅格数据”那一节介绍的，栅格数据可以包含一个或多个波段。

![img](http://neondataskills.org/images/dc-spatial-raster/single_multi_raster.png)

栅格数据可以包含一个或多个波段。我们可以使用raster()函数从单波段或多波段的栅格数据中把一个波段导入进来

为了使用R处理多波段栅格数据，我们需要使用一下几种方法。

* 为了导入多波段数据，我们使用stack()函数
* 如果我们希望组合多波段数据，我们可以使用plotRGB()函数画三个波段栅格图像

### 关于多波段图像

对我们大多数人来说，颜色图像是一种最熟悉的多波段栅格数据。一个基本的颜色图像由三个波段组成：红，绿和蓝。每个波段代表着电磁波普中红，绿和蓝光的反射率。三个波段的像素亮点组合能够形成我们在图像中看到的颜色。

![img](http://neondataskills.org/images/dc-spatial-raster/RGBSTack_1.jpg)

颜色图有3个波段组成-红，绿和蓝。当这三个波段一起在GIS或者像Photoshop或者其它图像处理软件中显示时，它们会被渲染成一个颜色图。

我们可以分别画出多个波段图中的每一个波段。

**数据提示：** 在许多GIS应用中，单一的波段常在灰色调色板中显示。因此，我们也使用灰色调色板显示每个波段。

我们可以组合三个波段一起形成颜色图像。

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/04-Multi-Band-Rasters-In-R/demonstrate-RGB-Image-1.png)

我们也可以把三个波段组合在一起画出颜色图。

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/04-Multi-Band-Rasters-In-R/plot-RGB-now-1.png)



在多波段栅格数据中，栅格数据常有相同的广度，坐标参考系统和分辨率。

### 多波段栅格数据的其他类型

多波段栅格数据可能包含：

1. 时间序列： the same variable, over the same area, over time. Check out [Raster Time Series Data in R ](http://neondataskills.org/R/Raster-Times-Series-Data-In-R/)to learn more about time series stacks.
2. 多光谱或者高光谱图像。: image rasters that have 4 or more (multi-spectral) or more than 10-15 (hyperspectral) bands. Check out the NEON Data Skills Imaging Spectroscopy HDF5 in R tutorial for more about working with hyperspectral data cubes.

### 在R中开始处理多波普数据

为了处理多波普栅格数据，我们需要使用raster和rgdal包。

```
# work with raster data
library(raster)
# export GeoTIFFs and other core GIS functions
library(rgdal)
```

在这一节，我们处理使用的多波普数据来自于imagery collected using the NEON Airborne Observation Platform high resolution camera over the NEON Harvard Forest field site。每个RGB图像是一个3波段栅格数据。同样的步骤可以应用到4或多波段光谱图像，例如Landsat图像。

如果我们使用raster()函数把rasterStack读入到R中，它仅能读入第一个波段。我们可以使用plot函数画这个波段。

```
# Read in multi-band raster with raster function. 
# Default is the first band only.
RGB_band1_HARV <- 
  raster("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

# create a grayscale color palette to use for the image.
grayscale_colors <- gray.colors(100,            # number of different color levels 
                                start = 0.0,    # how black (0) to go
                                end = 1.0,      # how white (1) to go
                                gamma = 2.2,    # correction between how a digital 
                                # camera sees the world and how human eyes see it
                                alpha = NULL)   #Null=colors are not transparent

# Plot band 1
plot(RGB_band1_HARV, 
     col=grayscale_colors, 
     axes=FALSE,
     main="RGB Imagery - Band 1-Red\nNEON Harvard Forest Field Site") 
```

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/04-Multi-Band-Rasters-In-R/read-single-band-1.png)

```
# view attributes: Check out dimension, CRS, resolution, values attributes, and 
# band.
RGB_band1_HARV

## class       : RasterLayer 
## band        : 1  (of  3  bands)
## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
## resolution  : 0.25, 0.25  (x, y)
## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif 
## names       : HARV_RGB_Ortho 
## values      : 0, 255  (min, max)
```



注意到当我们查看GRB_Band1属性时，我们发现：

band: 1 (of 3 bands)

这里R告诉我们这个特别栅格数据对象有三个以上的波段。

**数据提示：** 栅格数据对象的波段的数目可以使用nbands槽查看。语句是这样的ObjectName@file@nbands，对我们的文件来说是：RGB_band1@file@nbands。

### 栅格图像数据

接下来，让我们验证栅格数据的最小值和最大值。值的广度是什么？

```
# view min value
minValue(RGB_band1_HARV)

## [1] 0

# view max value
maxValue(RGB_band1_HARV)

## [1] 255
```

这个栅格数据的值在0和255之间。这些值代表着图像相关波段的光亮度值的大小。在RGB图像(红，绿和蓝)中，波段1是红色波段。当我们画红色波段，大的数表示像素点有更强的红色。小的值表明像素点有更弱的红色。为了画一个RGB图像，我们使用红+绿+蓝来表示一个单一颜色来创建一个全色图，与数码相机创建的颜色图像相似。

### 导入一个指定的波段

我们可以使用raster()函数通过指定brand=N可以导入栅格数据对象中的指定波段(N是我们希望处理的波段)。为了导入绿色波段，我们使用band=2。

```
# Can specify which band we want to read in
RGB_band2_HARV <- 
  raster("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", 
           band = 2)

# plot band 2
plot(RGB_band2_HARV,
     col=grayscale_colors, # we already created this palette & can use it again
     axes=FALSE,
     main="RGB Imagery - Band 2- Green\nNEON Harvard Forest Field Site")
```

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/04-Multi-Band-Rasters-In-R/read-specific-band-1.png)


```
# view attributes of band 2 
RGB_band2_HARV

## class       : RasterLayer 
## band        : 2  (of  3  bands)
## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
## resolution  : 0.25, 0.25  (x, y)
## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif 
## names       : HARV_RGB_Ortho 
## values      : 0, 255  (min, max)  
```

注意到波段2是3个波段中的第二个波段。

#### 挑战：单波段图形的意义

比较波段1(红)和波段2(绿)的图像。相比波段1，波段2图像中森林更暗或者更亮。

### R中栅格堆

接下来，我们将处理三个波段图像这个R栅格堆对象。我们将画出3波段图像。

为了导入所波段栅格数据的所有波段，我们使用stack()函数。

```
# Use stack function to read in all bands
RGB_stack_HARV <- 
  stack("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

# view attributes of stack object
RGB_stack_HARV

## class       : RasterStack 
## dimensions  : 2317, 3073, 7120141, 3  (nrow, ncol, ncell, nlayers)
## resolution  : 0.25, 0.25  (x, y)
## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## names       : HARV_RGB_Ortho.1, HARV_RGB_Ortho.2, HARV_RGB_Ortho.3 
## min values  :                0,                0,                0 
## max values  :              255,              255,              255
```

我们可以使用RGB_stack_HARV@layers查看每个波段的属性。如果我们有上千个波段，我们可以使用RGB_stack_HARV[[1]]指定我们想查看的波段。我们也可以使用plot()和hist()函数来画和查看栅格波段值的分布。

```
# view raster attributes
RGB_stack_HARV@layers

## [[1]]
## class       : RasterLayer 
## band        : 1  (of  3  bands)
## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
## resolution  : 0.25, 0.25  (x, y)
## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif 
## names       : HARV_RGB_Ortho.1 
## values      : 0, 255  (min, max)
## 
## 
## [[2]]
## class       : RasterLayer 
## band        : 2  (of  3  bands)
## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
## resolution  : 0.25, 0.25  (x, y)
## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif 
## names       : HARV_RGB_Ortho.2 
## values      : 0, 255  (min, max)
## 
## 
## [[3]]
## class       : RasterLayer 
## band        : 3  (of  3  bands)
## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
## resolution  : 0.25, 0.25  (x, y)
## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif 
## names       : HARV_RGB_Ortho.3 
## values      : 0, 255  (min, max)

# view attributes for one band
RGB_stack_HARV[[1]]

## class       : RasterLayer 
## band        : 1  (of  3  bands)
## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
## resolution  : 0.25, 0.25  (x, y)
## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif 
## names       : HARV_RGB_Ortho.1 
## values      : 0, 255  (min, max)

# view histogram of all 3 bands
hist(RGB_stack_HARV,
     maxpixels=ncell(RGB_stack_HARV))

# plot all three bands separately
plot(RGB_stack_HARV, 
     col=grayscale_colors)
```

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/04-Multi-Band-Rasters-In-R/plot-raster-layers-1.png)


```
# revert to a single plot layout 
par(mfrow=c(1,1)) 

# plot band 2 
plot(RGB_stack_HARV[[2]], 
     main="Band 2\n NEON Harvard Forest Field Site",
     col=grayscale_colors)
```

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/04-Multi-Band-Rasters-In-R/plot-raster-layers-3.png)

### 创建一个三波段图像

为了能够在R中显示三波段的颜色图，我们使用plotRGB()函数。

这个函数要求我们：

1. 确认我们希望在红，绿和蓝区域中的波段。plotRGB()中1=red，2=green和3=blue。无论如何，你能够定义你希望画的图像。如果你定义了，波段的自定义是非常有用的。例如一个近红外波段，可以创建一个近红外图像。
2. 更改图像的stretch增加或者降低图像的对比度。

让我们画一个三波段图。

```
# Create an RGB image from the raster stack
plotRGB(RGB_stack_HARV, 
        r = 1, g = 2, b = 3)
```

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/04-Multi-Band-Rasters-In-R/plot-rgb-image-1.png)



上面的图像是非常漂亮的。我们可以使用stretch='lin'或者stretch='hist'来分析是否需要改变图像的清晰度和对比度。

![img](http://neondataskills.org/images/dc-spatial-raster/imageStretch_dark.jpg)

当图像的像素点的亮度值的范围接近255时，一个更加亮的图像将被渲染。我们可以把这些值拉伸到0到255之间增加图像的对比度。

```
# what does stretch do?
plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3, 
        scale=800,
        stretch = "lin")
```

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/04-Multi-Band-Rasters-In-R/image-stretch-1.png)

```
plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3, 
        scale=800,
        stretch = "hist")
```

![ ](http://neondataskills.org/images/rfigs/dc-spatial-raster/04-Multi-Band-Rasters-In-R/image-stretch-2.png)

在这个例子中，由于光亮度值很好地分布在0-255之间，拉伸(stretch)并没有显著增加图像的对比。