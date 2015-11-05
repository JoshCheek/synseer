require 'pathname'
require 'sinatra'
require 'json'
require 'syntax_spray/scores'
require 'tilt/erb'

module SyntaxSpray
  class App < Sinatra::Base
    def self.root_dir
      games_dir = Pathname.new File.expand_path('../..', __dir__)
    end

    def self.default
      return @default if defined? @default
      games = (root_dir / 'games').children.map do |child|
        basename = child.basename.sub_ext('').to_s
        [basename, { path: "/games/#{basename}",
                     name: basename.gsub('_', ' '),
                     body: child.read,
                     json_ast:  nil, # loaded lazily for now
                   }
        ]
      end
      @default = self.new(games.to_h)
    end

    set :views, root_dir / 'views'

    attr_reader :games
    def initialize(games, *rest)
      @games = games
      super(*rest)
    end

    attr_reader :scores
    before { @scores = Scores.deserialize request.cookies['scores'] }
    after  { response.set_cookie 'scores', scores.serialize }

    get '/' do
      erb :root
    end

    get '/games/:game_name' do
      @game = games.fetch params[:game_name]
      @game[:json_ast] ||= ast_for(@game.fetch(:body))
      erb :game
    end

    private

    require 'json'
    require 'net/http'
    def ast_for(ruby_code)
      uri       = URI('http://localhost:3003')
      uri.query = URI.encode_www_form(code: ruby_code)
      Net::HTTP.get_response(uri).body # NOTE: can fail, but really I'd like to pull it in locally, anyway
    end
  end
end
