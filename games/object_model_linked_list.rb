# -----  Classes  -----
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


# -----  Hashes  -----

basic_object = {methods: {equal?: 394}, superclass: nil}
object       = {methods: {to_s:   2},   superclass: basic_object}
sting_ray    = {methods: {flap:   1},   superclass: object}
marla        = {class: sting_ray}

marla[:class][:methods][:flap]                             # => 1
marla[:class][:superclass][:methods][:to_s]                # => 2
marla[:class][:superclass][:superclass][:methods][:equal?] # => 394
