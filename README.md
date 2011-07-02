<code>rpackager</code> is an R package and dependency management tool similar to the Bundler package management used in Ruby.

There are two files created and used by <code>rpackager</code> -- <code>Packages</code>, which is user editable, and <code>Packages.lock</code>, which should generally not be edited manually.

The <code>Packages</code> file specifies the packages, versions, and sources needed by your project. It can be generated manually, or through calling <code>GeneratePackageFile(path=".")</code>, which will generate a <code>Packages</code> file by searching recursively through the path specified and identifying calls to <code>require</code> or <code>library</code>.

A <code>Packages</code> file should look like (see also Packages.example):

<pre>
# Place your R package requirements in this file.
# For specification options, see ?PackageFile.

source: http://cran.r-project.org
pkg 'yaml'
pkg 'RCurl', source => "http://omegahat.org/R"
pkg 'rjson'
pkg 'XML'
pkg 'campfireR', git => "git@github.com:noahhl/campfireR.git"
pkg 'Rook'
pkg 'fortunes', = 1.0.2
</pre>

The general syntax for each line specifying a package is:
<pre>
  pkg 'name-of-package', 'optional-version-specification', 'source-other-than-default-repository'
</pre>


