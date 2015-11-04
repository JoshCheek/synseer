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
end
