x <- diff(log(EuStockMarkets))
tcop <- struct_t_mle(x = x, k = 2)

test_that("tcop has length of 2", {
  expect_length(tcop, 2L)
})

test_that("list objects of tcop have the right size", {
  expect_length(tcop$Nu, 1L)
  expect_length(tcop$C, 16L)
})

test_that("tcop is named", {
  expect_named(tcop, c("Nu", "C"))
})

test_that("names from x are keep in C", {
  expect_equal(colnames(tcop$C), colnames(x))
})

test_that("k and tolerance must be an scalar numeric", {
  expect_error(struct_t_mle(x = x, k = c(1, 1)))
  expect_error(struct_t_mle(x = x, k = 3, tolerance = c(2, 1)))
})
