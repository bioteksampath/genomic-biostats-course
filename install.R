# ------------------------------------------------------------------
# One-shot installer for the Genomic Biostatistics course
# Author: Sampath Perumal
# Usage:  source("setup/install.R")
# ------------------------------------------------------------------
if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")

pak::pak(c(
  ## Core & reporting
  "tidyverse", "here", "quarto", "renv", "janitor",
  ## Week 1 - linear & mixed models
  "sommer", "lme4", "lmerTest", "emmeans", "agridat", "mgcv",
  ## Week 2 - multivariate
  "FactoMineR", "factoextra", "mixOmics", "uwot", "mclust", "pheatmap",
  ## Week 3 - Bayesian
  "BGLR", "coda", "bayesplot",
  ## Week 4 - machine learning
  "tidymodels", "ranger", "xgboost", "glmnet", "kernlab", "vip",
  ## Week 5 - omics & integration
  "bioc::DESeq2", "bioc::limma", "bioc::edgeR", "bioc::sva",
  "WGCNA", "bioc::MOFA2",
  ## Week 6 - web applications
  "shiny", "bslib", "plotly", "DT",
  ## Week 7 - databases & APIs
  "DBI", "RSQLite", "dbplyr", "plumber", "httr2", "jsonlite",
  ## Week 8 - parallel & pipelines
  "future", "furrr", "targets"
))

message("\nAll course packages installed. Run the verification chunk on the Setup page.")
