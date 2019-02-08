name "argp"
default_version "1.3"

dependency "musl-gcc"

version("1.3") { source md5: "720704bac078d067111b32444e24ba69" }

source url: "http://www.lysator.liu.se/~nisse/misc/argp-standalone-#{version}.tar.gz"
relative_path "argp-standalone-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['CC'] = 'x86_64-linux-musl-gcc'
  env['CXX'] = 'x86_64-linux-musl-g++'

  patch source: "001-throw-in-funcdef.patch", plevel: 1
  patch source: "gnu89-inline.patch", plevel: 1
  
  command "autoreconf --force --install"
  command "./configure --host=x86_64-linux-musl" \
          " --prefix=#{install_dir}/embedded", env: env
  command "make -j #{workers}", env: env

  copy "argp.h", "#{install_dir}/embedded/include"
  copy "libargp.a", "#{install_dir}/embedded/lib"
end
