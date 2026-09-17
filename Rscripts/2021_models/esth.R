
r4ss::copy_SS_inputs(dir.old=file.path("models", "2021.n.011.008_Francis"),
               dir.new=file.path("models", "2021.n.012.005_esth"),
               overwrite = TRUE,
               copy_exe = TRUE, copy_par = TRUE,
               dir.exe = system.file("bin", "Windows64", package = "lingcod"))
r4ss::copy_SS_inputs(dir.old=file.path("models", "2021.s.012.004_fewer_ages_wide_M_prior_Francis"),
               dir.new=file.path("models", "2021.s.012.005_esth"),
               overwrite = TRUE,
               copy_exe = TRUE, copy_par = TRUE,
               dir.exe = system.file("bin", "Windows64", package = "lingcod"))

mapply(FUN = r4ss::SS_changepars,
  dir = file.path("models", c("2021.n.012.005_esth", "2021.s.012.005_esth")),
  MoreArgs = list(
       ctlfile = "ling_control.ss",
       newctlfile = "ling_control.ss",
       strings = "steep",
       newlos = 0.2, newhis = 0.99, newprior = .777, newprsd = .113, newprtype = 2, estimate = TRUE, newphs = 4
  )
)
file.path("models", c("2021.n.012.005_esth", "2021.s.012.005_esth"))


outs <- mapply(SIMPLIFY = FALSE, r4ss::SS_output,
            dir=dir("models",pattern = "esth$|fewer_ages|n.+008_Francis", full.names=TRUE))
mid <- r4ss::SSsummarize(outs)
r4ss::SSplotComparisons(mid, subplot=1, legendlabels = basename(names(outs)))
