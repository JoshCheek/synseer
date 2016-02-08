# definitions and breakdown of the rules are here:
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2

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

# parentheses
puts(
  "omg",
  "wtf",
  "bbq"
)

# indented on the next line
abcd.efgh(
  ijkl: 123,
  mnop: 456,
  qrst: 789
)


# hash literals
fruit_counts = {
  bananas: 1,
  apples:  5,
  oranges: 3,
}
