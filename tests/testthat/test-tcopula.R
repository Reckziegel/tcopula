x <- diff(log(EuStockMarkets))
tcop <- StrucTMLE(X = x, K = 2)

test_that("tcop has length of 2", {
  expect_length(tcop, 2L)
})

test_that("tcop is named", {
  expect_named(tcop, c("Nu", "C"))
})

test_that("names from x are keep in C", {
  expect_equal(colnames(tcop$C), colnames(x))
})

test_that("K and Tolerance must be an scalar numeric", {
  expect_error(StrucTMLE(X = x, K = c(1, 1)))
  expect_error(StrucTMLE(X = x, K = 3, Tolerance = c(2, 1)))
})
