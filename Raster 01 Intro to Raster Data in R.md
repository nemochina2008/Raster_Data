## 使用R画栅格数据

### 关于
这个指南将介绍在R中如何使用plot()函数画出栅格数据。也将介绍如何把栅格数据放到山影图之上生成一个更有说服力的图形。

**R 技能水平:** 中级 - 你已经掌握了R的基础知识

#### 目标

在这项活动后，你将：

* 知道在R中如何画一个单波段图
* 知道如何把栅格数据放到山影图之上生成一个更有说服力的图形

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

### 使用R画出栅格数据

在这个指南中，我们将画出NEON Harvard 森林野外样地的数字表面模型图。我们将使用hist()函数探究栅格数据值。对于分类型数据的图像，设置breaks参数来获取对我们的数据有意义的条带。

这个指南中，我们将使用raster和rgdal包。如果你没有上一节“初始栅格数据”中DSM_HARV对象，请现在创建这个对象。

```
# if they are not already loaded
library(rgdal)
library(raster)

# set working directory to ensure R can find the file we wish to import
# setwd("working-dir-path-here")

# import raster
DSM_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
```

首先，让我们使用plot()函数画出数字表面模型对象(DSM_HARV)。我们用参数 main='title'为图像添加了标题。

```
# Plot raster object
plot(DSM_HARV,
     main="Digital Surface Model\nNEON Harvard Forest Field Site")
```

### 使用条带画栅格图

依据数值的范围我们可以把数据特长化或者说颜色化，而不一定使用连续的颜色图。分类地图更容易比较。无论如何，在确定条带(breaks)时，用直方图首先查看一下数据的分布是非常有用的。hist()函数的breaks参数能够告诉R使用更多或者更少的条带。

如果我们命名了直方图，我们能够很清楚的查看每个条带的值及其对应的个数。



``` 
# Plot distribution of raster values 
DSMhist<-hist(DSM_HARV,
     breaks=3,
     main="Histogram Digital Surface Model\n NEON Harvard Forest Field Site",
     col="wheat3",  # changes bin color
     xlab= "Elevation (m)")  # label the x-axis

## Warning in .hist1(x, maxpixels = maxpixels, main = main, plot = plot, ...):
## 4% of the raster cells were used. 100000 values used.


# Where are breaks and how many pixels in each category?
DSMhist$breaks

## [1] 300 350 400 450

DSMhist$counts

## [1] 32077 67470   453
```

提醒信息？记住，直方图中默认的数据集是100000。我们可以迫使它显示所有像素点，并画出直方图。我们可以看出10000个数据已经能够很好的代表我们的数据了。

看我们的直方图，R给出了数据的条带信息：

* 300-350m, 350-400m, 400-450m

我们可以确定大多数像素点都落在了350到400之间，少量的值落在了这个范围之外。我们可以限定不同的条带，如果我们希望每个条带的像素点有不同的分布。

我们可以用这些条带来画栅格数据。我们使用terrain.colors()函数来获取三种颜色的颜色版用在我们的图形当中。

breaks参数允许我们添加条带。为了限制条带的位置，我们使用这个语句: breaks=c(value1, value2, values)。我们可以包含更多或者更少的条带。

```
# plot using breaks.
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = terrain.colors(3),
     main="Digital Surface Model (DSM)\n NEON Harvard Forest Field Site")
```

* 数据提示：注意当我们设置4个条带值，实际上我们只产生了3个条带。

### 格式图

如果我们需要在多个图形中使用相同的颜色，我们可以创建一个R对象来存储我们需要的颜色。我们也可以通过改变myCol对象更改调色板中的颜色来快速改变所有图形的颜色。

我们也可以使用xlab 和ylab为图像设置x和y轴标签。

```
# Assign color to a object for repeat use/ ease of changing
myCol = terrain.colors(3)

# Add axis labels
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = myCol,
     main="Digital Surface Model\nNEON Harvard Forest Field Site", 
     xlab = "UTM Westing Coordinate (m)", 
     ylab = "UTM Northing Coordinate (m)")
```
我们也可以关闭坐标轴。

```
# or we can turn off the axis altogether
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = myCol,
     main="Digital Surface Model\n NEON Harvard Forest Field Site", 
     axes=FALSE)
```

### 栅格图的分层

我们可以把栅格图放在同一片地区的山影图之上。用一个透明因子产生一个三维阴影的效果。山影图也是一个栅格数据，在查看地形的时候，你将看到的是阴影和纹理。

```
# import DSM hillshade
DSM_hill_HARV <- 
  raster("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")

# plot hillshade using a grayscale color ramp that looks like shadows.
plot(DSM_hill_HARV,
    col=grey(1:100/100),  # create a color ramp of grey colors
    legend=FALSE,
    main="Hillshade - DSM\n NEON Harvard Forest Field Site",
    axes=FALSE)
```

* 数据提示：可以使用legend=FALSE关闭或者隐藏图例。

我们也可以通过设置add=TRUE把另一个栅格数据放在山影图之上。这里我们把DSM_HARV放在hill_HARV之上。

```
# plot hillshade using a grayscale color ramp that looks like shadows.
plot(DSM_hill_HARV,
    col=grey(1:100/100),  #create a color ramp of grey colors
    legend=F,
    main="DSM with Hillshade \n NEON Harvard Forest Field Site",
    axes=FALSE)

# add the DSM on top of the hillshade
plot(DSM_HARV,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)
```

alpha值决定颜色的透明程度(0，透明，1不透明)。注意的是我们这里的调色板使用rainbow()

代替了terrain.color()。



