# -- integer addition --
1 + 2

# -- two statements --
123
456

# -- numbers --
123
1
11111111111111111111111111111111111111111111111111111111111
123.456
-45
+45
123e4
2r
2i
0xFF
0b10
010

# -- strings vs symbols --
"abc"
'abc'
:abc
"a'b"
'a"b'
:"a'b"
:'a"b'
"a#{1}b#{2}c"
:"a#{1}b#{2}c"
'a#{1}b#{2}c'
:'a#{1}b#{2}c'
"'" '"'
:':'

# -- puts --
puts "hello"

# -- method calls on self 1 --
a
a()
self.a
self.a()

# -- set and get local --
a = 1
a

# -- method calls on self 2 --
a 1
a(1)
self.a(1)

# -- get local vs call method --
a
a = 1
a

# -- method calls on self 3 --
a 1
a 1, 2
a(1, 2)
self.a(1)
self.a 1, 2

# -- set local vs setter method --
a = 1
self.a = 1

# -- set local vs set ivar --
a = 1
@a = 1

# -- constant vs method call --
A
A(1)
A 1
A A
A::B
A B::C D::E

# -- set ivar vs set setter --
@a = 1
self.a = 1

# -- nested method calls --
a(b(c(1)))
a b c 1

# -- various getters --
A
a
a()
@a
$a

# -- method calls fancy 1 --
a.+(1)
a.+ 1
a + 1
a / 1
a < 1
!a

# -- method calls fancy 2 --
a = 1
a
a 1
a a
a - a
a(-a)
a - a()
a() - a

# -- negative var vs literal --
-1
-a
-2.3
-A
-@a

# -- whitespace on operators --
a - b
a- b
a -b
a-b
a - -b
a - -1
-a

# -- require statements --
require 'minitest/pride'

# -- true false nil --
true
false
nil
!true
!false
!nil
!!true
!!false
!!nil

# -- and --
true && false
false && true
true && true && true
!true && false
nil && 1

# -- or --
true || false
false || true
true || true || true
!true || false
nil || 1

# -- boolean operators --
1 && nil && (false || "hello") && true

abcd &&
  efgh &&
  (hijk || lmno) &&
  true

# -- operator setters --
a = 1
a += 1
@c += 1
$d += 1
100.b += 1

# my opinion: Ruby should consider this one a bug
e += 1

# -- comparisons --
1 < 2
1 > 2
1 == 2
1 <= 2
1 >= 2

"a" < "b"
"a" > "b"
"a" == "b"
"a" <= "b"
"a" >= "b"

# -- if statements 1 --
if true
end

if true
  1
end

if false
end

if true
  1
  2
end

if false
  1
end

# -- if statements 2 --
if true && false
  1
end

if true || false
  1
end

if abcd || efgh
  1
end

if (num == 101) || num.even?
  1
end

# -- if statements 3 --
if true
  1
end

1 if true

if a && b
  1
end

1 if a && b

if a && b then 1 else 2 end

if char == :b
  1
elsif char == :c
  2
elsif char == :d
  3
else
  4
end

# -- unless statements --
if !a
  @b
end

unless a
  "b"
end

1 if !a
2 unless a

# -- ternaries --
true ? 1 : 2

a   ? 1 :
  b ? 2 :
  c ? 3 :
      4

# -- while --
a = 1
while a < 10
  a += 1
end

b = 1
b += 1 while b < 10

# -- until --
a = 1
until a >= 10
  a += 1
end

b = 1
b += 1 until b >= 10

# -- one vs two equals --
a
a 1
a = 1
a == 1
a = 1
a 1
a

# -- operators --
1.+(1)
1 + 1

1.-(1)
1 - 1

1./(1)
1 / 1

1.*(1)
1 * 1

1.^(1)
1 ^ 1

!1
1.!
1.<(1)
1.>(1)

# -- broken operators --
# this means that 1 is less than 2, and 3 is a truthy value
1 < 2 && 3

# for example
user.age < laws.drinking_age && its_five_oclock_somewhere?


# -- logic vs bitwise operators --
1 && 2
1 & 2
1 || 2
1 | 2

# -- a test --
a = 1
b = a + 5
if b < a
  puts a
end

# -- arrays vs brackets 1 --
chars = ["a", "b", "c"]
chars[0]
chars[0][0]
chars[0][0][1]
chars[0] + chars[1]
chars[chars[0].length]
chars[[chars[0]]]
chars[chars[0]]
chars[chars]
chars[0]
chars[0+1]
chars[0+chars[1]]

# -- arrays vs brackets 2 --
a[]
a []
a[0]
a [0]
a([0])

# -- bracket access --
array = [100, 200, 300]
array[0]
[100, 200, 300][0]

string = "abc"
string[0]
"abc"[0]

hash = {a: 100, b: 200, c: 300}
hash[:a]
{a: 100, b: 200, c: 300}[:a]

# -- angry arrays 1 --
[]
[[]]
[][]
[[][]]
[[][]][[][]]
[[][[]]]
[[[][]][[][]][[][]]]

# -- angry arrays 2 --
[
][
][
]

# -- angry arrays 3 --
[
][
[]][
]

# -- angry arrays 4 --
[[][
]][[
]][[
[]][
][]]

# -- lol --
def lol(lol)
  lol
end
lol = 123
lol lol

# -- object model as linked list of hashes --
basic_object = {methods: {equal?: 394}, superclass: nil}
object       = {methods: {to_s:   2},   superclass: basic_object}
sting_ray    = {methods: {flap:   1},   superclass: object}
marla        = {class: sting_ray}

marla[:class][:methods][:flap]
marla[:class][:superclass][:methods][:to_s]
marla[:class][:superclass][:superclass][:methods][:equal?]

# -- redcarpet --
require 'redcarpet'
renderer = Redcarpet::Render::HTML.new
markdown = Redcarpet::Markdown.new(renderer)
markdown.render('# omg') # => "<h1>omg</h1>\n"

# -- linked list --
class Node
  attr_accessor :data, :next_node
  def initialize(data, next_node)
    @data = data
    @next_node = next_node
  end
end

class List
  attr_accessor :head
  def initialize(head)
    @head = head
  end
end

node3 = Node.new({c: 394},      nil)
node2 = Node.new({a: 2, b: 10}, node3)
node1 = Node.new({a: 1},        node2)
list  = List.new(node1)

list.head.data[:a] # => 1
list.head.next_node.data[:a] # => 2
list.head.next_node.next_node.data[:c] # => 394


# -- indentation guide1 --
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

# -- bubble sort1 --
a = ["e", "a", "c", "b", "d"]
b = 0

while b < a.length
  c = 0
  d = 1

  while d < a.length
    e = a[c]
    f = a[d]
    if f < e
      a[c] = f
      a[d] = e
    end
    c += 1
    d += 1
  end

  b += 1
end

a

# -- indentation guide2 --
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


# -- bubble sort2 --
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


# -- indentation guide3 --
# definitions and breakdown of the rules are here:
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2

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

# -- chisel --
require 'redcarpet'
input_filename  = ARGV[0]
output_filename = ARGV[1]

markdown = File.read input_filename
renderer = Redcarpet::Render::HTML.new
html     = Redcarpet::Markdown.new(renderer).render(markdown)

File.write(output_filename, html)

puts "Converted #{input_filename} (#{markdown.lines.count} lines)" +
     " to #{output_filename} (#{html.lines.count} lines)"

# -- push dependencies up the callstack --
# Assuming we'd called this program from the command-line like this:
# $ ruby example.rb "some word from the command-line"
# SOME WORD FROM THE COMMAND-LINE
#
# Definitions:
#   Callstack:
#     The place that called (aka invoked) the current code,
#     we will return there when it we finish executing the current code.
#
#   Dependency:
#     Anything my code uses, or that is used by my code.
#     In other words, anything that affects my code.
#     This term is usually reserved for things that are painful when they affect your code,
#     like database connections, internet connections, global state, file systems,
#     side effects, randomness, singleton objects, original context, etc.


### Version 1 ###
# Here, the dependencies are:
#   ARGV    - argument passed to the program
#   $stdout - global variable to the output stream

def my_upcase
  upcased_arg = ARGV[0].gsub(/[a-z]/) { |char| (char.ord - 0x20).chr }
  $stdout.puts(upcased_arg)
end

my_upcase



### Version 2 ###
# Here, all the dependencies and context have been pushed higher in the callstack
#
# So this program does the same thing,
# but the my_upcase method can be invoked with any string from any source
# and we can do anything we want with the result,
# not just print it to one specific output stream

def my_upcase(string)
  string.gsub(/[a-z]/) { |char| (char.ord - 0x20).chr }
end

upcased_arg = my_upcase(ARGV[0])
$stdout.puts(upcased_arg)

# -- seedzzz --
users = 5.times.map do
  avatar = "http://robohash.org/#{Faker::Lorem.words.join}.png?size=400x400&set=set2"
  User.create!(
    email:       Faker::Internet.email,
    zipcode:     Faker::Address.zip_code,
    name:        Faker::Name.name,
    wishlist_id: "579KNEDD72QR",
    story:       Faker::Lorem.sentences(5).join(" "),
    avatar:      avatar
  )
end

2.times do
  Collection.create! do |c|
    c.title       = Faker::Lorem.words.map(&:capitalize).join(' ')
    c.description = Faker::Lorem.sentence
    c.user_id     = users.sample.id
    c.image       = 'http://lorempixel.com/400/200/abstract/?Y=400&X=400'

    8.times do
      c.pieces.build name:  Faker::Company.name,
                     image: 'http://lorempixel.com/400/200/abstract/?Y=400&X=400'
    end
  end
end
