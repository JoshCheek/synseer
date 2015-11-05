require 'json'


module SyntaxSpray
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

    def for?(game_id)
      !!data[game_id]
    end

    def update(game_id, values)
      data[game_id] = values
    end

    def total_completed
      data.length
    end

    def total_correct
      totals_for 'correct'
    end

    def total_incorrect
      totals_for 'incorrect'
    end

    def total_duration
      totals_for 'duration'
    end

    def correct_for(game_id)
      data.fetch(game_id).fetch('correct')
    end
    def incorrect_for(game_id)
      data.fetch(game_id).fetch('incorrect')
    end
    def duration_for(game_id)
      data.fetch(game_id).fetch('duration')
    end

    private

    def totals_for(attribute)
      data.map { |game_id, stats| stats[attribute]||0 }.reduce(0, :+)
    end
  end
end
