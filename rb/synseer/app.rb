require 'pathname'
require 'sinatra'
require 'json'
require 'tilt/erb'
require 'synseer/parse'
require 'synseer/scores'

module Synseer
  class App < Sinatra::Base
    def self.root_dir
      games_dir = Pathname.new File.expand_path('../..', __dir__)
    end

    def self.default
      return @default if defined? @default
      games = (root_dir / 'games').children.map do |child|
        basename = child.basename.sub_ext('').to_s
        [basename, { id:        basename,
                     path:      "/games/#{basename}",
                     name:      basename.gsub('_', ' '),
                     body:      child.read,
                     json_ast:  nil, # loaded lazily for now
                   }
        ]
      end
      @default = self.new(games.to_h)
    end

    set :views,      root_dir / 'views'
    set :public_dir, root_dir / 'public'

    attr_reader :games
    def initialize(games, *rest)
      @games = games
      super(*rest)
    end

    attr_reader :scores
    before { @scores = Scores.deserialize request.cookies['scores'] }
    after  { response.set_cookie 'scores', value: scores.serialize, path: '/', expires: (Time.now + (365*24*60*60)) }

    get '/' do
      erb :root
    end

    get '/games/:game_name' do
      @game = games.fetch params[:game_name]
      @game[:json_ast] ||= JSON.dump Parse.ast_for @game.fetch(:body)
      erb :game
    end

    # should really be a put, but is a post b/c jQuery has a convenient shorthand for it
    post '/games/:game_name' do
      scores.update params[:game_name],
                    'correct'   => params[:game][:correct].to_i,
                    'incorrect' => params[:game][:incorrect].to_i,
                    'duration'  => params[:game][:duration].to_i
      ''
    end
  end
end
