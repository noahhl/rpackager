GetAvailablePackages <- function(repos) {
  availablePackages <- data.frame()
  for(i in 1:length(repos)) {
    a = suppressWarnings(available.packages(contrib.url(repos[i])))
    if(nrow(a) == 0) {
      a = suppressWarnings(available.packages(contrib.url(repos[i], type='source')))
    }
    availablePackages <- rbind(availablePackages, data.frame(a, stringsAsFactors=F))
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
  archive <- try(suppressWarnings(readLines(paste(repo, "/src/contrib/Archive/", package, sep=""))), silent=T)
  if(length(archive) > 0) {
    archive <- archive[grep(".tar.gz", archive)]
    versions <- gsub("<a href=|\"|.tar.gz|_","", substr(archive, regexpr("<a href=.*?.tar.gz", archive), regexpr("<a href=.*?.tar.gz", archive) + attr(regexpr("<a href=.*?.tar.gz", archive), "match.length")))
    versions <- gsub(package, "", versions)
    versions <- c(versions, current[current$Package == package, "Version"])
  } else {
    versions = current[current[,"Package"] == package, "Version"]
  }
  return(versions)
}


InstallCranVersion <- function(package, pkgversion, repo) {
  versions = GetAvailableVersions(package, repo)
  if(as.character(tryCatch(packageVersion(package), error=function(e){return("0.0.0")})) == gsub("-", ".", versions[length(versions)]) || (!is.na(pkgversion) && as.character(tryCatch(packageVersion(package), error=function(e) {return("0.0.0")})) == pkgversion)) {
    return("Using")
  } else {
    if(is.na(pkgversion) || versions[length(versions)] == pkgversion) {
      v = tryCatch(install.packages(package, repos = repo), warning=function(w) {tryCatch(install.packages(package, repos=repo, type='source'), warning=function(w) {return("FAILED AT")})})
      if(v == "FAILED AT")
        return(v)
    } else {
      download.file(paste(repo, "/src/contrib/Archive/", package, "/", package, "_", pkgversion, ".tar.gz", sep=""), destfile = file.path(tempdir(), paste(package, ".tar.gz",sep="")))
      install.packages(file.path(tempdir(), paste(package, ".tar.gz",sep="")), repos=NULL)
    }
    return("Installed")
  }
}
