$LOAD_PATH.unshift File.expand_path('rb', __dir__)
task default: :test

# =====  Scripts  =====
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


desc 'Run the server'
task(server: :build) { sh 'bundle', 'exec', 'rackup', 'config.ru', '--port', ENV.fetch('PORT', '9293') }


# =====  Build / Compile  =====
require 'rake/clean'
desc 'Asset compilation'
task build: [
  # css
  'public/css/main.css',
  'public/css/reset.css',

  # js
  'public/js/synseer.js',
  'public/js/jquery.js',

  # other generated files
  'tmp/node_types',
  'public/codemirror',
]

file 'js/synseer/index.js'   => [ 'js/synseer/default_keymap.js',
                                  'js/synseer/game.js',
                                  'js/synseer/stats_view.js',
                                  'js/synseer/traverse_ast.js'
                                ]

CLOBBER.include 'public'
CLEAN.include '.sass-cache'
directory 'public/css'
directory 'public/js'

file 'public/css/reset.css' => 'css/reset.css' do
  cp 'css/reset.css', 'public/css/reset.css'
end

file 'public/css/main.css'  => ['css/synseer/main.scss', 'css/synseer/palette.scss' ] do
  sh 'scss', '--sourcemap=none', '-I', 'css', '--update', 'css/synseer/main.scss:public/css/synseer/main.css'
end

directory 'public/codemirror' do
  cp_r 'node_modules/codemirror/', 'public/codemirror/'
end

file 'public/js/synseer.js' => ['js/synseer/index.js', 'public/js'] do
  sh 'browserify', '--transform', 'babelify',
                   '--outfile',   'public/js/synseer.js',
                   '--require',   './js/synseer/index.js:synseer',
                   *FileList['js/**/*.js']
end

file 'public/js/jquery.js' do
  cp 'js/jquery-2.1.4-min.js', 'public/js/jquery.js'
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

# desc 'show the syntax types for the various files'
# task :show do
#   require 'synseer/parse'
#   codes = FileList['games/*'].map { |f| [f, File.read(f)] }
#                              .to_h
#   codes.each do |filename, code|
#     puts "\e[32m#{File.basename filename}\e[0m"
#     puts Synseer::Parse.nodes_in(code).inspect
#     puts
#   end
# end
