##MXnetのおためしコード
##[参考page]http://tjo.hatenablog.com/entry/2016/03/29/180000

##MNISTデータの準備
train<-read.csv('https://github.com/ozt-ca/tjo.hatenablog.samples/raw/master/r_samples/public_lib/jp/mnist_reproduced/short_prac_train.csv') #ミニMNISTよんでくる
test<-read.csv('https://github.com/ozt-ca/tjo.hatenablog.samples/raw/master/r_samples/public_lib/jp/mnist_reproduced/short_prac_test.csv')
train<-data.matrix(train) #行列化
test<-data.matrix(test)  #行列化

train.y<-train[,1]　　#1列目だけ取り出して訓練教師データラベルを生成
train.x<-train[,-1]  #1列目（ラベル）を除いて訓練入力データを生成
train.x<-t(train.x/255)　　#Scaling
test_org<-test[,1]	#評価するとき用
test<-test[,-1]		#1列目（ラベル）を除いてテスト入力データを生成
test<-t(test/255)	#Scaling


##CNN

library(mxnet)

#入力層
data <- mx.symbol.Variable('data')

# 畳み込み層１＋プーリング層１
conv1 <- mx.symbol.Convolution(data=data, kernel=c(5,5), num_filter=20)  #入力層から連結,カーネルフィルタサイズ, フィルタ数  (ストライドはデフォルトの(1,1),パディングは行わない)
h_act1 <- mx.symbol.Activation(data=conv1, act_type="relu")   #畳み込み層出力に活性化関数適用,種類の指定(ReLU)
pool1 <- mx.symbol.Pooling(data=h_act1, pool_type="max",kernel=c(2,2), stride=c(2,2))   #活性化後の畳み込み層から連結,タイプの指定（MAX）,カーネルサイズ,ストライド

# 畳み込み層２＋プーリング層２
conv2 <- mx.symbol.Convolution(data=pool1, kernel=c(5,5), num_filter=50)
h_act2 <- mx.symbol.Activation(data=conv2, act_type="relu")
pool2 <- mx.symbol.Pooling(data=h_act2, pool_type="max",kernel=c(2,2), stride=c(2,2))

#　全結合層
flatten <- mx.symbol.Flatten(data=pool2)   #プーリング2層から連結（ベクトル化を行う）
fc1 <- mx.symbol.FullyConnected(data=flatten, num_hidden=500)   #ベクトル化層から連結,中間層次元を指定
h_act3 <- mx.symbol.Activation(data=fc1, act_type="relu")   #全結合層から連結, 種類指定(ReLU)
drop3 <- mx.symbol.Dropout(data=h_act3,p=0.5)   #活性化後の全結合層から連結, ドロップアウトレートを指定

# 出力層
out <- mx.symbol.FullyConnected(data=drop3, num_hidden=10)
lenet <- mx.symbol.SoftmaxOutput(data=out)   #出力層活性化関数をソフトマックス関数に

#convへの入力データ準備
train.array <- train.x
dim(train.array) <- c(28, 28, 1, ncol(train.x))　#conv層への入力はテンソル形式で行う. 各次元は (縦pix ,横pix ,カラーチャンネル ,データ数 )に対応
test.array <- test
dim(test.array) <- c(28, 28, 1, ncol(test))

#学習
mx.set.seed(0)  #初期重み固定？
tic <- proc.time()  #計算時間測る用
model <- mx.model.FeedForward.create(lenet, X=train.array, y=train.y, ctx=mx.cpu(), num.round=30, optimizer = "adam", learning.rate=0.001, wd=0.00001, eval.metric=mx.metric.accuracy, epoch.end.callback=mx.callback.log.train.metric(100), array.batch.size=100)
#入力から出力までをつないだネットワークをセット, 訓練入力データ, 訓練教師データ ,プロセッサ(CPU or GPU), エポック数, 最適化手法, 最適化のパラメータ, 重み減衰係数 , 正解率を計算するかどうか? , 各エポックが終了した時にログをとるようにしてる? , ミニバッチサイズ

#評価
print(proc.time() - tic)  #学習時間
preds <- predict(model, test.array, ctx=mx.cpu())  #(テストデータ推定)　さっき学習させたモデルをセット,テストデータを入力,CPUで計算　（結果は確率で得られる）
pred.label <- max.col(t(preds)) - 1　#確率が一番高いラベルを取り出す
table(test_org,pred.label)　#推定結果表示
sum(diag(table(test_org,pred.label)))/length(test_org)　#全体正解率

#学習済みモデルの保存
mx.model.save(model, "CNNmodel", 30) #モデルの指定,保存名,何エポック目かのメモ（保存名に記される）
#CNNM = mx.model.load("CNNmodel",30) #これやればモデルがロードできる
