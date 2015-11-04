require 'pathname'
require 'erb'

module SyntaxSpray
  class App

    def self.default
      return @default if defined? @default
      root_dir    = Pathname.new File.expand_path('../..', __dir__)
      games_dir   = root_dir / 'games'
      named_games = games_dir.children.map do |child|
        [child.basename.sub_ext('').to_s.intern, child.read]
      end
      @default    = new named_games.to_h
    end

    attr_accessor :games

    def initialize(games)
      self.games = games
    end

    def call(env)
      template = <<-BODY
        <!DOCTYPE html>
        <html>
        <body>
        <div class="available_games">
          <% games.each do |name, code| %>
            <%= name %>
          <% end %>
        </div>
        </body>
        </html>
      BODY

      body = ERB.new(template).result(binding)
      [200,{'Content-Type' => 'text/html', 'Content-Length' => body.length.to_s},[body]]
    end
  end
end
