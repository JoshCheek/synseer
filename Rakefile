$LOAD_PATH.unshift File.expand_path('lib-rb', __dir__)
task default: :test

# =====  Tests  =====
desc 'Run all tests'
task test: ['test:integration', 'test:ruby', 'test:js']

namespace :test do
  desc 'Run integration tests (Phantomjs)'
  task(:integration) { sh 'bundle', 'exec', 'mrspec', '--tag', 'integration' }

  desc 'Run Ruby unit tests'
  task(:ruby) { sh 'bundle', 'exec', 'mrspec', '--tag', '~integration' }

  desc 'Run JavaScript unit tests'
  task(js: 'tmp/node_types') { sh 'npm test' }
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
  task :js do
    mkdir_p 'public/js'
    sh 'browserify', '--transform', 'babelify',
                     '--outfile',   'public/js/synseer.js',
                     '--require',   './src-js/synseer/index.js:synseer',
                     *FileList['src-js/**/*.js']
  end
end

file 'tmp/node_types' do
  require 'synseer/parse'
  codes = FileList['games/*'].map { |f| File.read f }
  node_types = Synseer::Parse.nodes_in(*codes)
  mkdir_p 'tmp'
  File.write 'tmp/node_types', node_types.map { |type| "#{type}\n" }.join
end


# =====  Running  =====
desc 'Run the server'
task(server: :build) { sh 'bundle', 'exec', 'rackup', 'config.ru' }
