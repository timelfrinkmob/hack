# Fake new detector

# Make sure H2O is installed on your machine. See h2o.ai
# Make sure the h2o R package is installed on your machine.

library(readr)
library(h2o)

# Initialize the H2O package for R.
localH2O = h2o.init(nthreads=-1)

# Load data
load("models/allArticles.RData")

allArticles$author <- as.factor(allArticles$author)
allArticles$language <- as.factor(allArticles$language)
allArticles$country <- as.factor(allArticles$country)
allArticles$label <- as.factor(allArticles$label)

# First 50 rows are real examples. The remaining rows are fake examples
allArticles.train.h2o <- as.h2o(allArticles[c(1:40,51:90),c(1,5,7,8,10:28)])
allArticles.test.h2o  <- as.h2o(allArticles[c(41:50,91:100),c(1,5,7,8,10:28)])

# GBM model
fakeNewsClassifier <- h2o.gbm(x = c(1:4,6:23), 
                    y = 5, 
                    training_frame = allArticles.train.h2o,
                    validation_frame = allArticles.test.h2o,
                    model_id = "initial_model_fake_news_classifier",
                    #nfolds = 5,
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
                    max_after_balance_size = 5,
                    max_hit_ratio_k = 0, 
                    ntrees = 50, 
                    max_depth = 4, 
                    min_rows = 10,
                    nbins = 20, 
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

# Achieved an auc of 1 on training and AUC of 0.96 on test. However, model is overfitting on the feature  numerCapital letters.

# Retrain while excluding this feature
fakeNewsClassifier2 <- h2o.gbm(x = c(1:4,6:9,11:23), 
                              y = 5, 
                              training_frame = allArticles.train.h2o,
                              validation_frame = allArticles.test.h2o,
                              model_id = "initial_model_fake_news_classifier",
                              #nfolds = 5,
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
                              max_after_balance_size = 5,
                              max_hit_ratio_k = 0, 
                              ntrees = 50, 
                              max_depth = 4, 
                              min_rows = 10,
                              nbins = 20, 
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

# AUC of 1 on train and 0.93 on validation. Domain_rank is really important, maybe mode is overfitting this way.
# Retrain while excluding this feature
fakeNewsClassifier3 <- h2o.gbm(x = c(1:3,6:9,11:23), 
                               y = 5, 
                               training_frame = allArticles.train.h2o,
                               validation_frame = allArticles.test.h2o,
                               model_id = "initial_model_fake_news_classifier",
                               #nfolds = 5,
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
                               max_after_balance_size = 5,
                               max_hit_ratio_k = 0, 
                               ntrees = 50, 
                               max_depth = 4, 
                               min_rows = 10,
                               nbins = 20, 
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

# AUC of 1 on train and 0.92 on validation. Author is now really important, maybe mode is overfitting this way.
# Retrain while excluding this feature

fakeNewsClassifier4 <- h2o.gbm(x = c(2:3,6:9,11:23), 
                               y = 5, 
                               training_frame = allArticles.train.h2o,
                               validation_frame = allArticles.test.h2o,
                               model_id = "initial_model_fake_news_classifier",
                               #nfolds = 5,
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
                               max_after_balance_size = 5,
                               max_hit_ratio_k = 0, 
                               ntrees = 50, 
                               max_depth = 4, 
                               min_rows = 10,
                               nbins = 20, 
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
# Results look pretty good now: AUC of 0.989 on train and 0.88 on validation set. Descriptive features of title along with sentiment feature are very predictive.
# Only thing here is the low number of rows/instances

#variable	relative_importance	scaled_importance	percentage
#numberWordsCapital	444.2660	1.0	0.7452
#country	72.6488	0.1635	0.1219
#numberCharsTitle	31.4694	0.0708	0.0528
#total_positive	19.8541	0.0447	0.0333
#averageLengthWords	13.2977	0.0299	0.0223
#trust	8.6793	0.0195	0.0146
#total_negative	4.9557	0.0112	0.0083
#negative	0.7937	0.0018	0.0013
#anger	0.1609	0.0004	0.0003
#sadness	0.0620	0.0001	0.0001
#fear	0.0006	0.0	0.0
#total	0.0003	0.0	0.0
#numberWordsTitle	0.0001	0.0	0.0
#anticipation	0	0	0
#positive	0	0	0
#surprise	0	0	0
#joy	0	0	0
#disgust	0	0	0
