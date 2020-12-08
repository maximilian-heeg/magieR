#' magieR
#' Run magic with R
#'
#' @param x A matrix with genes as columns and observations as rows.
#' Alternatively, a \linkS4class{SingleCellExperiment}  or a \linkS4class{Seurat} object.
#' For the SingleCellExperiment and Seurat methods, further arguments to pass to the ANY method.
#' @param assay An integer scalar or string specifying the assay of \code{x} containing the logcount matrix.
#' @param altExpName A string specifying the alternative Experiment where the resulting magic matrix is stored in.
#' See \link{SingleCellExperiment::altExps}
#' @param slot A string specifying the slot of \code{x} containing the logcount matrix.
#' @param assayName A string specifying the new Assay where the resulting magic matrix is stored in.
#' @param genes character or integer vector, default: NULL
#' vector of column names or column indices for which to return smoothed data
#' If 'all_genes' or NULL, the entire smoothed matrix is returned
#' @param knn int, optional, default: 5
#' number of nearest neighbors on which to compute bandwidth
#' @param knn.max int, optional, default: NULL
#' maximum number of neighbors for each point. If NULL, defaults to 3*knn
#' @param decay int, optional, default: 1
#' sets decay rate of kernel tails.
#' If NULL, alpha decaying kernel is not used
#' @param t int, optional, default: 3
#' power to which the diffusion operator is powered
#' sets the level of diffusion. If 'auto', t is selected according to the
#' Procrustes disparity of the diffused data.'
#' @param npca number of PCA components that should be used; default: 100.
#' @param solver str, optional, default: 'exact'
#' Which solver to use. "exact" uses the implementation described
#' in van Dijk et al. (2018). "approximate" uses a faster implementation
#' that performs imputation in the PCA space and then projects back to the
#' gene space. Note, the "approximate" solver may return negative values.
#' @param t.max int, optional, default: 20
#' Maximum value of t to test for automatic t selection.
#' @param knn.dist.method string, optional, default: 'euclidean'.
#' recommended values: 'euclidean', 'cosine'
#' Any metric from `scipy.spatial.distance` can be used
#' distance metric for building kNN graph.
#' @param verbose `int` or `boolean`, optional (default : 1)
#' If `TRUE` or `> 0`, print verbose updates.
#' @param n.jobs `int`, optional (default: 1)
#' The number of jobs to use for the computation.
#' If -1 all CPUs are used. If 1 is given, no parallel computing code is
#' used at all, which is useful for debugging.
#' For n_jobs below -1, (n.cpus + 1 + n.jobs) are used. Thus for
#' n_jobs = -2, all CPUs but one are used
#' @param seed int or `NULL`, random state (default: `NULL`)
#'
#'
#' @author Maximilian Heeg
#' @name magieR
NULL



#' @import basilisk
.magieR <- function(x,
                    genes = NULL,
                    knn = 5,
                    knn.max = NULL,
                    decay = 1,
                    t = 3,
                    npca = 100,
                    solver = 'exact',
                    t.max = 20,
                    knn.dist.method = 'euclidean',
                    verbose = 1,
                    n.jobs = 1,
                    seed = NULL,
                    ...) {

  # validate parameters
  knn <- check.int(knn)
  t.max <- check.int(t.max)
  n.jobs <- check.int(n.jobs)
  npca <- check.int.or.null(npca)
  knn.max <- check.int.or.null(knn.max)
  seed <- check.int.or.null(seed)
  verbose <- check.int.or.null(verbose)
  decay <- check.double.or.null(decay)
  t <- check.int.or.string(t, 'auto')
  if (!methods::is(object = x, "Matrix")) {
    x <- as.matrix(x)
  }
  if (is.null(genes) || is.na(genes)) {
    genes <- NULL
    gene_names <- colnames(x)
  } else if (is.numeric(genes)) {
    gene_names <- colnames(x)[genes]
    genes <- as.integer(genes - 1)
  } else if (length(genes) == 1 && genes == "all_genes") {
    gene_names <- colnames(x)
  } else if (length(genes) == 1 && genes == "pca_only") {
    gene_names <- paste0("PC", 1:npca)
  } else {
    # character vector
    if (!all(genes %in% colnames(x))) {
      warning(paste0("Genes ", genes[!(genes %in% colnames(x))], " not found.", collapse = ", "))
    }
    genes <- which(colnames(x) %in% genes)
    gene_names <- colnames(x)[genes]
    genes <- as.integer(genes - 1)
  }

  # run magic in basilisk environment
  result <- basiliskRun(env = magieR.env,
              fun = .run_magieR,
              x=x,
              genes=genes,
              knn = knn,
              knn.max = knn.max,
              decay = decay,
              t = t,
              t.max = t.max,
              npca = npca,
              solver = solver,
              knn.dist.method = knn.dist.method,
              verbose = verbose,
              n.jobs = n.jobs,
              seed = seed)

  colnames(result) <- gene_names
  rownames(result) <- rownames(x)

  return(result)
}

#' @importFrom reticulate import
.run_magieR <- function(x,
                        genes,
                        knn,
                        knn.max,
                        decay,
                        t,
                        t.max,
                        npca,
                        solver,
                        knn.dist.method,
                        verbose,
                        n.jobs,
                        seed) {
  magic <- import("magic")
  magic_operator <- magic$MAGIC(knn = knn,
                                knn_max = knn.max,
                                decay = decay,
                                t = t,
                                n_pca = npca,
                                solver = solver,
                                knn_dist = knn.dist.method,
                                n_jobs = n.jobs,
                                random_state = seed,
                                verbose = verbose

  )
  X_magic <- magic_operator$fit_transform(x,
                                          genes = genes,
                                          t_max = t.max)
  return(X_magic)
}

#' @export
#' @rdname magieR
setGeneric("magieR", function(x,
                              ...) standardGeneric("magieR"))


#' @export
#' @rdname magieR
setMethod("magieR", "ANY", .magieR)


#' @export
#' @rdname magieR
#' @import SingleCellExperiment
#' @import SummarizedExperiment
#' @importFrom Matrix t
setMethod("magieR", "SingleCellExperiment", function(x, assay = "logcounts", altExpName = "magic", ...){
  result <- .magieR(t(assay(x, assay)), ...)

  result <- SingleCellExperiment(assays = list(logcounts = t(result)))
  altExp(x, altExpName) <- result
  return(x)
})


#' @export
#' @rdname magieR
#' @importFrom Seurat GetAssayData CreateAssayObject Key
#' @importFrom Matrix t
setMethod("magieR", "Seurat", function(x, slot = "data", assayName = "magic", ...){
  result <- .magieR(t(GetAssayData(x, slot=slot)), ...)

  result <- CreateAssayObject(data = t(result))
  #Key(result) <- assayName
  x[[assayName]] <- result
  return(x)
})
