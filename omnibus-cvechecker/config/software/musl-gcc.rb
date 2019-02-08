name "musl-gcc"

source git: "https://github.com/richfelker/musl-cross-make.git"

whitelist_file "/lib64/.*"
whitelist_file "/usr/lib64/.*"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['TARGET'] = 'x86_64-linux-musl'

  command "make -j #{workers}", env: env
  command "make -j #{workers} install OUTPUT=#{install_dir}/embedded", env: env
end
