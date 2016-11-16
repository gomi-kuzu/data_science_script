x = 28
y = 28

library(EBImage)
img = readImage("pallet.jpg")
re_img = resize(img,x,y)
WD_img = 1 - re_img
in_img = data.matrix(WD_img)

dim(in_img) = c(x,y,1,1)
