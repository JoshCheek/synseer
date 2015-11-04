require 'pathname'
require 'sinatra'
require 'json'
require 'syntax_spray/scores'

module SyntaxSpray
  class Game
    attr_accessor :name, :code
    def initialize(name, code)
      self.name, self.code = name, code
    end

    def path
      "/games/#{name.gsub(" ", "_")}"
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
      erb <<-BODY
        <!DOCTYPE html>
        <html>
        <body>

        <div class="total_score">
          <div class="games_completed"> <%= scores.total_completed %> </div>
          <div class="correct">         <%= scores.total_correct   %> </div>
          <div class="incorrect">       <%= scores.total_incorrect %> </div>
          <div class="time">            <%= scores.total_time      %> seconds </div>
        </div>

        <div class="available_games">
          <% games.each do |game| %>
            <div class="game">
              <div class="name">
                <a href="<%= game.path %>">
                  <%= game.name %>
                </a>
              </div>
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
    end

    get '/games/:game_name' do
      erb <<-BODY
        <!DOCTYPE html>
        <html>
        <head>
        </head>
        <body>
          <div class="code">

          </div>
        </div>
        </body>
        </html>
      BODY
    end
  end
end
