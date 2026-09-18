# remove some italics from decision table by modifying .tex file for North doc
# see https://github.com/pfmc-assessments/lingcod/issues/167 for discussion

texfile <- "models/2021.n.023.001_fixWAreccatchhistory/decision_table.tex"
texfile_lines <- readLines(texfile)
bad_italics <- c("8166", "8156", "8162",
                 "0.476", "0.475", "0.476",
                 "13887", "13790", "13723",
                 "0.567", "0.563", "0.560")

for (num in bad_italics) {
  texfile_lines <- gsub(paste0("\\em{", num, "}"),
                        paste0(num),
                        x = texfile_lines, fixed = TRUE)
}

writeLines(texfile_lines, texfile)
