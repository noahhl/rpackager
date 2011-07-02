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


GetAvailableVersions <- function(package, repo = "http://cran.r-project.org") {
  current <- GetAvailablePackages(repo)
  archive <- suppressWarnings(readLines(paste(repo, "/src/contrib/Archive/", package, sep="")))
  archive <- archive[grep(".tar.gz", archive)]
  versions <- gsub("<a href=|\"|.tar.gz|_","", substr(archive, regexpr("<a href=.*?.tar.gz", archive), regexpr("<a href=.*?.tar.gz", archive) + attr(regexpr("<a href=.*?.tar.gz", archive), "match.length")))
  versions <- gsub(package, "", versions)
  versions <- c(versions, current[current$Package == package, "Version"])
  return(versions)
}


InstallVersion <- function(package, repo, version) {
  versions = GetAvailableVersions(package, repo)
  
  if(versions[length(versions)] == version) {
    install.packages(package, repos = repo)
  } else {
    download.file(paste(repo, "/src/contrib/Archive/", package, "/", package, "_", version, ".tar.gz", sep=""), destfile = file.path(tempdir(), paste(package, ".tar.gz",sep="")))
    install.packages(file.path(tempdir(), paste(package, ".tar.gz",sep="")), repos=NULL)
  }
}