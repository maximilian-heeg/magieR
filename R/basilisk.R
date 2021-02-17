.magieR_dependencies <- c(
 "numpy==1.19.2",
 "pandas==1.2.0"
)


#' @import basilisk
magieR.env <- BasiliskEnvironment("env", "magieR",
                                packages=.magieR_dependencies, channels = c("bioconda", "conda-forge"),
                                pip=c("scipy==1.5.4", "magic-impute==2.0.4"))
