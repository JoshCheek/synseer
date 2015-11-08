$LOAD_PATH.unshift File.expand_path('rb', __dir__)
task default: :test

# =====  Tests  =====
desc 'Run all tests'
task test: ['test:ruby', 'test:js', 'test:integration'] # ordered by how long they'll probably take

namespace :test do
  desc 'Run integration tests (Phantomjs)'
  task(integration: :build) { sh 'bundle', 'exec', 'mrspec', '--tag', 'integration' }

  desc 'Run Ruby unit tests'
  task(:ruby) { sh 'bundle', 'exec', 'mrspec', '--tag', '~integration' }

  desc 'Run JavaScript unit tests'
  task(js: 'tmp/node_types') { sh 'npm test' }
end


# =====  Running  =====
desc 'Run the server'
task(:server) { sh 'bundle', 'exec', 'rackup', 'config.ru', '--port', ENV.fetch('PORT', '9293') }
task server: :build if ENV['RACK_ENV'] != 'production'


# =====  Build / Compile  =====
require 'rake/clean'
desc 'Asset compilation'
task build: ['public/js/synseer.js', 'public/css/main.css', 'public/css/reset.css', 'tmp/node_types']

file 'css/synseer/main.scss' => [ 'css/synseer/palette.scss' ]
file 'js/synseer/index.js'   => [ 'js/synseer/default_keymap.js',
                                  'js/synseer/game.js',
                                  'js/synseer/stats_view.js',
                                  'js/synseer/traverse_ast.js'
                                ]

CLOBBER.include 'public'
CLEAN.include '.sass-cache'
directory 'public/css'
file('public/css/reset.css' => 'css/reset.css')
file('public/css/main.css'  => 'css/synseer/main.scss')
file('public/css/reset.css' => 'public/css') { cp 'css/reset.css', 'public/css/reset.css' }
file('public/css/main.css'  => 'public/css') { sh 'scss', '--sourcemap=none', '-I', 'css', '--update', 'css/synseer/main.scss:public/css/synseer/main.css' }

directory 'public/js'
file 'public/js/synseer.js' => ['js/synseer/index.js', 'public/js'] do
  sh 'browserify', '--transform', 'babelify',
                   '--outfile',   'public/js/synseer.js',
                   '--require',   './js/synseer/index.js:synseer',
                   *FileList['js/**/*.js']
end

CLEAN.include 'tmp'
directory 'tmp'
file 'tmp/node_types' do
  require 'synseer/parse'
  codes = FileList['games/*'].map { |f| File.read f }
  node_types = Synseer::Parse.nodes_in(*codes)
  mkdir_p 'tmp'
  File.write 'tmp/node_types', node_types.map { |type| "#{type}\n" }.join
end
