Packager.Require <- function(path = ".") {
  Packages <- ReadPackageFile(path)
  for(i in 1:nrow(Packages$packages)) {
    suppressWarnings(require(Packages$packages$name[i], quietly=T, character.only=T))
  }

  message("Packages loaded from ", path)
}


Packager.Install <- function(path = ".") {
  if(length(dir(path, pattern = "Packages.lock")) == 0) { #No lock file, so initial install from Package file -- same as a Packager.Update()
    Packager.Update(path)
    LockPackages(file.path(path, "Packages")) 
  }
  else if(file.info("Packages")$mtime > file.info("Packages.lock")$mtime) { #Packages file has changed, need to check for difference with Packages.lock, resolve, and update lock file
    
  } else { #No update, just need to check for each package in Packages.lock and install needed ones
    lockedPackages <- yaml.load_file("Packages.lock")
    for(p in 1:length(lockedPackages$Dependencies)) {
      version <- tryCatch(packageVersion(names(lockedPackages$Dependencies[p])), error=function(e) {InstallPackage(names(lockedPackages$Dependencies[p]), lockedPackages$Dependencies[[p]], lockedPackages$pkgsources)})
      if(version != lockedPackages$Dependencies[[p]]) {
        InstallPackage(names(lockedPackages$Dependencies[p]), lockedPackages$Dependencies[[p]], lockedPackages$pkgsources)
      }
    } 
  }
}



# Find and install the packages that meet the specifications in "Packages", 
# and then generate a "Packages.lock" file. Alternately, can specify a 
# single package to update as per the specifications in "Packages" and 
# generate a new "Packages.lock" file.
Packager.Update <- function(path = "./Packages", package = NULL) {
  Packages <- ReadPackageFile(path)
  for(i in 1:nrow(Packages$packages)) {
    pkgsource = ifelse(is.na(Packages$packages$source[i]), Packages$repos, Packages$packages$source[i])
    InstallPackage(Packages$packages$name[i], Packages$packages$version[i], pkgsource)  
  }
}


InstallPackage <- function(package, pkgversion, pkgsource) {
  if(length(grep("git", pkgsource)) >0) {
    GitInstall(gsub("git =>", "", pkgsource))
    resp = "Installed"
  } else if(length(grep("cran", pkgsource)) >0 || length(grep("=>", pkgsource)) == 0) {
    resp <- InstallCranVersion(package, pkgversion, pkgsource)
  }
  cat(resp, package, "version", as.character(packageVersion(package)), "from", pkgsource, "\n")
}
