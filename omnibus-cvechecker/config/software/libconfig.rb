name "libconfig"
default_version "1.7.2"

dependency "musl-gcc"

version("1.7.2") { source md5: "6bd98ee3a6e6b9126c82c916d7a9e690" }
version("1.5") { source md5: "e92a91c2ddf3bf77bea0f5ed7f09e492" }

source url: "https://hyperrealm.github.io/libconfig/dist/libconfig-#{version}.tar.gz"
# source url: "https://github.com/hyperrealm/libconfig/archive/v#{version}.tar.gz"
relative_path "libconfig-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['CC'] = 'x86_64-linux-musl-gcc'
  env['CXX'] = 'x86_64-linux-musl-g++'
  env['LDFLAGS'] = "-Wl,-rpath,#{install_dir}/embedded/lib,-rpath,#{install_dir}/embedded/x86_64-linux-musl/lib"
  env['LDFLAGS'] += ',-dynamic-linker,/opt/cvechecker/embedded/x86_64-linux-musl/lib/libc.so'
  env['LDFLAGS'] += " -L#{install_dir}/embedded/lib"

  command "autoreconf --force --install"
  command "./configure --host=x86_64-linux-musl" \
          " --prefix=#{install_dir}/embedded", env: env
  command "make -j #{workers}", env: env
  command "make -j #{workers} install", env: env
end
