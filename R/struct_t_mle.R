#' ML Estimators for a Structured Correlation Matrix
#'
#' Computes the the correlation matrix and the degrees of freedom of a t-copula
#' using the Maximum-Likelihood (ML) estimator.
#'
#' @param x A \code{matrix} with multivariate i.i.d. variables.
#' @param k A single \code{double} with the number of relevant factors.
#' @param tolerance A single \code{double} used for convergence.
#'
#' @return A \code{list} with 2 components:
#'     \itemize{
#'       \item \code{Nu}: the degrees of freedom
#'       \item \code{C}: the correlation matrix
#'     }
#'
#' @export
#'
#' @examples
#' data("swap")
#'
#' # The first difference is stationary
#' swap_diff <- swap[2:nrow(swap), ] - swap[1:nrow(swap) - 1, ]
#'
#' # fit the model
#' struct_t_mle(x = swap_diff, k = 3)
struct_t_mle <- function(x, k, tolerance = 1e-10) {

  if (NCOL(x) == 1) {
    stop("`x` must be a multivariate data.", call. = FALSE)
  }
  if (!(is.numeric(tolerance) && length(tolerance) == 1)) {
    stop("`tolerance` is not a number (a length one numeric vector).", call. = FALSE)
  }
  if (!(is.numeric(k) && length(k) == 1)) {
    stop("`k` is not a number (a length one numeric vector).", call. = FALSE)
  }

  if (is.matrix(x)) {
    if (inherits(x, "ts") || inherits(x, "mts")) {
      nms <- colnames(x)
      x <- matrix(x, ncol = ncol(x))
      if (!is.null(nms)) colnames(x) <- nms
    }
  } else {
    stop("`x` must be a numeric matrix.", call. = FALSE)
  }

  Nus <- 1:50 # significant grid of potential degrees of freedom

  LL <- c() # log-likelihood
  sep_cop <- separate_copula_marginal(x) # extract copula
  W <- sep_cop$W
  F <- sep_cop$F
  U <- sep_cop$U

  for (s in seq_along(Nus)) {
    Nu <- Nus[s]
    Y  <- stats::qt(U, Nu)
    C  <- mle_recursion_for_t(Y, Nu, k, tolerance)
    LL <- c(LL, log_lik(Y, Nu, C))
  }

  Index <- which.max(LL)
  Nu <- Nus[Index]
  C  <- mle_recursion_for_t(Y, Nu, k, tolerance)

  # if X has names, add them back into the fitted object
  nms <- colnames(x)
  if (!is.null(nms)) {
    colnames(C) <- nms
    rownames(C) <- nms
  }

  list(Nu = Nu, C = C)

}
