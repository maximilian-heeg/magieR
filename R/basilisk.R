.magieR_dependencies <- c(
  "cycler",
  "decorator",
  "Deprecated",
  "future",
  "graphtools",
  "joblib",
  "kiwisolver",
  #"magic-impute==2.0.4", # does not exist in conda channels, install from pip
  "matplotlib",
  "numpy",
  "pandas",
  "Pillow",
  "PyGSP",
  "pyparsing",
  "python-dateutil",
  "pytz",
  "scikit-learn",
  #"scipy==1.5.4", # does not exist in conda channels, install from pip
  "scprep",
  "six",
  "tasklogger",
  "threadpoolctl",
  "wrapt"
)


#' @import basilisk
magieR.env <- BasiliskEnvironment("env", "magieR",
                                packages=.magieR_dependencies, channels = c("bioconda", "conda-forge"),
                                pip=c("scipy", "magic-impute"))
