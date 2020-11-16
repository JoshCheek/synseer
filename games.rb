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

# -- you can choose between quote types to avoid escaping --
"O'malley"
'"In teaching others, we teach ourselves" -- proverb'

# -- strings with a leading colon are symbol --
:"O'malley"
:'"In teaching others, we teach ourselves" -- proverb'

# -- interpolation allows strings to embed dynamic values --
"a#{1}b#{2}c"

# -- symbols can be interpolated --
:"a#{1}b#{2}c"

# -- single quotes dont support interpolation --
"a#{1}b"
'a#{1}b'

# -- same for symbols --
:"a#{1}b"
:'a#{1}b'

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


# -- method calls on self with arguments --
add_nums 1, 2, 3
concat_strings("a", "b", "c")

# -- assign and lookup local --
a = 1
a

# -- get local vs call method --
a
a = 1
a

# -- method calls on self 1 --
a
a()
self.a
self.a()

# -- method calls on self 2 --
a 1
a(1)
self.a(1)

# -- method calls on self 3 --
a 1
a(1)

# -- method calls on self 4 --
a 1, 2
a(1, 2)

# -- method calls on self 5 --
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

# -- chaining method calls --
# each method is invoked on the return value of the expression before it
'abc'.upcase.reverse.downcase.chars.first # => "c"

# -- chaining method calls 2 --
# It doesn't matter if you split the expression across lines
'abc'       # => "abc"
  .upcase   # => "ABC"
  .reverse  # => "CBA"
  .downcase # => "cba"
  .chars    # => ["c", "b", "a"]
  .first    # => "c"

# -- chaining method calls 3 --
# We can get all funky with the dot (best practices, ya know?)
'abc'.              # => "abc"
  upcase  .reverse  # => "CBA"
  .downcase.        # => "cba"
  chars             # => ["c", "b", "a"]
.  first            # => "c"

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

# -- its fairly common to see constnats that are in SCREAMING_SNAKE_CASE --
SCREAMING_SNAKE_CASE

# -- argv and env are just constants they are not special --
ARGV
ENV

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
a = 1
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

# moar method calls vs locals
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

# -- exclamation marks on boolean literals are method calls --
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

# -- boolean keyword not is a method call to exclamation --
not true
not "whatevz"

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

# -- chained ternaries --
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

# -- inline unless statement --
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

# -- methods can return early with the return keyword --
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


# -- indentation guide multiline arrays --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
# opening bracket and closing bracket are at the same level
[ "abcd",
  "efgh",
  "ijkl",
]

# -- indentation guide multiline hashes --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
{ abcd: "value1",
  efgh: "value2",
  ijkl: "value3",
}

# -- indentation guide multiline blocks --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
# the `end` is aligned with `array`, as if it were a sibling.
array.each do |element|
  puts element
end

# -- indentation guide multiline args aligned at end --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
abcd.efgh ijkl: 123,
          mnop: 456,
          qrst: 789

# -- indentation guide multiline args starting on next line --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
puts(
  "omg",
  "wtf",
  "bbq"
)

# -- indentation guide multiline args hashes starting on next line --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
abcd.efgh(
  ijkl: 123,
  mnop: 456,
  qrst: 789
)


# -- indentation guide multiline hashes for local --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
fruit_counts = {
  bananas: 1,
  apples:  5,
  oranges: 3,
}

# -- bubble sort procedural --
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

# -- indentation guide multiple levels of nesting --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
rows.each do |row|
  row.each do |cell|
    puts "The cell is: #{cell.inspect}"
    puts "This is nother line!"
  end
end

# -- indentation guide methods --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
def a
  1
end

# -- indentation guide classes modules and methods --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
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


# -- indentation guide if with else --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
if car.speed > speed_limit
  officer.issue_ticket(car)
else
  officer.eat_donut
end

# -- indentation guide unless --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
unless car.speed > speed_limit
  officer.eat_donut
end

# -- indentation guide case statement on next line --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
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

# -- indentation guide case statement on same line --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
case letter
when "a" then # ...
when "b" then # ...
when "c" then # ...
else # ...
end

# -- indentation guide begin rescue ensure end --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
begin
  user.authenticate
rescue AuthenticationError => e
  response.status = 401
ensure
  response.cookies[:requested_url] = request.url
end

# -- indentation guide while end --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
sum = 0
iterations = 0
while iterations < 3
  iterations += 1
  sum += iterations
end

# -- indentation guide until end --
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2
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

# Before
def my_upcase
  upcased_arg = ARGV[0].gsub(/[a-z]/) { |char| (char.ord - 0x20).chr }
  $stdout.puts(upcased_arg)
end
my_upcase

# After
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

# -- singleton methods on local variable --
a = "str"
def a.letters
  length.times.map { |i| self[i] }
end
a.letters  # => ["s", "t", "r"]

# -- singleton methods on instance variable --
@a = "str"
def @a.letters
  length.times.map { |i| self[i] }
end
@a.letters  # => ["s", "t", "r"]

# -- singleton methods on constant variable --
def String.empty
  ""
end
String.empty # => ""

# -- singleton methods on self --
self # => main
def self.inspect
  "not-main"
end
self # => not-main

# -- singleton methods on class --
class User
  def self.create
    new
  end
end
User.create # => #<User:0x007fc2f2033e70>

# -- include is a method --
class User
  include Comparable

  attr_reader :age

  def initialize(age)
    @age = age
  end

  def <=>(user)
    age <=> user.age
  end
end

[User.new(10), User.new(37), User.new(15)].sort
# => [#<User:0x007f878482f380 @age=10>,
#     #<User:0x007f878482f308 @age=15>,
#     #<User:0x007f878482f358 @age=37>]


# -- extend and singleton methods --
words = Object.new

def words.each
  yield "salmon"
  yield "strawberry"
  yield "sicily"
end

words.extend Enumerable
words.map &:upcase
# => ["SALMON", "STRAWBERRY", "SICILY"]

# -- boolean keyword not is just a call to exclamation --
o = Object.new
def o.!
  "wat"
end

not o # => "wat"

# -- break --
num = 12
loop do
  $stdout.print "Enter a guess: "
  guess = gets.to_i
  break if guess == num
end

# -- expanding ranges into arrays --
(1..10).to_a # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
[*1..10]     # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# -- convenient enumerables --
[*'a'..'z']       # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u"...
  .map(&:to_sym)  # => [:a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, :l, :m, :n, :o, :p, :q, :r, :s, :t, :u, :v, :w, :x, :y, :z]
  .zip(
    [*1..26]      # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26]
  )               # => [[:a, 1], [:b, 2], [:c, 3], [:d, 4], [:e, 5], [:f, 6], [:g, 7], [:h, 8], [:i, 9], [:j, 10], [:k, 11], [:...
  .to_h           # => {:a=>1, :b=>2, :c=>3, :d=>4, :e=>5, :f=>6, :g=>7, :h=>8, :i=>9, :j=>10, :k=>11, :l=>12, :m=>13, :n=>14, ...
  .[](:r)         # => 18

# -- methods can end with exclamation marks --
def rawr!
  "#{self} says: rawr!"
end

rawr! # => "main says: rawr!"

# -- private is a method call --
class User
  attr_reader :name

  def initialize(name)
    self.name = name
  end

  private

  attr_writer :name
end

User.new("Josh").name # => "Josh"

# -- public is a method call 1 --
class User
  private

  attr_writer :name

  def initialize(name)
    self.name = name
  end

  public

  attr_reader :name
end

User.new("Josh").name # => "Josh"

# -- public is a method call 2 --
class User
  private

  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  public :name

end

User.new("Josh").name # => "Josh"

# -- protected is a method call --
class User
  attr_reader :name

  def initialize(name)
    self.name = name
  end

  protected

  attr_writer :name
end

User.new("Josh").name # => "Josh"

# -- clases can inherit from other classes --
class MyTest < Minitest::Test
  def test_something
    assert true
  end
end

# -- clases can be defined directly on a constant --
# be wary, this fucks with lexical scoping
class A::B::C
  def some_method
    123
  end
end

# -- super calls the overridden method --
class A
  def b
    1
  end
end

class B < A
  def b
    2 + super
  end
end

B.new.b # => 3

# -- once again but with malice --
# taken from the object model challenges https://gist.github.com/JoshCheek/ad9f70a6d855be9ed50d
class W
  def zomg() '1' + wtf  end
  def wtf()  '2'        end
  def bbq()  '3'        end
end

class X < W
  def zomg() super      end
  def wtf()  '4' + bbq  end
  def bbq()  super      end
end

class Y < X
  def zomg() '6' + super  end
  def wtf()  '7' + super  end
  def bbq()  '8' + super  end
end

W.new.zomg # => "12"
X.new.zomg # => "143"
Y.new.zomg # => "617483"

# -- silence destroy him --
module InSpace
  attr_reader :current_status
  def initialize(current_status, *whatevz)
    @current_status = current_status
    super(*whatevz)
  end
end

class Human
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

class Student < Human
  include InSpace
  attr_reader :lesson
  def initialize(lesson, *o_O)
    @lesson = lesson
    super *o_O
  end
end

students_in_space = Student.new(
  "The future is quite different to the present",
  "Though one thing we have in common with the present is we still call it the present, even though its the future",
  "What you call 'the present', we call 'the past', so... you guys are way behind"
)

# -- nokogiri challenge --
# https://github.com/CodePlatoon/daily/blob/master/week-02/2016-02-11-thu.md
require 'nokogiri'
require 'net/http'

url  = URI('http://www.imdb.com/title/tt1431045/fullcredits?ref_=tt_cl_sm#cast')
html = Net::HTTP.get(url)
doc  = Nokogiri::HTML(html)

spans = doc.css(".cast_list .itemprop span")
names = spans.map { |link| link.content }
names.each { |name| puts name }

# -- command line calculator --
left = ARGV.shift.to_f
while 0 < ARGV.length
  operator = ARGV.shift
  right    = ARGV.shift.to_f
  if '+' == operator
    left += right
  elsif '-' == operator
    left -= right
  elsif '*' == operator
    left *= right
  elsif '/' == operator
    left /= right
  end
end
puts left

# -- print choose longest --
longest  = ""
comparer = ARGV.shift
ARGV.each do |arg|
  if comparer == 'first'
    longest = arg if longest.length < arg.length
  else
    longest = arg if longest.length <= arg.length
  end
end
$stdout.puts longest unless longest.length == 0

# -- print first longest --
longest = ""
ARGV.each { |arg| longest = arg if longest.length < arg.length }
$stdout.puts longest unless longest.length == 0

# -- draw pictures --
require 'chunky_png' # if this fails, you can get it with `gem install chunky_png`

bg_color   = ChunkyPNG::Color.rgb 100, 50, 0
line_color = ChunkyPNG::Color.rgb 150, 150, 200
canvas     = ChunkyPNG::Canvas.new 1200, 900, bg_color

i = 0

while i < 100
  canvas.circle  600 , 450, 100 , line_color
  canvas.line    500+i, 350+i, 500, 350, line_color
  canvas.line    400+i, 450+i, 400, 450, line_color
  i += 1
end

canvas.save("pic.png")
