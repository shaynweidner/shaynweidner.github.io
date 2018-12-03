Final Product Pitch
========================================================
author: Shayn Weidner
date: 12/2/18
autosize: true


This project was created to satisfy the final project requirements of the Developing Data Products course, part of the Data Science Specialization by JHU on Coursera.


App Purpose
========================================================

There are many times when it is useful to simulate data, and often we would like columns of that data to be correlated.  This app will generate bivariate normal variables with the desired correlations.  This can be done using the mvrnorm() function from the MASS library, but the app facilitates doing so without editing code (and without needing to perform other nuisance tasks, such as converting correlations to covariances, which the mvrnorm function is expecting).  The app then goes further by allowing you to interactively view the generated bivariate normal data's density.  In the future (read: not implemented yet) we could allow the user to export the data, to csv (for instance).  The next slides show how one would manually create and plot the data, while the last slide gives the links to the app (and the github page for the project) and describes how to use it.

Multivariate Normal, via code
========================================================


```r
library(MASS)
MyData <- as.data.frame(mvrnorm(n=1000 #sample size
                 ,mu=c(2,3) #means
                 ,Sigma = matrix(c(1,0,0,1) #cov matrix
                                 ,nrow=2)
                 ))
names(MyData)<-c("Norm1","Norm2")
head(MyData)
```

```
      Norm1    Norm2
1 0.9109714 1.727377
2 1.0767368 3.088125
3 1.9349250 1.601887
4 1.6127173 1.654543
5 3.0207072 2.214232
6 1.6987697 2.301118
```

Slide With Plot
========================================================


```r
library(dplyr)
library(plotly)
kd <- with(MyData, MASS::kde2d(Norm1, Norm2, n = round(5*log(nrow(MyData)))))
p <- plot_ly(x = kd$x, y = kd$y, z = kd$z) %>% add_surface() %>% layout(autosize = F, width = 300, height = 300)
htmlwidgets::saveWidget(as.widget(p), file = "plot.html") # necessary to get functionality in presentation
```
<iframe src="plot.html" style="position:absolute;height:100%;width:100%"></iframe>

Links
========================================================

Below are the links to the App and the github repo for the entire project (including this presentation).  The app includes basic instructions but there really aren't any non-basic instructions.  The app is defaulted to certain parameters, and you change them as necessary to generate data from your desired bivariate normal distribution.  That is, you update how big of a sample you'd like, what the means and variances of the normal distributions to be, and what you want the correlation between the two normal distributions to be (and set a seed).  And that's it. 

* [App](https://shaynweidner.shinyapps.io/dataproductsfinalproject/)

* [Github](https://github.com/shaynweidner/DataScienceProductsFinal)
