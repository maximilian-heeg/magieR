.magieR_dependencies <- c(
  "magic-impute==3.0.0"
)


#' @import basilisk
magieR.env <- BasiliskEnvironment("env", "magieR",
                                packages=.magieR_dependencies, channels = c("bioconda", "conda-forge"))
