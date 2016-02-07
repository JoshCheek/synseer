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
      return @default if defined? @default
      # TODO: Add introductory games, whose purpose is to allow them to
      #       explore some of the syntaxes in the small, outside of these
      #       gists I copied in

      order = %w[
        integer_addition
        puts
        require_statements
        a_test
	      common_examples
        object_model_as_linked_list_of_hashes
        lol
        redcarpet
        linked_list
        ] +

        # intermediate
        %w[
        indentation_guide1
        bubble_sort1
        indentation_guide2
        bubble_sort2
        indentation_guide3
        chisel
        push_dependencies_up_the_callstack
        seedzzz
        ] +

        # not are more tedious than hard
        %w[
        decorators
        active_record_normal
        active_record_harder
        couchdb_and_google_calendar
        env_hash_injection
        ] +

        # These need to be gone through, they're way too much
        %w[
        my_enumerable
      ]

      games = (root_dir / 'games')
        .children
        .map     { |path| [path, path.basename.sub_ext('').to_s] }
        .select  { |path, basename| order.include? basename }
        .sort_by { |path, basename| order.index(basename) || raise(basename.inspect) }
        .map     { |path, basename|
          [basename, { id:        basename,
                       path:      "/games/#{basename}",
                       name:      basename.gsub('_', ' '),
                       body:      path.read,
                       json_ast:  nil, # loaded lazily for now
                       next_game: nil,
                     }
          ]
        }

      games.each_cons(2) do |(left_id, left), (right_id, right)|
        left[:next_game] = right_id
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

    get '/api/games/:game_name' do
      @game = games.fetch params[:game_name]
      @game[:json_ast] ||= Parse.ast_for @game.fetch(:body)
      content_type :json
      p @game
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
