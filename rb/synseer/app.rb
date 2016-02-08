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
        two_statements
        numbers
        strings_vs_symbols
        puts
        method_calls_self_1
        set_and_get_local
        method_calls_self_2
        get_local_vs_call_method
        method_calls_self_3
        set_local_vs_setter_method
        set_local_vs_set_ivar
        constant_vs_method_call
        set_ivar_vs_set_setter
        nested_method_calls
        various_getters
        method_calls_fancy_1
        method_calls_fancy_2
        negative_var_vs_literal
        whitespace_on_operators
        require_statements
        true_false_nil
        and
        or
        boolean_operators
        operator_setters
        comparisons
        if_statements_1
        if_statements_2
        if_statements_3
        unless_statements
        ternaries
        while
        until
        one_vs_two_equals
        operators
        broken_operators
        logic_vs_bitwise_operators
        a_test
        arrays_vs_brackets_1
        arrays_vs_brackets_2
        bracket_access
        angry_arrays_1
        angry_arrays_2
        angry_arrays_3
        angry_arrays_4
        lol

        object_model_as_linked_list_of_hashes
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

        []
        # more tedious than hard
        # decorators
        # active_record_normal
        # active_record_harder
        # couchdb_and_google_calendar
        # env_hash_injection
        # ] +
        #
        # These need to be gone through, they're way too much
        # %w[
        # my_enumerable
        # ]

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
