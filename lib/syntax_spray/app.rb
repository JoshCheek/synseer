require 'pathname'
require 'sinatra'

module SyntaxSpray
  class Game
    attr_accessor :name, :code
    def initialize(name, code)
      self.name, self.code = name, code
    end
  end

  class App < Sinatra::Base
    def self.default
      return @default if defined? @default
      games_dir = Pathname.new File.expand_path('../../games', __dir__)
      games = games_dir.children.map do |child|
        Game.new child.basename.sub_ext('').to_s.gsub("_" , " "), child.read
      end
      @default = self.new(games)
    end

    attr_accessor :games

    def initialize(games, *rest)
      self.games = games
      super(*rest)
    end

    get '/' do
      template = <<-BODY
        <!DOCTYPE html>
        <html>
        <body>
        <div class="available_games">
          <% games.each do |game| %>
            <div class="game">
              <div class="name"><%= game.name %></div>
              <div class="score">
                <%= game.name %>
              </div>
            </div>
          <% end %>
        </div>
        </body>
        </html>
      BODY

      erb template
    end
  end
end
