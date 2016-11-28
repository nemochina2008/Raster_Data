library(raster)
library(rgdal)

### 栅格对象还可以在读入R之前查看
GDALinfo("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

### 栅格中波段值的提取
### 单波段栅格对象的读取

DSM_HARV1 <- readGDAL("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

### 栅格对象查看
summary(DSM_HARV1)
slot(DSM_HARV1, "grid")
slot(DSM_HARV1, "bbox")
slot(DSM_HARV1, "proj4string")
dat.DSM1 = slot(DSM_HARV1, "data")
class(dat.DSM1)
head(dat.DSM1)

### 栅格对象可视化
image(DSM_HARV1,'band1', col = rev(terrain.colors(255)))

### 栅格对象中波段值的提取
### 结果矩阵与栅格对象一一对应，可以平铺到栅格上

### 方法一
dat.mat = t(as.matrix(DSM_HARV1))
write.csv(dat.mat,"dat.mat.csv")

dat.mat1 = t(matrix(dat.DSM1$band1, 1697))
write.csv(dat.mat1, 'dat.mat1.csv')

### 用image()函数可以验证结果矩阵与栅格对象一一对应
image(1:nrow(dat.mat1), 1:ncol(dat.mat1), dat.mat1, col = rev(terrain.colors(255))) ## 这里图形之所以与上面的不一样，是因为image()函数作图的方式并不是平铺到了水平面上的

### 方法二
library("raster")
DSM_HARV2 = raster("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
dat.mat2 = as.matrix(DSM_HARV2)
write.csv(dat.mat2,"dat.mat2.csv")

### 方法三
### 
dat.vector = as.vector(DSM_HARV2)
dat.xy = xyFromCell(DSM_HARV2,1:ncell(DSM_HARV2))
dat.mat3 = data.frame(dat.xy,dat.vector)
write.csv(dat.mat3, file = 'dat.mat3.csv')


### 栅格对象未读入R之前查看
GDALinfo("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

RGB_HARV1 <- readGDAL("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

### 栅格对象查看
summary(RGB_HARV1)
slot(RGB_HARV1, "grid")
slot(RGB_HARV1, "bbox")
slot(RGB_HARV1, "proj4string")
dat.RGB1 = slot(RGB_HARV1, "data")
class(dat.RGB1)
head(dat.RGB1)

rgb.dat.mat = t(as.matrix(RGB_HARV1))
write.csv(dat.mat,"dat.mat.csv")

