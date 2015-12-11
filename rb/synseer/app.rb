require 'pathname'
require 'sinatra'
require 'json'
require 'tilt/erb'
require 'synseer/parse'

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

    get '/' do
      erb :root
    end

    get '/games/:game_name' do
      @game = games.fetch params[:game_name]
      @game[:json_ast] ||= JSON.dump Parse.ast_for @game.fetch(:body)
      erb :game
    end

    get '/js/:filename' do
      content_type :js
      File.read (self.class.root_dir / 'js' / params[:filename])
    end
  end
end
