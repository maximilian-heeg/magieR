<img src="man/figures/logo.png" align="right" alt="logo.png" width="180" />

# magieR

An easy to use wrapper to run `magic` in scRNA-Seq datasets in R. For further information on `magic` see https://www.krishnaswamylab.org/projects/magic


## Installation

_magieR_ can be easily installed from [Github](https://github.com/maximilian-heeg/magieR) using `devtools::install()`:

```r
if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")
devtools::install_github("maximilian-heeg/magieR")

```

*Note*: Most recently, I needed to install the newest version of `reticulate` from git. Otherwise I got a lot of segfaults. Also, make sure that the libopenblas from R and in the python environment match.

See the vignette on how to use the wrapper with `Seurat` and `SingleCellExperiment` objects.
