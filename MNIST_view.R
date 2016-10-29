## MNISTデータの画像表示

#画像読み込んで表示
view_train <- function(train, range = 1:25) {
  par(mfrow=c(length(range)/5, 5))
  par(mar=c(0,0,0,0))
  for (i in range) {
    m <- matrix(data.matrix(train[i,-1]), 28, 28)
    image(m[,28:1],col = gray((0:255)/255))
  }
}

# ラベルをコンソールに出力
view_label <- function(train, range = 1:20) {
  matrix(train[range,"label"], 5, 5, byrow = TRUE)
}

range <- 1:5000
sam <- sample(range , 25)
view_train(train, sam)
view_label(train, sam)
