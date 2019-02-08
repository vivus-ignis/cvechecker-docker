name "strings"
default_version "2.31.1"

dependency "musl-gcc"

version("2.31.1") { source md5: "84edf97113788f106d6ee027f10b046a" }

source url: "https://ftp.gnu.org/gnu/binutils/binutils-#{version}.tar.bz2"
relative_path "binutils-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['CC'] = 'x86_64-linux-musl-gcc'
  env['LDFLAGS'] = "-Wl,-rpath,#{install_dir}/embedded/lib,-rpath,#{install_dir}/embedded/x86_64-linux-musl/lib"
  env['LDFLAGS'] += ',-dynamic-linker,/opt/cvechecker/embedded/x86_64-linux-musl/lib/libc.so'
  env['LDFLAGS'] += " -L#{install_dir}/embedded/lib"

  command "./configure --host=x86_64-linux-musl" \
          " --prefix=#{install_dir}/embedded", env: env
  command "make -j #{workers}", env: env

  copy "./binutils/strings", "#{install_dir}/embedded/bin"
end
