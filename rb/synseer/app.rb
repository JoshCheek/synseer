require 'pathname'
require 'sinatra'
require 'json'
require 'tilt/erb'
require 'synseer/parse'
require 'synseer/games'

module Synseer
  class App < Sinatra::Base
    def self.root_dir
      games_dir = Pathname.new File.expand_path('../..', __dir__)
    end

    def self.from_test_fixtures
      self.new 'integer_addition' => {
                 id:        "integer_addition",
                 path:      '/games/integer_addition',
                 name:      'integer addition',
                 body:      "1 + 2\n",
                 json_ast:  nil, # loaded lazily for now
                 next_game: "string_literal",
               },
               'string_literal' => {
                 id:        "string_literal",
                 path:      "/games/string_literal",
                 name:      "string literal",
                 body:      "'abc'\n",
                 json_ast:  nil, # loaded lazily for now
                 next_game: nil,
               }
    end

    def self.default
      @default ||= self.new GAMES
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

    get '/api/games/:game_name' do
      @game = games.fetch params[:game_name]
      @game[:json_ast] ||= Parse.ast_for @game.fetch(:body)
      content_type :json
      JSON.dump @game
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
