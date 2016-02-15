module Synseer
  module GameLoader
    # -- more tedious than hard --
    # decorators
    # active_record_normal
    # active_record_harder
    # couchdb_and_google_calendar
    # env_hash_injection

    # -- These need to be gone through, they're way too much --
    # my_enumerable

    def self.load(filepath)
      construct_games File.read(filepath)
    end

    def self.construct_games(game_string)
      games = game_string
                .lines
                .slice_before { |line| line =~ /^# -- .*? --$/ }
                .map { |header, *body_lines|
                  header =~ /^# -- (.*?) --$/
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
  end
end
