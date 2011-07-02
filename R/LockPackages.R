LockPackages <- function(path="./Packages") {
  Packages <- ReadPackageFile(path)
  header <- "# This is an automatically generated file. Edit with caution."
  write(header, file="Packages.lock")
  write(paste("\nSources: ", paste(Packages$repos, collapse=", "), sep=""), file="Packages.lock", append=T)

  availablePackages <- GetAvailablePackages(Packages$repos)
  installedPackages <- GetInstalledPackages()
  
  write("Packages:", file="Packages.lock", append=T)
  for(i in 1:nrow(Packages$packages)) {
    write(paste("  ", Packages$packages$name[i], ":", sep=""), file="Packages.lock", append=T)
    write(paste("    Version:", packageVersion(Packages$packages$name[i])), file="Packages.lock", append=T)
    if(length(packageDescription(Packages$packages$name[i])$Depends) > 0)
      write(paste("    Depends:", packageDescription(Packages$packages$name[i])$Depends), file="Packages.lock", append=T)
    if(length(packageDescription(Packages$packages$name[i])$Suggests) > 0)
      write(paste("    Suggests:", packageDescription(Packages$packages$name[i])$Suggests), file="Packages.lock", append=T)    
    
    if(!is.na(Packages$packages$source[i])) { #Some source specified, use that
      write(paste("    Source:", Packages$packages$source[i]), file="Packages.lock", append=T)
    } else  { #No source specified, use first preferenced CRAN repository
      write(paste("    Source:", availablePackages$Repository[availablePackages$Package == Packages$packages$name[i]]), file="Packages.lock", append=T)
    }
    
  }
  
  write("\nDependencies:", file="Packages.lock", append=T)
  for(i in 1:nrow(Packages$packages)) {
    children = paste(packageDescription(Packages$packages$name[i])$Depends, packageDescription(Packages$packages$name[i])$Suggests, sep=", ")
    if(length(children) > 0) {
        for(p in strsplit(children, ", ")[[1]]) {
          package <- installedPackages[p == installedPackages$Package, ]
          if(nrow(package) == 0)
            package <- availablePackages[p == availablePackages$Package, ]
          if(nrow(package) > 0 && !(package$Package[1] %in% Packages$packages$name)) {
            write(paste(" ", package$Package[1], ": ", package$Version[1], sep=""), file="Packages.lock", append=T)
          }
        }
      }    
    }
  
}
