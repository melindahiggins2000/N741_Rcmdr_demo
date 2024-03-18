
data()
# Table for bill_depth_mm:
Tapply(bill_depth_mm ~ species, mean, na.action=na.omit, data=penguins) 
  # mean by groups
# Table for bill_length_mm:
Tapply(bill_length_mm ~ species, mean, na.action=na.omit, data=penguins) 
  # mean by groups
# Table for body_mass_g:
Tapply(body_mass_g ~ species, mean, na.action=na.omit, data=penguins) 
  # mean by groups
# Table for flipper_length_mm:
Tapply(flipper_length_mm ~ species, mean, na.action=na.omit, data=penguins) 
  # mean by groups
library(abind, pos=18)
local({
  .Table <- xtabs(~species+island, data=penguins)
  cat("\nFrequency table:\n")
  print(.Table)
  .Test <- chisq.test(.Table, correct=FALSE)
  print(.Test)
})
HClust.1 <- hclust(dist(model.matrix(~-1 + 
  bill_depth_mm+bill_length_mm+body_mass_g+flipper_length_mm, penguins)) , 
  method= "ward")
plot(HClust.1, main= "Cluster Dendrogram for Solution HClust.1", xlab= 
  "Observation Number in Data Set penguins", 
  sub="Method=ward; Distance=euclidian")
summary(as.factor(cutree(HClust.1, k = 3))) # Cluster Sizes
by(model.matrix(~-1 + bill_depth_mm + bill_length_mm + body_mass_g + 
  flipper_length_mm, penguins), as.factor(cutree(HClust.1, k = 3)), colMeans) 
  # Cluster Centroids
biplot(princomp(model.matrix(~-1 + bill_depth_mm + bill_length_mm + 
  body_mass_g + flipper_length_mm, penguins)), xlabs = 
  as.character(cutree(HClust.1, k = 3)))
penguins$hclus.label <- assignCluster(model.matrix(~-1 + bill_depth_mm + 
  bill_length_mm + body_mass_g + flipper_length_mm, penguins), penguins, 
  cutree(HClust.1, k = 3))
local({
  .Table <- xtabs(~species+hclus.label, data=penguins)
  cat("\nFrequency table:\n")
  print(.Table)
  .Test <- chisq.test(.Table, correct=FALSE)
  print(.Test)
})
local({
  .PC <- 
  princomp(~bill_depth_mm+bill_length_mm+body_mass_g+flipper_length_mm, 
  cor=TRUE, data=penguins)
  cat("\nComponent loadings:\n")
  print(unclass(loadings(.PC)))
  cat("\nComponent variances:\n")
  print(.PC$sd^2)
  cat("\n")
  print(summary(.PC))
  screeplot(.PC)
  penguins <<- within(penguins, {
    PC2 <- .PC$scores[,2]
    PC1 <- .PC$scores[,1]
  })
})
scatterplot(PC2~PC1 | species, regLine=FALSE, smooth=FALSE, boxplots=FALSE, 
  by.groups=TRUE, data=penguins)

