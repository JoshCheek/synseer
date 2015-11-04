require 'pathname'
require 'sinatra'
require 'json'

module SyntaxSpray
  class Game
    attr_accessor :name, :code
    def initialize(name, code)
      self.name, self.code = name, code
    end
  end


  class Scores
    def self.deserialize(data)
      new JSON.parse(data||'{}')
    end

    def serialize
      JSON.dump data
    end

    attr_accessor :data
    def initialize(data)
      self.data = data || {}
    end

    def for?(game_name)
      data[game_name]
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

    attr_reader :games
    def initialize(games, *rest)
      @games = games
      super(*rest)
    end

    attr_reader :scores
    before { @scores = Scores.deserialize request.cookies['scores'] }
    after  { response.set_cookie 'scores', scores.serialize }

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
                <% if scores.for? game.name %>
                  <%= raise 'figure me out!'; scores.for(game.name) %>
                <% else %>
                  unattempted
                <% end %>
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
