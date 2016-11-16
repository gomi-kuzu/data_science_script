#Rのパッケージ EBImageのインスコ時メモ 
2016/11/15  
ubuntu14.04  
R 3.3.1  

端末から依存パッケージをインスコ  
`sudo apt-get install imagemagick libmagickcore-dev libmagickwand-dev libgtk2.0-dev gtk2-engines-pixbuf`  
`sudo apt-get install fftw3-dev`  

sudoでR起動  
`sudo R`  

Rコンソールで  
> install.packages("abind")  
> install.packages("tiff")  
> install.packages("jpeg")  
> install.packages("png")  

とした後  
> source("http://bioconductor.org/biocLite.R")  
> biocLite("EBImage")  

途中で他のパッケをアップデートしますかと聞かれるのではいはいと答える  

ここで、足りないパッケージがあるよーとエラー吐かれて失敗する場合は  
適宜追加してやる（install.packages()やapt-getで）  

多分これで入る  