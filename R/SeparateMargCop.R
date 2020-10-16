#' Separates the Copula from the Marginal Distribution
#'
#' This function decomposes the the pure "joint" from the pure "marginal"
#' features of a multivariate distribution.
#'
#' @param X A numeric \code{matrix}.
#'
#' @return A \code{list} with 3 components:
#'
#' @keywords internal
#'
#' @examples
#' #
SeparateMargCop <- function(X) {

  J <- nrow(X)
  K <- ncol(X)

  F <- 0 * X
  U <- 0 * X

  W <- 0 * X
  C <- 0 * X

  # MATLAB does this operation in one shot. In R, we have to loop over...
  for (k in 1:K) {
    tmp  <- sort(X[ , k, drop = FALSE], index.return = TRUE)
    W[ , k] <- tmp$x
    C[ , k] <- tmp$ix
  }

  # for each marginal...
  for (k in 1:K) {

    x  <- C[ , k]
    y  <- 1:J
    xi <- 1:J
    yi <- stats::approx(x = x, y = y, xout = xi, method = "linear")$y
    U[ , k] <- yi / (J + 1)
    F[ , k] <- 1:J / (J + 1)

  }

  list(W = W, F = F, U = U)

}
