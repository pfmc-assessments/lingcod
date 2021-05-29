context("Check fleets for lingcod")

test_that("Hook and line is fleet 8",{
  expect_equal(get_fleet("Hook")$num, 8)
})
