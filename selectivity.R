## ----selectivity-setupnotes, echo = FALSE, include = FALSE, eval = FALSE------
## NA


## -----------------------------------------------------------------------------
# create empty list
block_breaks <- list()

# first additions of blocks break points
block_breaks[["Comm_Trawl_sel"]] <- c(1993, 1998, 2011)
block_breaks[["Comm_Trawl_ret_infl"]] <- c(1998, 2007, 2010, 2011)
block_breaks[["Comm_Trawl_ret_width"]] <- c(1998, 2011)


## -----------------------------------------------------------------------------
# add block break points to list created above
block_breaks[["Comm_Fix_ret_infl"]] <- c(1998, 2011)
block_breaks[["Comm_Fix_ret_width"]] <- c(1998, 2011)


## -----------------------------------------------------------------------------
# add block break points to list created above
block_breaks[["Rec_WA_sel"]] <- c(1987, 1995, 1998, 2007, 2011, 2017)


## -----------------------------------------------------------------------------
# add block break points to list created above
block_breaks[["Rec_OR_sel"]] <- c(1995, 1998, 2007)


## -----------------------------------------------------------------------------
# add block break points to list created above
block_breaks[["Rec_CA_sel"]] <- c(1999)


## -----------------------------------------------------------------------------
# add block break points to list created above
block_breaks[["Surv_Tri_sel"]] <- c(1995)

