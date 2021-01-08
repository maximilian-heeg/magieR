.magieR_dependencies <- c(
  "cycler==0.10.0",
  "decorator==4.4.2",
  "Deprecated==1.2.10",
  "future==0.18.2",
  "graphtools==1.5.2",
  "joblib==0.17.0",
  "kiwisolver==1.3.1",
  #"magic-impute==2.0.4", # does not exist in conda channels, install from pip
  "matplotlib==3.3.3",
  "numpy==1.19.4",
  "pandas==1.1.4",
  "Pillow==8.0.1",
  "PyGSP==0.5.1",
  "pyparsing==2.4.7",
  "python-dateutil==2.8.1",
  "pytz==2020.4",
  "scikit-learn==0.23.2",
  #"scipy==1.5.4", # does not exist in conda channels, install from pip
  "scprep==1.0.10",
  "six==1.15.0",
  "tasklogger==1.0.0",
  "threadpoolctl==2.1.0",
  "wrapt==1.12.1"
)


#' @import basilisk
magieR.env <- BasiliskEnvironment("env", "magieR",
                                packages=.magieR_dependencies, channels = c("bioconda", "conda-forge"),
                                pip=c("scipy==1.5.4", "magic-impute==2.0.4"))
