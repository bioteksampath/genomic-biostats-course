# Shared helper functions -- Genomic Biostatistics course (S. Perumal)

#' Coefficient of variation (%)
cv <- function(x) 100 * sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)

#' Predictive ability: cor(observed, predicted) by group
pred_ability <- function(obs, pred, group = NULL) {
  if (is.null(group)) return(cor(obs, pred, use = "complete.obs"))
  tapply(seq_along(obs), group, \(i) cor(obs[i], pred[i], use = "complete.obs"))
}

#' Cumulative genome position for Manhattan plots
add_cum_pos <- function(df, chr = "chr", pos = "pos") {
  df <- df[order(df[[chr]], df[[pos]]), ]
  offs <- c(0, cumsum(tapply(df[[pos]], df[[chr]], max)))
  df$cum_pos <- df[[pos]] + offs[as.integer(factor(df[[chr]]))]
  df
}
