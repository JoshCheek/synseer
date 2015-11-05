module MyEnumerable
  def to_a
    each_with_object([]) { |e, array| array << e }
  end

  def count(&block)
    block ||= Proc.new { true }
    count = 0
    each { |e| count += 1 if block.call e }
    count
  end

  def find(&block)
    each { |e| return e if block.call e }
    nil
  end

  def find_all(&block)
    each_with_object([]) { |e, found| found << e if block.call e }
  end

  def map(&block)
    each_with_object([]) { |e, mapped| mapped << block.call(e) }
  end

  def inject(aggregate, symbol=nil, &block)
    block = (symbol || block).to_proc
    each { |e| aggregate = block.call aggregate, e }
    aggregate
  end

  def group_by(&block)
    each_with_object Hash.new do |e, grouped|
      key = block.call e
      grouped[key] = [] unless grouped.key? key
      grouped[key] << e
    end
  end

  def each_with_object(object, &block)
    each { |e| block.call e, object }
    object
  end

  def take(n)
    each_with_object [] do |e, taken|
      break taken if (n-=1) < 0
      taken << e
    end
  end

  def drop(n)
    each_with_object [] do |e, taken|
      next if 0 <= (n-=1)
      taken << e
    end
  end

  def each_with_index(&block)
    inject 0 do |index, e|
      block.call e, index
      index + 1
    end
    self
  end

  def first(n=nil)
    return take n if n
    each { |e| return e }
    nil
  end

  def all?(&block)
    each { |e| return false unless block.call e }
    true
  end

  def any?(&block)
    !none?(&block)
  end

  def none?(&block)
    all? { |e| !block.call(e) }
  end

  def min_by(&block)
    smallest_element = smallest_value = nil
    each_with_index do |element, index|
      current_value = block.call element
      if index == 0 || current_value < smallest_value
        smallest_value = current_value
        smallest_element = element
      end
    end
    smallest_element
  end

  def max_by(&block)
    largest_element = largest_value = nil
    each_with_index do |element, index|
      current_value = block.call element
      if index == 0 || current_value > largest_value
        largest_value   = current_value
        largest_element = element
      end
    end
    largest_element
  end

  def include?(item)
    any? { |e| e == item }
  end

  def sort(&comparer)
    comparer ||= :<=>.to_proc
    array = to_a

    quick_sort = lambda do |start_index, stop_index|
      return if stop_index <= start_index
      low, high = start_index, stop_index
      while low < high
        next_index = low + 1
        if comparer.call(array[low], array[next_index]) < 0
          array[next_index], array[high] = array[high], array[next_index]
          high -= 1
        else
          array[next_index], array[low] = array[low], array[next_index]
          low += 1
        end
      end
      quick_sort.call start_index, low-1
      quick_sort.call low+1,  stop_index
    end

    quick_sort.call 0, array.length-1
    array
  end
end

RSpec.describe 'MyEnumerable' do
  class MyArray
    include MyEnumerable
    def initialize(array)
      @array = array
    end

    def each(&block)
      @array.each(&block)
    end
  end

  def assert_enum(array, method_name, *args, expected, &block)
    actual = MyArray.new(array).__send__(method_name, *args, &block)
    expect(actual).to eq expected
  end


  specify 'to_a returns an array of the items iterated over' do
    assert_enum [1,2,2], :to_a, [1,2,2]
  end

  describe 'count' do
    specify 'returns how many items the block returns true for' do
      assert_enum([],              :count, 0) { true }
      assert_enum(['a', 'a'],      :count, 2) { true }
      assert_enum(['a', 'b', 'a'], :count, 2) { |char| char == 'a' }
    end

    specify 'returns how many items are in the array, if no block is given' do
      assert_enum [],         :count, 0
      assert_enum ['a'],      :count, 1
      assert_enum ['a', 'a'], :count, 2
    end
  end

  specify 'find returns the first item where the block returns true' do
    assert_enum([],                       :find,   nil) { true }
    assert_enum([1, 2],                   :find,     1) { true }
    assert_enum(['a', 'bcd', 'a', 'xyz'], :find, 'bcd') { |str| str.length == 3 }
    assert_enum([1, 2],                   :find,   nil) { false }
  end

  specify 'find_all returns all the items where the block returns true' do
    assert_enum([], :find_all, []) { true }
    assert_enum([], :find_all, []) { false }

    ary = [1,2,1,3,2,6]
    assert_enum(ary, :find_all,       ary) { true }
    assert_enum(ary, :find_all,        []) { false }
    assert_enum(ary, :find_all, [1, 1, 3]) { |i| i.odd? }
    assert_enum(ary, :find_all, [2, 2, 6]) { |i| i.even? }
  end

  specify 'map returns an array of elements that have been passed through the block' do
    assert_enum([],         :map,         []) { 1 }
    assert_enum(['a', 'b'], :map,     [1, 1]) { 1 }
    assert_enum(['a', 'b'], :map, ['A', 'B']) { |char| char.upcase }
  end

  describe 'inject' do
    it 'passes an aggregate value through the block, along with each element' do
      assert_enum([],     :inject, 0,  0) { |sum, num| sum + num }
      assert_enum([5, 8], :inject, 0, 13) { |sum, num| sum + num }
      assert_enum([5, 8], :inject, 1, 14) { |sum, num| sum + num }

      assert_enum(['a', 'b'], :inject, '', 'ab') { |str, char| str + char }
    end

    it 'can take a symbol, and call the method of that name in place of the block' do
      assert_enum([],     :inject, 0, :+, 0)
      assert_enum([5, 8], :inject, 0, :+, 13)
    end

    it 'prefers the symbol to the block' do
      assert_enum([5, 8], :inject, 1, :+, 14) { |product, num| product * num }
    end
  end

  specify 'group_by returns a hash whose keys come from the block, and whose values are the elements we passed to the block, in array' do
    assert_enum([*1..5], :group_by, {true => [1,3,5], false => [2,4]}) { |n| n.odd? }
    assert_enum(['abc', 'lo', 'lol', 'lkjs'], :group_by, {3 => ['abc', 'lol'], 2 => ['lo'], 4 => ['lkjs']}) { |str| str.length }
  end

  describe 'first' do
    specify 'returns the first item in the collection' do
      assert_enum([], :first, nil)
      assert_enum([1], :first, 1)
      assert_enum([1, 2], :first, 1)
    end

    specify 'delegates to take, if given a number to take' do
      assert_enum [1,2,3], :first, 2, [1,2]
    end
  end

  specify 'all? returns true if the block returns true for each item in the array' do
    assert_enum([],  :all?, true) { true }
    assert_enum([],  :all?, true) { false }
    assert_enum([1], :all?, true) { 1 }
    assert_enum([1], :all?, true) { |n| n == 1 }
    assert_enum([1], :all?, false) { |n| n == 2 }
    assert_enum([1, 2], :all?, false) { |n| n == 2 }
    assert_enum([1, 2], :all?, true) { |n| n < 3 }
  end

  specify 'any? returns true if the block returns true for any item in the array' do
    assert_enum([],     :any?, false) { true }
    assert_enum([],     :any?, false) { false }
    assert_enum([1],    :any?, true) { 1 }
    assert_enum([1],    :any?, true) { |n| n == 1 }
    assert_enum([1],    :any?, false) { |n| n == 2 }
    assert_enum([1, 2], :any?, true) { |n| n == 2 }
    assert_enum([1, 2], :any?, false) { |n| n < 0 }
  end

  specify 'none? returns true if the block returns false for each item in the array' do
    assert_enum([],     :none?, true)  { true }
    assert_enum([],     :none?, true)  { false }
    assert_enum([1],    :none?, false) { 1 }
    assert_enum([1],    :none?, false) { |n| n == 1 }
    assert_enum([1],    :none?, true)  { |n| n == 2 }
    assert_enum([1, 2], :none?, false) { |n| n == 2 }
    assert_enum([1, 2], :none?, true)  { |n| n < 0 }
  end


  describe 'min_by' do
    it 'returns the smallest element, compared by the return values from the block' do
      assert_enum([],           :min_by,   nil) { |s| s }
      assert_enum(['z', 'abc'], :min_by, 'abc') { |s| s }
      assert_enum(['abc', 'z'], :min_by,   'z') { |s| s.length }
      assert_enum(['abc', 'z'], :min_by, 'abc') { |s| s }
      assert_enum([nil, false], :min_by,   nil) { |bool| bool == nil ? -1 :  1  }
      assert_enum([nil, false], :min_by, false) { |bool| bool == nil ?  1 : -1  }
    end

    it 'returns the first seen, when there are multiple results with the same value' do
      assert_enum(['a', 'b'], :min_by, 'a') { 1 }
      assert_enum(['b', 'a'], :min_by, 'b') { 1 }
    end
  end


  describe 'max_by' do
    it 'returns the largest element, compared by the return values from the block' do
      assert_enum([],           :max_by,   nil) { |s| s }
      assert_enum(['z', 'abc'], :max_by,   'z') { |s| s }
      assert_enum(['abc', 'z'], :max_by, 'abc') { |s| s.length }
      assert_enum(['abc', 'z'], :max_by,   'z') { |s| s }
      assert_enum([nil, false], :max_by, false) { |bool| bool == nil ? -1 :  1  }
      assert_enum([nil, false], :max_by,   nil) { |bool| bool == nil ?  1 : -1  }
    end

    it 'returns the first seen, when there are multiple results with the same value' do
      assert_enum(['a', 'b'], :max_by, 'a') { 1 }
      assert_enum(['b', 'a'], :max_by, 'b') { 1 }
    end
  end

  specify 'include? returns true if the item is in the collection' do
    assert_enum [],     :include?, 1, false
    assert_enum [1],    :include?, 1, true
    assert_enum [2, 1], :include?, 1, true
    assert_enum [1, 2], :include?, 1, true

    assert_enum [1],    :include?, 3, false
    assert_enum [2, 1], :include?, 3, false
  end

  describe 'each_with_index' do
    specify 'each_with_index hands the block each item from the collection, and also the index, starting at zero' do
      seen = []
      MyArray.new([]).each_with_index { |e, i| seen << e << i }
      expect(seen).to eq []

      seen = []
      MyArray.new(['a','b','c']).each_with_index { |e, i| seen << e << i }
      expect(seen).to eq ['a', 0, 'b', 1, 'c', 2]
    end

    it 'returns the collection iterated over' do
      my_ary = MyArray.new([])
      expect(my_ary.each_with_index { }).to equal my_ary

      my_ary = MyArray.new([1])
      expect(my_ary.each_with_index { }).to equal my_ary
    end
  end

  specify 'each_with_object hands the block the item, and an object, and returns the object' do
    assert_enum([], :each_with_object, '', '') { }

    assert_enum(['a', 'b'], :each_with_object, '', 'ab') do |char, string|
      string << char
      nil
    end
  end

  specify 'take returns the first available n items' do
    assert_enum([],              :take, 1, [])
    assert_enum([1],             :take, 0, [])
    assert_enum([1],             :take, 1, [1])
    assert_enum([1,2],           :take, 1, [1])
    assert_enum(['a', 'b', 'c'], :take, 2, ['a', 'b'])
  end

  specify 'drop returns whatever items wouldn\'t get taken by take' do
    assert_enum([],              :drop, 1, [])
    assert_enum([1],             :drop, 0, [1])
    assert_enum([1],             :drop, 1, [])
    assert_enum([1,2],           :drop, 1, [2])
    assert_enum(['a', 'b', 'c'], :drop, 2, ['c'])
  end


  it 'sort... sorts the items :P' do
    assert_enum [], :sort, []
    assert_enum [1,2,3], :sort, [1,2,3]
    assert_enum [3,2,1], :sort, [1,2,3]
    assert_enum([1, 0], :sort, [0, 1])
    100.times do |upper_bound|
      sorted = 0.upto(upper_bound).to_a
      assert_enum(sorted.shuffle, :sort, sorted)
      assert_enum(sorted.shuffle, :sort, sorted) { |n1, n2| n1 <=> n2 }
      assert_enum(sorted.shuffle, :sort, sorted.reverse) { |n1, n2| n2 <=> n1 }
    end
  end
end

# maybe bonus:
#   :sort_by,
#   :each_slice,
#   :each_cons,
#   :zip,
#   :take_while,
#   :drop_while,
