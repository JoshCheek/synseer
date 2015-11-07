desc 'Asset compilation'
task build: 'build:css'

namespace :build do
  in_css_dir = ['-I', 'public/css']
  css_files  = ['public/css/synseer/main.scss:public/css/synseer/main.css']

  desc 'Compile sass into css'
  task :css do
    sh 'scss', *in_css_dir, '--update', *css_files
  end

  desc 'Continually build the files'
  task :continually do
    sh 'scss', *in_css_dir, '--watch', *css_files
  end
end
