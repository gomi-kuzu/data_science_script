#R版MXNETインストール時のメモ
2016/10/18
### Linuxの場合R版MXnetライブラリをインストールするのに少し手間がかかるので書いておく
※ちなみに、Windows or Mac なら以下のようにすれば入るらしい  
　Rのコンソールで
> install.packages("drat", repos="https://cran.rstudio.com")  
> drat:::addRepo("dmlc")  
> install.packages("mxnet")

簡単…
##### My環境
ubuntu 14.04
R 3.3.1 
#### STATE
1. ターミナル上でgithubから引っぱってきてmake  
`sudo apt-get install build-essential libatlas-base-dev libopencv-dev`  
`git clone --recursive https://github.com/dmlc/mxnet`  
`cd mxnet`  
`make`

2. Rコンソールでpakインスコとかよくわからん操作

 入ってないなら下のパッケージ入れる
> install.packages("devtools")  
> install.packages("methods")  
> install.packages("httr")

###※ここでなんかよくわからんエラー発生
`ERROR: configuration failed for package ‘curl’`〜〜（省略）

ネットで調べてターミナルから  
`sudo apt-get install curl`  
`sudo apt-get install libcurl4-gnutls-dev`  
とやったらなおった（下だけでよかった可能性アリ）

　で読み込み
>require(devtools)  
>require(methods)  
>require(httr)

　and

>setwd("mxnet/R-package/")
>
>options(repos=c(CRAN='https://cran.rstudio.com'));  
>install_deps(dependencies = TRUE)

　※プロキシ使っているならoptions~の前に
>set_config(use_proxy(url="任意のアドレス",port=8080))

　がいるらしい（やってない）

3.　しあげ  
ここまで終わったらターミナルで
`cd mxnet`  
`make rpkg`  
`R CMD INSTALL mxnet_0.7.tar.gz`

作業終了

4.　確認
Rコンソールで
>require(mxnet)

とやってエラーが出なければ恐らく成功

##以上

参考サイト  
http://kato-kohaku-0.hatenablog.com/entry/2016/08/23/224131  
http://blog.aicry.com/r-devtools-and-rcurl/  
http://qiita.com/lukapla/items/e164a77c7bdb2460225d
