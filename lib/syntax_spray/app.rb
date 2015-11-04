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

    def total_completed
      data.length
    end

    def total_correct
      0 # totals_for 'correct'
    end

    def total_incorrect
      0 # totals_for 'incorrect'
    end

    def total_time
      0 # totals_for 'time'
    end

    private

    def totals_for(attribute)
      data.map { |name, stats| stats[attribute]||0 }.reduce(0, :+)
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

        <div class="total_score">
          <div class="games_completed"> <%= scores.total_completed %> </div>
          <div class="correct">         <%= scores.total_correct   %> </div>
          <div class="incorrect">       <%= scores.total_incorrect %> </div>
          <div class="time">            <%= scores.total_time      %> seconds </div>
        </div>

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
