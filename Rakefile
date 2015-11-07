task default: :test

# =====  Tests  =====
desc 'Run all tests'
task test: ['test:integration', 'test:ruby', 'test:js']

namespace :test do
  desc 'Run Phantomjs integration tests'
  task(:integration) { sh 'bundle', 'exec', 'mrspec' }

  desc 'Run Ruby unit tests'
  task :ruby

  desc 'Run JavaScript unit tests'
  task(:js) { sh 'npm test' }
end


# =====  Build / Compile  =====
desc 'Asset compilation'
task build: ['build:css', 'build:js']

namespace :build do
  in_css_dir = ['-I', 'public/css']
  css_files  = ['public/css/synseer/main.scss:public/css/synseer/main.css']

  desc 'Continually build the files'
  task(:continually) { sh 'scss', *in_css_dir, '--watch', *css_files }

  desc 'Compile sass into css'
  task(:css) { sh 'scss', *in_css_dir, '--update', *css_files }

  desc 'Compile JavaScript'
  task(:js) do
    mkdir_p 'public/js'
    sh 'browserify', '--transform', 'babelify',
                     '--outfile',   'public/js/synseer.js',
                     '--require',   './src-js/synseer/index.js:synseer',
                     *FileList['src-js/**/*.js']
  end
end
