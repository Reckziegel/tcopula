#' Log-Likelihood for t-distribution
#'
#' This function computes the Maximum Likelihood function for multivariate
#' t-distributed scenarios.
#'
#' @param x A numeric matrix.
#' @param Nu A numeric scalar.
#' @param Sigma A correlation matrix.
#'
#' @return A single scalar.
#'
#' @keywords internal
#'
#' @examples
#' #
LogLik <- function(x, Nu, Sigma) {

  InvS <- solve(Sigma)

  N <- ncol(x)

  Norm <- -(N / 2) * log(Nu * pi) + log(gamma((Nu + N) /  2)) - log(gamma(Nu / 2)) - 0.5 * log(det(Sigma))

  LL <- 0

  for (t in 1:nrow(x)) {
    Ma2 <- x[t, , drop = FALSE] %*% InvS %*% t(x[t, , drop = FALSE])
    LL  <- LL + Norm - (Nu + N) / 2 * log(1 + Ma2 / Nu)
  }

  LL

}
