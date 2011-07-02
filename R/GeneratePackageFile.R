FindDependencies <- function(path) {
  files <- dir(path, pattern="\\.R$|\\.S$|\\.r$|\\.s$", recursive=T)
  dependencies <- c()
  for (i in files) {
    f <- suppressWarnings(readLines(i))
    dep <- f[grep("^require|^library", tolower(f))]
    dep <- gsub("require|library|\\(|\\)| |\\\t|, quietly=TRUE", "", dep)
    dependencies <- c(dependencies, dep)
  }
  dependencies <- unique(dependencies)
  return(dependencies)

}


GeneratePackageFile <- function(path=".") {
  scaffoldText <- c()
  scaffoldText[length(scaffoldText) + 1 ] <- "# Place your R package requirements in this file."
  scaffoldText[length(scaffoldText) + 1 ] <- "# For specification options, see ?PackageFile."
  write(paste(scaffoldText, collapse='\n'), file="Packages")
  
  repo = ifelse(options("repos") == "@CRAN@", "http://cran.r-project.org", options("repos"))
  write(paste('\n', "source: ", repo, sep=""), file="Packages", append=T)
  dependencies <- FindDependencies(path)
  scaffoldText[length(scaffoldText) + 1 ] <- "# Automatically generated package requirements from your project directory:"
  write(paste("pkg", shQuote(dependencies), collapse='\n'), file="Packages", append=T)
}
