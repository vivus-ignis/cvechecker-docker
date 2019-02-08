name "cvechecker"
maintainer "Yaroslav Tarasenko <yaroslav.tarasenko.ext@siemens.com>"
homepage "https://github.com/sjvermeu/cvechecker"

install_dir "#{default_root}/#{name}"

build_version Omnibus::BuildVersion.semver
build_iteration 1

dependency "sqlite3"
dependency "libconfig"
dependency "cvechecker"

# dependency "version-manifest"

exclude "**/.git"
exclude "**/bundler/git"
