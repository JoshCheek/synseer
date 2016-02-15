module Synseer
  def self.construct_games(game_string)
    games = game_string
              .lines
              .slice_before { |line| line =~ /^-- .*? --$/ }
              .map { |header, *body_lines|
                header =~ /^-- (.*?) --$/
                id = $1.downcase.gsub(/\W/, '_').squeeze("_")
                [id, { id:        id,
                       path:      "/games/#{id}",
                       name:      id.gsub('_', ' '),
                       body:      body_lines.join.strip,
                       json_ast:  nil, # loaded lazily for now
                       next_game: nil,
                     }
                ]
              }

    games.each_cons(2) do |(left_id, left), (right_id, right)|
      left[:next_game] = right_id
    end

    games.to_h
  end

  GAMES = construct_games <<-Ruby.gsub(/^    /, '')
    -- integer addition --
    1 + 2

    -- two statements --
    123
    456
  Ruby
end


__END__
      order = %w[
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
