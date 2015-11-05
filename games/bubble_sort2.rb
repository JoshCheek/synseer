class SortAlgorithms
  class BubbleSort
    attr_reader :array

    def initialize(array)
      @array = array
    end

    def sort
      array.each { bubble_across }
      array
    end

    def bubble_across
      (array.length-1).times { |index| bubble_once index }
    end

    def bubble_once(index)
      swap(index) if swap?(index)
    end

    def swap?(index)
      array[index+1] < array[index]
    end

    def swap(index)
      array[index], array[index+1] = array[index+1], array[index]
    end
  end
end

SortAlgorithms::BubbleSort.new(["e", "a", "c", "b", "d"]).sort
# => ["a", "b", "c", "d", "e"]
