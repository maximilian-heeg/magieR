.magieR_dependencies <- c(
)


#' @import basilisk
magieR.env <- BasiliskEnvironment("env", "magieR",
                                packages=.magieR_dependencies, channels = c("bioconda", "conda-forge"),
                                pip=c("magic-impute==3.0.0"))
