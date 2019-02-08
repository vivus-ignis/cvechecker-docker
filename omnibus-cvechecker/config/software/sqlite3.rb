name "sqlite3"
default_version "3260000"

dependency "musl-gcc"

version("3260000") { source md5: "ac2b3b8cd3a97600e36fb8e756e8dda1" }

source url: "https://www.sqlite.org/2018/sqlite-autoconf-#{version}.tar.gz"
relative_path "sqlite-autoconf-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['CC'] = 'x86_64-linux-musl-gcc'
  env['LDFLAGS'] = "-Wl,-rpath,#{install_dir}/embedded/lib,-rpath,#{install_dir}/embedded/x86_64-linux-musl/lib"
  env['LDFLAGS'] += ',-dynamic-linker,/opt/cvechecker/embedded/x86_64-linux-musl/lib/libc.so'
  env['LDFLAGS'] += " -L#{install_dir}/embedded/lib"

  command "autoreconf --force --install"
  command "./configure --host=x86_64-linux-musl" \
          " --prefix=#{install_dir}/embedded", env: env
  command "make -j #{workers}", env: env
  command "make -j #{workers} install", env: env
end
