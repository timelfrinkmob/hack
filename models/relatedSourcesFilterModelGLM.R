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
# Load data
load("models/datasetFinal.csv")

datasetFinal$label <- as.factor(datasetFinal$label)

# First 50 rows are real examples. The remaining rows are fake examples
datasetFinal.h2o <- as.h2o(datasetFinal[,c(5:9)])
View(datasetFinal[,c(5:9)])
filteringModelGLM <- h2o.glm(x = c(3:5), 
                             y = c(1), 
                             training_frame = datasetFinal.h2o,
                             family = "binomial", 
                             nfolds = 2, 
                             alpha = 0.5, 
                             lambda_search = TRUE)

filteringModelGBM <- h2o.gbm(x = c(3:5), 
                              y = c(1), 
                              training_frame = datasetFinal.h2o,
                              model_id = "initial_model_ordering",
                              nfolds = 5,
                              #keep_cross_validation_predictions = FALSE,
                              #keep_cross_validation_fold_assignment = FALSE,
                              score_each_iteration = TRUE, 
                              #score_tree_interval = 0,
                              #fold_assignment = c("AUTO"), #, "Random", "Modulo", "Stratified"),
                              fold_column = NULL, 
                              ignore_const_cols = TRUE, 
                              offset_column = NULL,
                              #weights_column = "weight", 
                              balance_classes = FALSE,
                              class_sampling_factors = NULL, 
                              #max_after_balance_size = 5,
                              max_hit_ratio_k = 0, 
                              ntrees = 50, 
                              max_depth = 2, 
                              #min_rows = 10,
                              #nbins = 20, 
                              #nbins_top_level = 1024, 
                              #nbins_cats = 1024,
                              #r2_stopping = Inf, 
                              stopping_rounds = 0, 
                              stopping_metric = c("MSE"), #c("AUTO","deviance", "logloss", "MSE", "RMSE", "MAE", "RMSLE", "AUC", "lift_top_group", "misclassification", "mean_per_class_error"), 
                              stopping_tolerance = 0.0001,
                              max_runtime_secs = 0, 
                              seed = -1453534, 
                              build_tree_one_node = FALSE,
                              learn_rate = 0.005, 
                              #learn_rate_annealing = 1, 
                              distribution = c("AUTO"), #c("AUTO", "bernoulli", "multinomial", "gaussian", "poisson", "gamma", "tweedie", "laplace", "quantile", "huber"), 
                              #quantile_alpha = 0.5,
                              #tweedie_power = 1.5, 
                              #huber_alpha = 0.9, 
                              checkpoint = NULL,
                              sample_rate = 0.95, 
                              sample_rate_per_class = NULL, 
                              col_sample_rate = 0.95,
                              col_sample_rate_change_per_level = 0.95, 
                              col_sample_rate_per_tree = 0.95,
                              #min_split_improvement = 1e-05, 
                              #histogram_type = c("AUTO", "UniformAdaptive", "Random", "QuantilesGlobal", "RoundRobin"),
                              #max_abs_leafnode_pred = Inf, 
                              #pred_noise_bandwidth = 0,
                              #categorical_encoding = c("OneHotInternal"))
                              #c("AUTO", "Enum", "OneHotInternal", "OneHotExplicit","Binary", "Eigen"))
                              )
# Paramters: https://www.rdocumentation.org/packages/h2o/versions/3.8.1.3/topics/h2o.glm