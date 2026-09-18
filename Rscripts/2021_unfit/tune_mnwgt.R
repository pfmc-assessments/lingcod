tune_mnwgt <- function(dirbase, run = FALSE, version = "3.3", 
  fleets = c(1:3), mnwgt = TRUE, discard = TRUE, hessian = TRUE) {
  start <- tune_start(dirbase)
  ii_name <- changedir(dirbase, xx = 1, nnn = "mnwgt")
  copyinput(dirbase, ii_name, file.dat = paste0(start$file_dat, "$"),
    file.control = "control.ss_new")
  ignore <- file.copy(file.path(ii_name, "control.ss_new"), 
    file.path(ii_name, start$file_ctl), overwrite = TRUE)
  out <- r4ss::SS_output(dirbase, verbose = FALSE, printstats = FALSE)  
  inout <- function(data, type = c("CV", "sd")) {
    type <- match.arg(type)
    if (!"Std_in" %in% colnames(data)) data$Std_use <- data$CV * data$Exp
    if (!"CV" %in% colnames(data)) data$CV <- NA
    calc <- aggregate(list(
      "mean_out" = data$Exp, 
      "mean_in" = data$Obs,
      "CV_in" = data$CV, 
      "sd_in" = data$Std_use,
      "sd_out" = (data$Obs - data$Exp)^2), 
      by = list("fleet" = data$Fleet), mean)
    calc[, "sd_out"] <- sqrt(calc[, "sd_out"])
    calc[, "CV_out"] <- calc[, "sd_out"] / calc[, "mean_out"]
    calc$added <- switch(type,
      CV = calc[, "CV_out"] - calc[, "CV_in"],
      sd = calc[, "sd_out"] - calc[, "sd_in"])
    calc$type <- switch(type, CV = 3, sd = 2)
    return(calc)
  }
  calc <- matrix(nrow = 0, ncol = 9)
  if (mnwgt) calc <- rbind(calc, inout(out$mnwgt, type = "CV"))
  if (discard) calc <- rbind(calc, inout(out$discard, type = "sd"))
  calc <- calc[order(calc$type, calc$fleet), ]
  old <- getvars(file.in = file.path(ii_name, start$file_ctl))
  all <- merge(calc, old, all.x = TRUE, by = c("fleet", "type"))
  all$new <- all$added
  all$new <- ifelse(is.na(all$new) & all$added < 0, 0, 
    ifelse(all$new < 0, 0, all$new))
  vals <- all[all$fleet %in% fleets, c("type", "fleet", "new")]
  vals <- vals[order(vals$type, vals$fleet), ]
  colnames(vals) <- NULL
  removeme <- NULL
  if (discard) removeme <- c(removeme, 2)
  if (mnwgt) removeme <- c(removeme, 3)
  if (run) {
    ctl <- removevarpars(file.in = file.path(ii_name, start$file_ctl), 
      file.out = NULL, removefactor = removeme)
    ctl <- entervars(ctl.in = ctl, newvalues = vals,
      file.out = file.path(ii_name, start$file_ctl))
    ignore <- run_ss(ii_name, hess = hessian)
  }
  return(calc)
}
