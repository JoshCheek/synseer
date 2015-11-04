require 'pathname'
require 'erb'

module SyntaxSpray
  class Game
    attr_accessor :name, :code
    def initialize(name, code)
      self.name, self.code = name, code
    end
  end

  class App

    def self.default
      return @default if defined? @default
      root_dir  = Pathname.new File.expand_path('../..', __dir__)
      games_dir = root_dir / 'games'
      games     = games_dir.children.map do |child|
        name = child.basename.sub_ext('').to_s.gsub("_" , " ")
        Game.new name, child.read
      end
      @default = new games
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
          <% games.each do |game| %>
            <%= game.name %>
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
