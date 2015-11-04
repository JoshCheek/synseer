$LOAD_PATH.unshift 'lib', __dir__
require 'syntax_spray/app'
run SyntaxSpray::App.default
