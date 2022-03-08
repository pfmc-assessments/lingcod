# run this for a given model
if (FALSE) {
  r4ss::SSexecutivesummary(mod.2021.n.023.001)
  r4ss::SSexecutivesummary(mod.2021.s.018.001)
}

for (Area in c("North", "South")) {
  for (sex in c("f", "m")) {
    sep <- ifelse(sex == "f", ".", "_")
    file.path("models",
              info_basemodels[[Area]],
              "tables",
              paste0("natage", sep, sex, ".csv")) %>%
      read.csv() %>%
      round(1) %>%
      kableExtra::kbl(format = "html") %>%
      kableExtra::kable_styling("striped") %>%
      kableExtra::save_kable(file.path(
                    "docs",
                    paste0(Area, "_natage.",
                           sex, ".html")))
  }
}
