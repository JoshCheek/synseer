# definitions and breakdown of the rules are here: https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2

# def and end are at the same level
def a
  1
end

# opening bracket and closing bracket are at the same level
[ "abcd",
  "efgh",
  "ijkl",
]

# the `end` is aligned with `array`, as if it were a sibling.
array.each do |element|
  puts element
end

# aligned at end of the expression
abcd.efgh ijkl: 123,
         mnop: 456,
         qrst: 789

# indented on the next line
abcd.efgh(
 ijkl: 123,
mnop: 456,
qrst: 789
)


# multiple levels of nesting
rows.each do |row|
  row.each do |cell|
    puts "The cell is: #{cell.inspect}"
    puts "This is nother line!"
  end
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

# parentheses
puts(
  "omg",
  "wtf",
  "bbq"
)

# array literals
[ "omg",
  "wtf",
  "bbq"
]

# hash literals
fruit_counts = {
  bananas: 1,
  apples:  5,
  oranges: 3,
}

# if / else / elsif /end
if car.speed > speed_limit
  officer.issue_ticket(car)
else
  officer.eat_donut
end

# unless
unless car.speed > speed_limit
  officer.eat_donut
end

# case / when / else / end
case letter
when "a"
  # ...
when "b"
  # ...
when "c"
  # ...
else
  # ...
end

# or this one
case letter
when "a" then # ...
when "b" then # ...
when "c" then # ...
else # ...
end


# begin / rescue / ensure / else / end
begin
  user.authenticate
rescue AuthenticationError => e
  response.status = 401
ensure
  response.cookies[:requested_url] = request.url
end

# while / end
sum = 0
iterations = 0
while iterations < 3
  iterations += 1
  sum += iterations
end

# until / end
sum = 0
iterations = 0
until iterations >= 3
  iterations += 1
  sum += iterations
end
