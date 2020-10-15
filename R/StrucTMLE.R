#' ML Estimators for a Structured Correlation Matrix
#'
#' This function recursively computes the ML estimators of the correlation matrix
#' and the degrees of freedom of a t-copula with isotropic structure.
#'
#' @param X A numeric matrix.
#' @param K A numeric scalar.
#' @param Tolerance A numeric scalar.
#'
#' @return A \code{list} with 2 components: Nu (the degrees of freedom) and C (the
#' correlation matrix).
#'
#' @export
#'
#' @references
#'
#' Meucci, Attilio, Estimation of Structured T-Copulas (April 2008). Available
#' at SSRN: \url{https://ssrn.com/abstract=1126401} or \url{http://dx.doi.org/10.2139/ssrn.1126401}.
#'
#' Attilio Meucci (2020). \href{Estimation of Structured t-Copulas}{https://www.mathworks.com/matlabcentral/fileexchange/19751-estimation-of-structured-t-copulas}, MATLAB Central File Exchange. Retrieved October 14, 2020.
#'
#' @examples
#' #
StrucTMLE <- function(X, K, Tolerance = 10 ^ (-10)) {

  if (!(is.numeric(Tolerance) && length(Tolerance) == 1)) {
    stop("Tolerance is not a number (a length one numeric vector).", call. = FALSE)
  }
  if (!(is.numeric(K) && length(K) == 1)) {
    stop("K is not a number (a length one numeric vector).", call. = FALSE)
  }
  if (!is.matrix(X)) {
    stop("X must be a numeric matrix.", call. = FALSE)
  }

  Nus <- 1:50 # significant grid of potential degrees of freedom

  LL <- c() # log-likelihood
  sep_cop <- SeparateMargCop(X) # extract copula
  W <- sep_cop$W
  F <- sep_cop$F
  U <- sep_cop$U

  for (s in seq_along(Nus)) {
    Nu <- Nus[s]
    Y  <- stats::qt(U, Nu)
    C  <- MleRecursionForT(Y, Nu, K, Tolerance)
    LL <- c(LL, LogLik(Y, Nu, C))
  }

  Index <- which.max(LL)
  Nu <- Nus[Index]
  C  <- MleRecursionForT(Y, Nu, K, Tolerance)

  # if X has names, add them back into the fitted matrix the make the output prettier
  names_ <- colnames(X)
  if (!is.null(names_)) {
    colnames(C) <- names_
    rownames(C) <- names_
  }

  list(Nu = Nu, C = C)

}
