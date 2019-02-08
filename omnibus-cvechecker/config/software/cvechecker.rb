name "cvechecker"

dependency "musl-gcc"
dependency "argp"
dependency "strings"

source git: "https://github.com/sjvermeu/cvechecker.git"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['CC'] = 'x86_64-linux-musl-gcc'
  env['LIBS'] = '-largp'
  env['LDFLAGS'] = "-Wl,-rpath,#{install_dir}/embedded/lib,-rpath,#{install_dir}/embedded/x86_64-linux-musl/lib"
  env['LDFLAGS'] += ',-dynamic-linker,/opt/cvechecker/embedded/x86_64-linux-musl/lib/libc.so'
  env['LDFLAGS'] += " -L#{install_dir}/embedded/lib"

  patch source: 'omnibus-config-location.patch', plevel: 0
  patch source: 'omnibus-strings.patch', plevel: 0
  
  configure_command = [
    "./configure",
    "--prefix=#{install_dir}/embedded",
    "--host=x86_64-linux-musl",
    "--enable-sqlite3"
  ]
  
  command "autoreconf --force --install"
  command configure_command.join(" "), env: env
  command "make -j #{workers} install", env: env
  # command "make -j #{workers} postinstall", env: env
  copy "./conf/cvechecker.conf", "#{install_dir}/embedded/etc"
end
