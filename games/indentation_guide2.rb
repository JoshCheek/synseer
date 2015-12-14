# definitions and breakdown of the rules are here:
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2

# multiple levels of nesting
rows.each do |row|
  row.each do |cell|
    puts "The cell is: #{cell.inspect}"
    puts "This is nother line!"
  end
end

# def and end are at the same level
def a
  1
end

# classes, modules, and methods
module SortAlgorithms
  class BubbleSort
    def sort
      # do this thing
      # and then do that thing
    end
  end
end
