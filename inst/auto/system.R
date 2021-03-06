suppressMessages(library(margarita))
suppressMessages(library(xtable))
suppressMessages(library(ggplot2))
suppressMessages(library(gridExtra))

dataPath <- file.path(dataRoot, drug, study)

author <- paste0("Author: ", Sys.getenv("LOGNAME"))

options(width=60)

titleString <- paste0("Autogenerated extreme value modelling report: ",
                      drug, ", Study ", study)

tfun <- getTransFun(trans)
itfun <- tfun[[2]]
tfun <- tfun[[1]]

seed <- as.numeric(gsub("-", "", Sys.Date())) # no need to use date here
set.seed(seed)
