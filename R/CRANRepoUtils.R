GetAvailablePackages <- function(repos) {
  availablePackages <- data.frame()
  for(i in 1:length(repos)) {
    availablePackages <- rbind(availablePackages, data.frame(available.packages(contrib.url(repos[i])), stringsAsFactors=F))
  }
  availablePackages <- availablePackages[!duplicated(availablePackages$Package), ]
  return(availablePackages)
}

GetInstalledPackages <- function() {
  installedPackages <- data.frame(installed.packages(), stringsAsFactors=F)
  return(installedPackages)
}