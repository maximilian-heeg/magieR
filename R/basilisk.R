.magieR_dependencies <- c(
)


#' @import basilisk
magieR.env <- BasiliskEnvironment("env", "magieR",
                                packages=.magieR_dependencies, channels = c("bioconda", "conda-forge"),
                                pip=c("scipy==1.5.4", "magic-impute==2.0.4"))
