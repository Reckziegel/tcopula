#' Computes ML Estimator of the Correlation Matrix
#'
#' This function recursively computes the ML estimators of the correlation matrix
#' of a t-copula with isotropic structure.
#'
#' @param x A numeric matrix.
#' @param Nu A numeric scalar.
#' @param K A numeric scalar.
#' @param Tolerance A numeric scalar.
#'
#' @return A correlation matrix.
#'
#' @keywords internal
#'
#' @examples
#' #
MleRecursionForT <- function(x, Nu, K, Tolerance = 10^(-10)) {

  T      <- nrow(x)         # panel dimension
  N      <- ncol(x)         # panel dimension
  Ones_N <- matrix(1, 1, N) # fixed for fast matrix operation
  Ones_T <- matrix(1, T, 1) # fixed for fast matrix operation

  # initialize variables
  w <- matrix(1, T, 1)
  C <- 0 * t(Ones_N) %*% Ones_N
  Error <- 10 ^ 6

  # start main loop
  while (Error > Tolerance) {

    # Step 0: Initialize C
    C_Old <- C

    # Step 1: Compute the weights
    W  <- w %*% Ones_N

    # Step 2: Compute the scatter matrix
    S_ <- t(W * x) %*% x / T

    # Step 2b: Perform the principal component
    eigen_ <- eigen(S_)
    E      <- eigen_$vectors
    L_     <- eigen_$values

    # Step 2c: Redefine the eigenvalues
    L      <- mean(L_[(K + 1):N]) * Ones_N
    L[1:K] <- L_[1:K]

    # Step 2d: Recompose the scatter matrix
    S      <- E %*% diag(as.vector(L)) %*% t(E)

    # Step 3: Extract the Correlation
    C      <- stats::cov2cor(S)

    # Step 4: Check convergence
    Ma2   <- rowSums((x %*% solve(C)) * x)
    w     <- (Nu + N) / (Nu + Ma2)
    Error <- sum(diag((C - C_Old) ^ 2)) / N

  }

  C

}
