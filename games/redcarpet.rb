require 'redcarpet'
renderer = Redcarpet::Render::HTML.new
markdown = Redcarpet::Markdown.new(renderer)
markdown.render('# omg') # => "<h1>omg</h1>\n"
