# -- an integer --
100

# -- a method call --
3.even?

# -- two statements --
123
456

# -- a method call with an argument --
100.gcd(15)

# -- parentheses are optional --
100.gcd(15)
100.gcd 15

# -- operators are method calls --
1.+(2)
1.+ 2
1 + 2

# -- integers can be any size --
123
1
165186589135719360917360246347302345676543234565195106510578

# -- negative and positive signs are part of an integer literal --
-45
+45

# -- assign and look up a local variable --
num = 1
num

# -- negative and positive signs are method calls on non-literals --
num = 1
-num
+num

# -- numbers starting with 0x are entered in hexadecimal --
0xFF # => 255

# -- numbers starting with 0b are entered in binary --
0b101 # => 5

# -- numbers starting with 0 are entered in octal --
010 # => 8

# -- numbers with decimal places are floats --
123.456 # => 123.456

# -- floats can be entered in scientific notation --
123e4 # => 1230000.0

# -- integers with an r suffix are rationals --
2r  # => (2/1)

# -- integers with an i suffix are imaginary --
2i  # => (0+2i)

# -- several numbers together 1 --
123
123.456

# -- several numbers together 2 --
0x10
0b10
010
10

# -- quoted text is a string --
"abc"

# -- strings can have single quotes or double quotes --
"abc"
'abc'

# -- the contents of the string don't change that its a string --
"123"

# -- text with a leading colon is a symbol --
:abc

# -- you can choose which type of quote if your --
"O'malley"
'"In teaching others, we teach ourselves" -- proverb'

# -- strings with a leading colon are symbold --
:"O'malley"
:'"In teaching others, we teach ourselves" -- proverb'

# -- interpolation allows strings to embed dynamic values --
"a#{1}b#{2}c"

# -- symbols can be interpolated --
:"a#{1}b#{2}c"

# -- single quotes dont support interpolation --
"a#{1}b#{2}c"
'a#{1}b#{2}c'

# -- same for symbols --
:"a#{1}b#{2}c"
:'a#{1}b#{2}c'

# -- two strings adjacent to each other get joined into one --
"'" '"'

# -- empty strings and symbols --
""
:""
''
:''

# -- a bare word is a method call or local variable --
a

b = 1
b

# -- there is always a current object named self --
self

# -- methods without a dot are called on self --
a
self.a

# -- puts is a method call --
puts "hello"

# -- method calls on self 1 --
a
a()
self.a
self.a()

# -- method calls on self with arguments --
add_nums 1, 2, 3
concat_strings("a", "b", "c")

# -- assign and lookup local --
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

# -- methods ending in an equal sign can have whitespace --
self.a=(1)
self.a= 1
self.a = 1

# -- words with a leading asperand are instance variables --
@a
a

# -- you can assign instance variables --
a = 1
@a = 1

# -- assign local vs ivar vs setter method --
a = 1
@a = 1
self.a = 1

# -- words beginning in capital letters are constants --
A

# -- constants can be accessed through two colons --
A::B::C
a::B::C

# -- if a constant receives an argument it is actually a method call --
A(1)
A 1
A A

# -- methods and constants --
A A
A::B
A B::C D::E

# -- you can assign constants --
A = 1
Object::B = 2

# -- nested method calls --
a(b(c(1)))
a b c 1

# -- words beginning with a dollar sign are global variables --
$a = 1
$a

# -- constant vs local --
A
a

# -- local vs method --
a
a()

# -- instance vs global --
@a
$a

# -- method calls fancy 1 --
a.+(1)
a.+ 1
a + 1
a / 1
a < 1

# -- exclamation marks are method calls --
!a
!1

# -- if a local receives an argument it is actually a method call --
a = 1
a
a 1
a a

# -- if a local has parens it is actually a method call --
a = 1
a()

# -- moar method calls vs locals
a - a
a(-a)
a - a()
a() - a

# -- always match whitespace around operators to avoid confusion --
a = 1

b(-a) # clear
b - a # clear
b -a  # confusing

# -- negative var vs literal --
-1
-a
-2.3
-A
-@a

# -- require is a method call --
require 'minitest/pride'

# -- true false nil --
true
false
nil

# -- exclamation marks are method calls --
!true
!false
!nil

# -- double negate to convert an object to true or false --
!!true
!!false
!!nil
!!"i'll become true"

# -- boolean and --
true && false && true

# -- boolean or --
true || false || true

# -- equality checks are method calls --
1 == 1
a == 1

# -- you can put equality checks inside of booleans --
a == 1 && b == 2
a == 1 || b == 2

# -- use parens if you want to mix and match boolean operators --
1 && nil && (false || "hello") && true

# -- booleans can span multiple lines --
abcd &&
  efgh &&
  (hijk || lmno) &&
  true

# -- operator setter on local --
a = 1
a += 1

# -- operator setter on instance variable --
@c = 1
@c += 1

# -- operator setter on global variable --
$d = 1
$d += 1

# -- operator setter on setter method --
100.b = 1
100.b += 1

# -- operator setter on constant --
# don't do this :P
A = 1
A += 1

# -- operator setter on undeclared variables --
# my opinion: Ruby should consider this one a bug
a += 1

# -- comparisons are method calls --
1 < 2
1 > 2
1 == 2
1 <= 2
1 >= 2

# -- regardless of what object they are being called on --
"a" < "b"
"a" > "b"
"a" == "b"
"a" <= "b"
"a" >= "b"

# -- empty if statements --
if true
end

if false
end

# -- if statement with a body --
if true
  1
end

if false
  1
end

# -- if statement with a multiline body --
if true
  1
  2
end

# -- if statement with a complex condition --
if true && false
  1
end

if true || false
  1
end

# -- if statement with a more complex condition --
if abcd || efgh
  1
end

# -- if statement with an even more complex condition --
num = 5
if (num == 101) || num.even?
  1
end

# -- inline if statement --
if true
  1
end

1 if true

# -- inline if statement with complex condition --
if a && b
  1
end

1 if a && b

# -- if statement with 2 possibilities --
if a == 1
  'one'
elsif a == 2
  'two'
end

# -- if statement with default branch --
if a == 1
  'one'
else
  'not one'
end

# -- if statement with then keyword --
if a == 1 then
  'one'
else
  'not one'
end

# -- inline if statement using if then else --
if a && b then
  1
else
  2
end

if a && b then 1 else 2 end

# -- if statement with several branches and default --
if char == '1'
  'one'
elsif char == '2'
  'two'
elsif char == '3'
  'three'
else
  'other'
end

# -- unless is an if with a negated condition --
if !a
  @b
end

unless a
  @b
end

# -- inline if and equivalent inline unless --
1 if !a
2 unless a

# -- ternaries are short if statements --
true ? 1 : 2

# -- chained ternaries
abcd   ? 1 :
  efgh ? 2 :
  ijkl ? 3 :
         4

# -- while is a greedy if statement --
a = 1
while a < 10
  a += 1
end

# -- inline while statement --
b = 1
b += 1 while b < 10

# -- until is a greedy unless statement --
a = 1
until a >= 10
  a += 1
end

# -- inline unless statement
b = 1
b += 1 until b >= 10

# -- loop is a method call with a block argument --
loop do
  puts "still going"
end

# -- times and upto are method calls with block arguments --
3.times { puts "times" }
1.upto(3) { puts "upto" }

# -- one equal is assignment two is equality check --
a = 1
a == 1

# -- this is pretty --
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

# -- i dont even know --
!1
1.!

# -- broken operators --
# THIS IS BROKEN!
1 < 2 && 3 # It really means that 1 is less than 2, and 3 is a truthy value

# for example
user.age < laws.drinking_age && its_five_oclock_somewhere?


# -- two ampersands is a boolean operator one is a method call --
1 && 2
1 & 2

# -- two pipes is a boolean operator one is a method call --
1 || 2
1 | 2

# -- this code wont print --
a = 1
b = a + 5
if b < a
  puts a
end

# -- brackets after a word are a method call --
a = ['a', 'b', 'c', 'd']
a[0]    # => "a"
a[1, 2] # => ["b", "c"]

# -- be careful with whitespace --
# call brackets on a
a = 1
a[]

# pass an array to the method b
b []
b [0]
b([0])


# -- repeatedly calling brackets --
chars = ["a", "b", "c"]
chars[0]
chars[0][0]
chars[0][0][1]

# -- brackets in method calls --
chars = ["a", "b", "c"]
chars[0] + chars[1]

# -- brackets in brackets --
chars = ["a", "b", "c"]
chars[chars[0].length]
chars[[chars[0]]]
chars[chars[0]]

# -- brackets that are syntactically valid but make no sense --
chars = ["a", "b", "c"]
chars[chars]
chars[0]
chars[0+1]
chars[0+chars[1]]

# -- calling brackets on literal arrays --
array = [100, 200, 300]

array[0]           # => 100
[100, 200, 300][0] # => 100

array[1]           # => 200
[100, 200, 300][1] # => 200

array[2]           # => 300
[100, 200, 300][2] # => 300

# -- calling brackets on literal strings --
string = "abc"

string[0]  # => "a"
"abc"[0]   # => "a"

string[1]  # => "b"
"abc"[1]   # => "b"

string[2]  # => "c"
"abc"[2]   # => "c"

# -- hashes have a key and value between curly braces --
{"key" => "value"}

# -- keys and vlaues be any object --
{[] => "", 100 => 123.45, {} => :lol}

# -- when hash keys are symbols you can put the colon on the right and omit the rocket --
{:old_key => "value1", new_key: "value2", "new key2": "value3"}

# -- when hashes are the last argument to a method they dont need curly braces --
p a: "b", c: "d"

# -- calling brackets on literal hashes --
hash = {a: 100, b: 200, c: 300}

hash[:a]                     # => 100
{a: 100, b: 200, c: 300}[:a] # => 100

hash[:b]                     # => 200
{a: 100, b: 200, c: 300}[:b] # => 200

hash[:c]                     # => 300
{a: 100, b: 200, c: 300}[:c] # => 300

# -- angry arrays 1 --
[]
[[]]
[][]
[[][]]

# -- angry arrays 2 --
[[][]][[][]]

# -- angry arrays 3 --
[[][[]]]

# -- angry arrays 4 --
[[[][]][[][]][[][]]]

# -- angry arrays 5 --
[
][
][
]

# -- angry arrays 6 --
[
][
[]][
]

# -- angry arrays 7 --
[[][
]][[
]][[
[]][
][]]

# -- you can define your own methods with def --
def my_method
  100
end
my_method

# -- locals still beat method calls --
def my_method
  100
end
my_method = :no_dice
my_method

# -- methods can receive parameters --
def add(num1, num2)
  num1 + num2
end
add(100, 200)

# -- methods can omit parentheses around their parameters --
def add num1, num2
  num1 + num2
end
add 100, 200

# -- lol --
def lol(lol)
  lol
end
lol = 123
lol lol

# -- methods can choose a default parameter when one is not passed --
def a(b)
end

def c(d=1)
end

# -- methods can collect the rest of their parameters into an array --
def sum(*numbers)
  sum = 0
  numbers.each { |number| sum += number }
  sum
end

sum               # => 0
sum 100           # => 100
sum 100, 200, 300 # => 600

# -- methods can receive keyword parameters which assign by name --
def divide(dividend:, divisor:)
  dividend / divisor
end
divide dividend: 100, divisor: 5 # => 20
divide divisor: 5, dividend: 100 # => 20

# -- keyword parameters can have defaults too --
def a(b:, c:1)
  [b, c]
end
a(b: 9)      # => [9, 1]
a(b: 9, c: 2)# => [9, 2]

# -- you can collect the rest of the keyword parameters into a hash --
def a(b:, **c)
end
a(b: 1, this: "will", go: "to", the: "hash", named: "c")

# -- methods can receive blocks --
def m(&b)
  b.call(100)
end
m { |n| n + 1 } # => 101

# -- blocks can be curly braces or do end --
[1, 2, 3].map { |n| n + 1 }

[1, 2, 3].map do |n|
  n + 1
end

# -- when passing arguments the block is outside the parens --
['a', 'b', 'c', 'd'].each_slice(2) { |a, b| p a, b }

# -- curly braces after method calls are empty blocks not empty hashes --
puts({})
puts {}
puts() {}

# -- curly braces are sent to the method immediately left do end to farthest left --
a b {}      # block goes to b
a b do end  # block goes to a

# -- all parameter types together --
def m(a, b=:default, *c, d, e:, f:1, **g, &h)
  [a, b, c, d, e, f, g, h.call]
end

m 1, 2, 3, 4, 5, e: 6, f: 7, other1: 8, other2: 9 do
  100
end
# => [1, 2, [3, 4], 5, 6, 7, {:other1=>8, :other2=>9}, 100]


# -- you can pass array elements as arguments with an asterisk --
def add(n1, n2, n3)
  n1 + n2 + n3
end

nums = [100, 20, 3]
add(*nums) # => 123

# -- you can pass a hash as keywords with two asterisks --
def add(n1:, n2:, n3:)
  n1 + n2 + n3
end

nums = {n1: 100, n2: 20, n3: 3}
add(**nums) # => 123

# -- you can pass a lambda or proc with an ampersand --
def call_this(&block)
  block.call
end

b = lambda { 101 }
call_this(&b) # => 101

# -- a method can receive a block even if it doesnt say so and it can invoke the block with yield --
def gimme_your_blocks
  yield if block_given?
end
gimme_your_blocks { 100 } # => 100
gimme_your_blocks         # => nil

# -- methods can rescue errors without using the begin keyword --
def keep_it_in
  raise "rawr"
rescue
  # ahem
end

# -- methods can return early with the return keyword
def returnin_early(early)
  return "left early" if early
  "left late"
end
returnin_early true   # => "left early"
returnin_early false  # => "left late"

# -- if you return multiple values they get turned into an array --
def nums
  return 1, 2
end
nums # => [1, 2]


# -- methods are usually defined in classes --
class User
  def initialize(name)
    @name = name
  end

  def name
    @name
  end
end
user = User.new("Josh")
puts user.name

# -- two dots make an inclusive range three make an exclusive range --
(1..5).to_a   # => [1, 2, 3, 4, 5]
(1...5).to_a  # => [1, 2, 3, 4]

# -- many things can be used in a range --
('a'..'e').to_a   # => ["a", "b", "c", "d", "e"]

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
