require 'redcarpet'
input_filename  = ARGV[0]
output_filename = ARGV[1]

markdown = File.read input_filename
renderer = Redcarpet::Render::HTML.new
html     = Redcarpet::Markdown.new(renderer).render(markdown)

File.write(output_filename, html)

puts "Converted #{input_filename} (#{markdown.lines.count} lines)" +
     " to #{output_filename} (#{html.lines.count} lines)"
