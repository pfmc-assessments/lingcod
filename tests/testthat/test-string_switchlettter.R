
test_that("area changes to n", {
  expect_equal(
    string_switchletter("tables/sens_table_s_bio_rec.csv", "North"),
    "tables/sens_table_n_bio_rec.csv"
  )
  expect_equal(
    string_switchletter("tables/sens_table_s_bio_rec.csv", "n"),
    "tables/sens_table_n_bio_rec.csv"
  )
  expect_equal(
    string_switchletter("tables/sens_table_s_bio_rec.csv", "north is cool"),
    "tables/sens_table_n_bio_rec.csv"
  )
})
test_that("area changes with different deliminator", {
  expect_equal(
    string_switchletter("apple-s-new", "North"),
    "apple-n-new"
  )
  expect_equal(
    string_switchletter("apple.s.new", "North"),
    "apple.n.new"
  )
})

