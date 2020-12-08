## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 8,
  fig.height = 6
)

## ----setup--------------------------------------------------------------------
library(magieR)

## -----------------------------------------------------------------------------
m <- utils::read.csv(system.file("extdata", "test_data.csv", package = "magieR"))
m[1:10, 1:5]

## -----------------------------------------------------------------------------
result <- magieR(m)
# as.data.frame makes the output look a little nicer
as.data.frame(result)[1:10, 1:5]

## -----------------------------------------------------------------------------
suppressPackageStartupMessages({
  library(scRNAseq)  
  library(scater)
  library(SingleCellExperiment)
})

example_sce <- ZeiselBrainData()

example_sce <- addPerCellQC(example_sce, 
    subsets=list(Mito=grep("mt-", rownames(example_sce))))

plotColData(example_sce, x = "sum", y="detected", colour_by="tissue") 

example_sce <- logNormCounts(example_sce) 

vars <- getVarianceExplained(example_sce, 
    variables=c("tissue", "total mRNA mol", "sex", "age"))
head(vars)

example_sce <- runPCA(example_sce)

set.seed(1000)
example_sce <- runTSNE(example_sce, perplexity=50, 
    dimred="PCA", n_dimred=10)
example_sce

## -----------------------------------------------------------------------------
# run magieR
example_sce <- magieR(example_sce)
example_sce

# the magic data can be accessed with
altExp(example_sce, "magic")

## -----------------------------------------------------------------------------
plotExpression(example_sce, rownames(vars)[1:5]) + 
  ggplot2::ggtitle("Without magic")

plotExpression(altExp(example_sce, "magic"), rownames(vars)[1:5]) + 
  ggplot2::ggtitle("With magic")

## -----------------------------------------------------------------------------
plotTSNE(example_sce, colour_by="Tspan12") + 
  ggplot2::ggtitle("Without magic")

# not sure if there is a more elegant way
# copy reduced dim to alt exp
reducedDim(altExp(example_sce, "magic"), "TSNE") <- reducedDim(example_sce, "TSNE")
plotTSNE(altExp(example_sce, "magic"), colour_by="Tspan12") + 
  ggplot2::ggtitle("With magic")

## ----include=FALSE------------------------------------------------------------
## remove all variables
rm(list=ls())

## -----------------------------------------------------------------------------
suppressPackageStartupMessages({
  library(BiocFileCache)
  library(Seurat)
})

url = "https://cf.10xgenomics.com/samples/cell/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz"

bfc <- BiocFileCache()
data <- bfcrpath(bfc, url)

tempdir <- file.path(tempdir(), "10_pbmc")
untar(data, exdir = tempdir)

pbmc.data <- Read10X(data.dir = file.path(tempdir, "filtered_gene_bc_matrices/hg19/"))

pbmc <- CreateSeuratObject(counts = pbmc.data, project = "pbmc3k", min.cells = 3, min.features = 200)

pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")
pbmc <- subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)

pbmc <- NormalizeData(pbmc)

pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)

top10 <- head(VariableFeatures(pbmc), 10)

all.genes <- rownames(pbmc)
pbmc <- ScaleData(pbmc, features = all.genes)

pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc))
pbmc <- RunUMAP(pbmc, dims = 1:10)

pbmc

## -----------------------------------------------------------------------------

pbmc <- magieR(pbmc, slot="data")
pbmc

## -----------------------------------------------------------------------------
VlnPlot(pbmc,
        features = c("CD8A", "STAT3"),
        same.y.lims = FALSE)

VlnPlot(pbmc,
        features = c("CD8A", "STAT3"),
        same.y.lims = FALSE,
        assay="magic")

## -----------------------------------------------------------------------------
FeaturePlot(pbmc, features = c("CD8A", "STAT3"))


# set the default assay to magic
Seurat::DefaultAssay(pbmc) <- "magic"
FeaturePlot(pbmc, features = c("CD8A", "STAT3"))
# set if back to default ("RNA"). You only want to use magic for visualization
# and never for statistics.
Seurat::DefaultAssay(pbmc) <- "RNA"

