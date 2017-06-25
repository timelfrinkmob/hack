# Related sources estimator

# Make sure H2O is installed on your machine. See h2o.ai
# Make sure the h2o R package is installed on your machine.

library(readr)
library(h2o)

# Initialize the H2O package for R.
localH2O = h2o.init(nthreads=-1)


# Use a different dataset here, namely the daset that results from features created based on the sources.
# Label sources manually
# Train GLM or GBM model 
# Features: similarity score with original article, sentiment features, descriptive features (# of words etc.. see preprocessingFeatureEngineering.R )

# This is just an example of how such a model should be run

# Load data
load("models/allArticles.RData")

allArticles$author <- as.factor(allArticles$author)
allArticles$language <- as.factor(allArticles$language)
allArticles$country <- as.factor(allArticles$country)
allArticles$label <- as.factor(allArticles$label)

# First 50 rows are real examples. The remaining rows are fake examples
allArticles.train.h2o <- as.h2o(allArticles[c(1:40,51:90),c(1,5,7,8,10:28)])
allArticles.test.h2o  <- as.h2o(allArticles[c(41:50,91:100),c(1,5,7,8,10:28)])


model <- h2o.glm(y = c(5), 
                 x = c(2:3,6:9,11:23), 
                 training_frame = allArticles.train.h2o,
                 validation_frame = allArticles.test.h2o,
                 family = "binomial", 
                 #nfolds = 0, 
                 alpha = 0.5, 
                 lambda_search = TRUE)

# Paramters: https://www.rdocumentation.org/packages/h2o/versions/3.8.1.3/topics/h2o.glm

