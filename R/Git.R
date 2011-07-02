GitInstall <- function(repos) {
  if(length(strsplit(repos, ",")[[1]]) > 1) {
    branch = strsplit(repos, ",")[[1]][2]
    repos = strsplit(repos, ",")[[1]][1]
  }
    name = gsub(".git", "", strsplit(repos, "\\/")[[1]][-1])
  suppressWarnings(dir.create('vendor'))
  if(length(dir("vendor/", pattern=name) == 1) ) {
     system(paste("cd vendor/", name, " && git pull origin master", sep=""))
  } else {
    system(paste("cd vendor && git clone", repos, "&& cd", name))
  }
  if(exists("branch")) {
    system(paste("cd vendor && cd", name, " && git checkout", branch))
  }
  system(paste("cd vendor && R CMD INSTALL ", name))
}

