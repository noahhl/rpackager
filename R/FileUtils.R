ReadPackageFile <- function(path=".") {
  Packages <- readLines(file.path(path, "Packages"))
  repos <- strsplit(sub("source: |Source: ", "", Packages[grep("source:", tolower(Packages))]), ",")[[1]]
  packages <- data.frame(name=character(0), version=character(0), source=character(0), stringsAsFactors=F)
  specs <- Packages[grep("^pkg", tolower(Packages))]
  for(s in specs) {
    name = gsub("^pkg|'|\"| ", "", strsplit(s, ",")[[1]][1])
    version = ifelse(is.null(strsplit(s, ",")[[1]][grep('[=|~>|>|>=] [0-9]', strsplit(s, ",")[[1]])]), NA, strsplit(s, ",")[[1]][grep('[=|~>|>|>=] [0-9]', strsplit(s, ",")[[1]])])
    source = ifelse(is.null(strsplit(s, ",")[[1]][grep('=>',strsplit(s, ",")[[1]])]), NA, strsplit(s, ",")[[1]][grep('=>',strsplit(s, ",")[[1]])])
    packages <- rbind(packages, data.frame(name=name, version=version, source=source, stringsAsFactors=F))
  }
  return(list(repos=repos, packages=packages))
}
