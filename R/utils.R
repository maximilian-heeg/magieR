######
# Parameter validation
######

check.int <- function(x) {
  as.integer(x)
}

check.int.or.null <- function(x) {
  if (is.numeric(x = x)) {
    x <- as.integer(x = x)
  } else if (!is.null(x = x) && is.na(x = x)) {
    x <- NULL
  }
  x
}

check.double.or.null <- function(x) {
  if (is.numeric(x = x)) {
    x <- as.integer(x = x)
  } else if (!is.null(x = x) && is.na(x = x)) {
    x <- NULL
  }
  x
}

check.int.or.string <- function(x, str) {
  if (is.numeric(x = x)) {
    x <- as.integer(x = x)
  } else if (is.null(x = x) || is.na(x = x)) {
    x <- str
  }
  x
}
