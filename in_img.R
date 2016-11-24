x = 28
y = 28

library(EBImage)
img = readImage("pallet.jpg")
re.img = resize(img,x,y)
rev.img = 1 - re.img
display(rev.img)
in.img = data.matrix(rev.img)
dim(in.img) = c(x,y,1,1)
new.preds = predict(model,in.img , ctx=mx.cpu())
cat(max.col(t(new.preds)) - 1)