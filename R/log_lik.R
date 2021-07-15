#' Log-Likelihood for t-distribution
#'
#' Computes the Maximum Likelihood function for multivariate
#' t-distributed scenarios.
#'
#' @param x A numeric matrix.
#' @param nu A numeric scalar.
#' @param sigma A dispersion matrix.
#'
#' @return A \code{double} with the estimated likelihood.
#'
#' @keywords internal
log_lik <- function(x, nu, sigma) {

  InvS <- solve(sigma)

  N <- ncol(x)

  Norm <- -(N / 2) * log(nu * pi) + log(gamma((nu + N) /  2)) - log(gamma(nu / 2)) - 0.5 * log(det(sigma))

  LL <- 0

  for (t in 1:nrow(x)) {
    Ma2 <- x[t, , drop = FALSE] %*% InvS %*% t(x[t, , drop = FALSE])
    LL  <- LL + Norm - (nu + N) / 2 * log(1 + Ma2 / nu)
  }

  LL

}
