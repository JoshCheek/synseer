class Keybinding
  class Group
    def self.for(name, key, children)
      new(name: name, key: key, children: children)
    end

    attr_reader :name, :key, :children
    def initialize(name:, key:, children:)
      @name     = name
      @key      = key
      @children = children
    end

    def find_data(data)
      @children.each do |child|
        result = child.find_data data
        return result if result
      end
      nil
    end

    def group?
      true
    end

    def empty?
      children.empty?
    end

    def potentials_for(keys_pressed)
      pressed  = keys_pressed.take(key.length)
      no_match = self.class.new(name: name, key: key, children: [])
      pressed.zip(key.chars).each do |expected, actual|
        return no_match if expected != actual
      end
      keys_pressed = keys_pressed.drop(key.length)
      new_children = children.map do |child|
        child.potentials_for keys_pressed
      end
      new_children = new_children.compact.reject { |child| child.group? && child.empty? }

      if new_children.length == 1 && new_children[0].group?
        return new_children[0]
      else
        return self.class.new(name: name, key: '', children: new_children)
      end
    end
  end
end

class Keybinding
  def self.for(data, key, english)
    new(data: data, key: key, english: english)
  end

  attr_reader :data, :key, :english
  def initialize(data:, key:, english:)
    @data    = data
    @key     = key
    @english = english
  end

  def group?
    false
  end

  def find_data(data)
    return self if data == @data
  end

  def potentials_for(keys_pressed)
    return nil if key.length < keys_pressed.length
    keys_pressed.zip(key.chars).each do |expected, actual|
      return nil if expected != actual
    end
    self
  end
end

class Mapper
  def self.normalize(key)
    key = key.downcase
    key = 'escape'  if key == 'esc'
    key = $1.upcase if key =~ /^shift-(.*)$/
    key
  end

  attr_reader :keybindings, :keys_pressed
  def initialize(keybindings)
    @keybindings  = keybindings
    @keys_pressed = []
  end

  def find_data(data)
    keybindings.find_data(data)
  end

  def key_pressed(key)
    key = self.class.normalize(key)
    if key == 'backspace'
      keys_pressed.pop
    elsif key == 'escape'
      keys_pressed.pop until keys_pressed.empty?
    elsif key !~ /^[a-zA-Z]$/
      # noop
    else
      keys_pressed << key
    end
    nil
  end

  def potentials
    keybindings.potentials_for keys_pressed
  end

  def accept
    keys_pressed.pop until keys_pressed.empty?
    nil
  end
end


default_keybindings = Keybinding::Group.for('All Keybindings', '', [
  Keybinding::Group.for('Convenience', '', [
    Keybinding.for('send',  'm', 'method call'),
    Keybinding.for('str',   's', 'literal string'),
    Keybinding.for('lvar',  'l', 'lookup local variable'),
    Keybinding.for('const', 'C', 'lookup constant'),
    Keybinding.for('sym',   'y', 'symbol literal (or S)'),
    Keybinding.for('int',   'i', 'integer literal'),
    Keybinding.for('def',   'd', 'def'),
    Keybinding.for('hash',  'h', 'hash literal'),
    Keybinding.for('block', 'b', 'literal block'),
    Keybinding.for('ivar',  '@', 'lookup instance variable'),
    Keybinding.for('array', 'A', 'array literal'),
  ]),


  Keybinding::Group.for('Hierarchy', '', [
    Keybinding::Group.for('lookup', '-', [
      Keybinding.for('lvar',     'l', 'local variable'),
      Keybinding.for('const',    'C', 'constant'),
      Keybinding.for('ivar',     '@', 'instance variable'),
      Keybinding.for('gvar',     '$', 'global variable'),
      Keybinding.for('cbase',    'o', 'toplevel constant (Object)'),
      Keybinding.for('nth_ref',  'n', 'regexp capture'),
      Keybinding.for('back_ref', '&', 'regexp match'),
      Keybinding.for('cvar',     'c', 'class var (never use these)'),
    ]),

    Keybinding::Group.for('assign', '=', [
      Keybinding.for('lvasgn',   'l', 'local variable'),
      Keybinding.for('ivasgn',   '@', 'instance variable'),
      Keybinding.for('casgn',    'C', 'constant'),
      Keybinding.for('or_asgn',  '|', 'assign if false'),
      Keybinding.for('and_asgn', '&', 'assign if true'),
      Keybinding.for('mlhs',     ',', 'pattern matching'),
      Keybinding.for('masgn',    'm', 'multiple'),
      Keybinding.for('op_asgn',  'o', 'operator'),
      Keybinding.for('gvasgn',   '$', 'global'),
      Keybinding.for('cvasgn',   'c', 'class var (never use these)'),
    ]),
    Keybinding::Group.for('control-flow', 'c', [
      Keybinding.for('if',     'i', 'if statment'),
      Keybinding.for('and',    '&', 'and'),
      Keybinding.for('or',     '|', 'or'),
      Keybinding.for('yield',  'y', 'yield to block'),
      Keybinding.for('return', 'r', 'return'),
      Keybinding.for('case',   'c', 'case'),
      Keybinding::Group.for('loop', 'l', [
        Keybinding.for('until', 'u', 'until true'),
        Keybinding.for('while', 'w', 'while true'),
        Keybinding.for('break', 'b', 'break out'),
        Keybinding.for('next',  'n', 'next iteration'),
      ]),
      Keybinding::Group.for('assign', '=', [
        Keybinding.for('or_asgn',  '|', 'if false'),
        Keybinding.for('and_asgn', '&', 'if true'),
      ]),
      Keybinding::Group.for('begin', 'b', [
        Keybinding.for('kwbegin', 'b', 'begin'),
        Keybinding.for('rescue',  'r', 'rescue exception'),
        Keybinding.for('retry',   't', 'retry the body'),
        Keybinding.for('ensure',  'e', 'ensure this happens'),
      ]),
      Keybinding::Group.for('super', 's', [
        Keybinding.for('zsuper', 'i', 'implicit args'),
        Keybinding.for('super',  'e', 'explicit args'),
      ]),
    ]),

    Keybinding::Group.for('object dsl', 'o', [
      Keybinding.for('send',  'm', 'method call'),
      Keybinding.for('self',  's', 'self (current object)'),
      Keybinding.for('alias', 'a', 'alias method'),
      Keybinding::Group.for('open', 'o', [
        Keybinding.for('class',  'c', 'class'),
        Keybinding.for('module', 'm', 'module'),
        Keybinding.for('sclass', 's', 'singleton class'),
      ]),
      Keybinding::Group.for('define', 'd', [
        Keybinding.for('def',   'd', 'on open class'),
        Keybinding.for('defs',  's', 'on singleton class'),
        Keybinding.for('undef', 'u', 'undefine in open class'),
      ]),
    ]),

    Keybinding::Group.for('argument', 'a', [
      Keybinding.for('block_pass', 'b', 'block'),
      Keybinding.for('splat',      'a', 'array to args'),
      Keybinding.for('kwsplat',    'h', 'hash keywords'),
    ]),

    Keybinding::Group.for('parameter', 'p', [
      Keybinding.for('arg',      'r', 'required'),
      Keybinding.for('optarg',   'o', 'optional'),
      Keybinding.for('restarg',  'a', 'array from rest'),
      Keybinding.for('blockarg', 'b', 'block'),
      Keybinding::Group.for('keyword', 'k', [
        Keybinding.for('kwarg',     'r', 'required'),
        Keybinding.for('kwoptarg',  'o', 'optional'),
        Keybinding.for('kwrestarg', 'h', 'hash from rest'),
      ]),
    ]),

    Keybinding::Group.for('literal', 'j', [
      Keybinding.for('xstr',              '`', 'system command'),
      Keybinding.for('regexp',            '/', 'regular expression'),
      Keybinding.for('match_with_lvasgn', '~', 'match regexp literal'),
      Keybinding.for('irange',            '2', 'range including end'),
      Keybinding.for('erange',            '3', 'range excluding end'),
      Keybinding.for('array',             'A', 'array'),
      Keybinding.for('block',             'b', 'block'),
      Keybinding.for('complex',           'c', 'complex'),
      Keybinding.for('defined?',          'd', 'defined?'),
      Keybinding.for('false',             'f', 'false'),
      Keybinding.for('hash',              'h', 'hash'),
      Keybinding.for('int',               'i', 'integer'),
      Keybinding.for('nil',               'n', 'nil'),
      Keybinding.for('float',             '.', 'floating decimal point'),
      Keybinding.for('rational',          'r', 'rational'),
      Keybinding.for('str',               's', 'string'),
      Keybinding.for('dstr',              'S', 'interpolated string'),
      Keybinding.for('true',              't', 'true'),
      Keybinding.for('sym',               'y', 'symbol'),
      Keybinding.for('dstr',              'Y', 'interpolated string'),
      Keybinding.for('regopt',            'o', 'regexp option'),
    ]),
  ]),
])


RSpec.describe 'Default keymap' do
  it 'has a keybinding for each type of syntax that we use' do
    mapper = Mapper.new default_keybindings
    File.read('tmp/node_types').lines.map(&:chomp).each do |type|
      mapper.find_data(type) || raise("No type for #{type.inspect}")
    end
  end
end

RSpec.describe 'A keybinding' do
  it 'has an english representation, a keysequence, and some data the keysequence maps to' do
    kb = Keybinding.for 'b', 'a',  'c'
    expect(kb.key).to     eq "a"
    expect(kb.data).to    eq "b"
    expect(kb.english).to eq "c"
  end
end

RSpec.describe 'KeyMapper' do
  describe '#find_data' do
    let(:mapper) { Mapper.new keymap }

    let :keymap do
      Keybinding::Group.for('english', '', [
        Keybinding::Group.for('en', 'a', [
          Keybinding.for('c', 'b', 'en'),
          Keybinding.for('e', 'd', 'en')]),
        Keybinding::Group.for('en', 'f', [
          Keybinding.for('h', 'g', 'en'),
          Keybinding::Group.for('en', 'i', [
            Keybinding.for('k', 'j', 'en'),
            Keybinding.for('m', 'l', 'en')]),
          Keybinding::Group.for('en', '', [
            Keybinding.for('o', 'n', 'en'),
            Keybinding.for('q', 'p', 'en')])])])
    end

    it 'can find data' do
      expect(mapper.find_data("c").key).to eq "b"
      expect(mapper.find_data("e").key).to eq "d"
      expect(mapper.find_data("h").key).to eq "g"
      expect(mapper.find_data("k").key).to eq "j"
      expect(mapper.find_data("m").key).to eq "l"
      expect(mapper.find_data("o").key).to eq "n"
      expect(mapper.find_data("q").key).to eq "p"
    end

    it 'returns nil when asked for data it does not have' do
      expect(mapper.find_data 'zz').to eq nil
    end
  end


  describe '.normalize' do
    it 'converts uppercase letters to lowercase letters' do
      expect(Mapper.normalize "M").to eq "m"
    end

    it 'converts "SHIFT-" prefixed inputs to uppercase letters' do
      expect(Mapper.normalize "SHIFT-M").to eq "M"
    end

    it 'conversts "Esc" to "escape"' do
      expect(Mapper.normalize "Esc").to eq "escape"
      expect(Mapper.normalize "esc").to eq "escape"
    end
  end


  describe '#key_pressed' do
    it 'maps a given key-sequence to the requested data' do
      bindings = Keybinding::Group.for('english', '', [
        Keybinding.for('abc', 'lol', 'en'),
        Keybinding.for('wtf', 'def', 'en'),
      ])
      mapper = Mapper.new(bindings)
      mapper.key_pressed("d")
      expect(mapper.potentials.children.map(&:data)).to eq ['wtf']
    end

    it 'remembers my input and gives me back a list of potential matches' do
      bindings = Keybinding::Group.for('english', '', [
        Keybinding.for('and',    'and',    'and'),
        Keybinding.for('arg',    'arg',    'required argument'),
        Keybinding.for('ars',    'args',   'arguments'),
        Keybinding.for('array',  'array',  'array literal'),
        Keybinding.for('asgnor', 'asgnor', 'or assignment'),
        Keybinding.for('other',  'other',  'other'),
      ])
      mapper = Mapper.new(bindings)

      mapper.key_pressed("a")
      expect(mapper.potentials.children.map(&:data)).to eq ['and', 'arg', 'ars', 'array', 'asgnor']

      mapper.key_pressed("r")
      expect(mapper.potentials.children.map(&:data)).to eq ['arg', 'ars', 'array']

      mapper.key_pressed("r")
      expect(mapper.potentials.children.map(&:data)).to eq ['array']
    end

    it 'backspace removes a character from the end of the input' do
      bindings = Keybinding::Group.for('english', '', [
        Keybinding.for('and',    'and',    'and'),
        Keybinding.for('arg',    'arg',    'required argument'),
        Keybinding.for('ars',    'args',   'arguments'),
        Keybinding.for('array',  'array',  'array literal'),
        Keybinding.for('asgnor', 'asgnor', 'or assignment'),
        Keybinding.for('other',  'other',  'other'),
      ])
      mapper = Mapper.new(bindings)

      mapper.key_pressed("a")
      expect(mapper.potentials.children.map(&:data)).to eq ['and', 'arg', 'ars', 'array', 'asgnor']

      mapper.key_pressed("r")
      expect(mapper.potentials.children.map(&:data)).to eq ['arg', 'ars', 'array']

      mapper.key_pressed("backspace")
      expect(mapper.potentials.children.map(&:data)).to eq ['and', 'arg', 'ars', 'array', 'asgnor']
    end

    it 'clears the input when escape is pressed' do
      bindings = Keybinding::Group.for('english', '', [
        Keybinding.for('aa',     'aa',   'aa'),
        Keybinding.for('aba',    'aba',  'aba'),
        Keybinding.for('abc',    'abc',  'abc'),
        Keybinding.for('b',      'b',    'b'),
      ])
      mapper = Mapper.new(bindings)

      mapper.key_pressed("a")
      expect(mapper.potentials.children.map(&:data)).to eq ['aa', 'aba', 'abc']

      mapper.key_pressed("b")
      expect(mapper.potentials.children.map(&:data)).to eq ['aba', 'abc']

      mapper.key_pressed("escape")
      expect(mapper.potentials.children.map(&:data)).to eq ['aa', 'aba', 'abc', 'b']
    end

    it 'ignores non-printable keypresses and tab and enter' do
      bindings = Keybinding::Group.for('english', '', [
        Keybinding.for('abc',  'abc',  'abc'),
        Keybinding.for('ctrl', 'ctrl', 'ctrl (not a meta key, just looks like one to prove no confusion)'),
      ])
      mapper = Mapper.new(bindings)
      does_not_change = -> key do
        mapper.key_pressed(key)
        expect(mapper.potentials.children.map(&:data)).to eq ['abc']
      end

      does_not_change.call 'a'
      does_not_change.call "alt"
      does_not_change.call "cmd-alt-mod"
      does_not_change.call "cmd-ctrl-alt-mod"
      does_not_change.call "cmd-ctrl-mod"
      does_not_change.call "cmd-mod"
      does_not_change.call "ctrl"
      does_not_change.call "ctrl-alt"
      does_not_change.call "enter"
      does_not_change.call "shift-alt"
      does_not_change.call "shift-cmd-ctrl-alt-mod"
      does_not_change.call "shift-cmd-ctrl-mod"
      does_not_change.call "shift-cmd-mod"
      does_not_change.call "shift-ctrl-alt"
      does_not_change.call "shift-ctrl-shift"
      does_not_change.call "shift-shift"
      does_not_change.call "space"
      does_not_change.call "tab"

      does_not_change.call "down"
      does_not_change.call "left"
      does_not_change.call "right"
      does_not_change.call "up"
    end

    it 'allows keybindings to be nested' do
      bindings = Keybinding::Group.for('english', '', [
        Keybinding::Group.for('a', 'a', [
          Keybinding.for('c', 'b', 'cb'),
          Keybinding.for('e', 'd', 'ed'),
        ]),
        Keybinding::Group.for('f', 'f', [
          Keybinding.for('h', 'g', 'hg'),
          Keybinding::Group.for('i', 'i', [
            Keybinding.for('k', 'j', 'kj'),
            Keybinding.for('m', 'l', 'ml'),
          ]),
        ]),
      ])
      mapper = Mapper.new(bindings)

      # no groups
      mapper.key_pressed("a")
      expect(mapper.potentials.children.map(&:data)).to eq ['c', 'e']
      mapper.key_pressed("b")
      expect(mapper.potentials.children.map(&:data)).to eq ['c']

      mapper.key_pressed('escape')

      mapper.key_pressed("f")
      expect(mapper.potentials.children[0].data).to eq 'h'
      expect(mapper.potentials.children[1].children.map(&:data)).to eq ['k', 'm']
      mapper.key_pressed("i")
      expect(mapper.potentials.children.map(&:data)).to eq ['k', 'm']
      mapper.key_pressed("j")
      expect(mapper.potentials.children.map(&:data)).to eq ['k']
    end


    describe '#accept' do
      it 'clears the input when input is accepted' do
        bindings = Keybinding::Group.for('english', '', [
          Keybinding.for('ab', 'ab', 'ab'),
        ])
        mapper = Mapper.new(bindings)

        mapper.key_pressed("a")
        expect(mapper.potentials.children.map(&:data)).to eq ['ab']
        mapper.accept

        mapper.key_pressed("a")
        expect(mapper.potentials.children.map(&:data)).to eq ['ab']
        mapper.key_pressed("a")
        expect(mapper.potentials.children.map(&:data)).to eq []
      end

      it 'normalizes the input' do
        bindings = Keybinding::Group.for('english', '', [
          Keybinding.for('a', 'ka', 'aka'),
          Keybinding.for('b', 'kb', 'bkb'),
          Keybinding.for('c', 'jc', 'cjc'),
        ])
        mapper = Mapper.new(bindings)

        mapper.key_pressed("k")
        expect(mapper.potentials.children.length).to eq 2
        mapper.key_pressed('Esc'); # "Esc" works, so it was normalized to "escape"
        expect(mapper.potentials.children.length).to eq 3
      end
    end

    describe '#possibilities' do
      it 'finds keys pressed in groups that have no keybindings' do
        bindings = Keybinding::Group.for('english', '', [
          Keybinding.for('b', 'a', 'ba'),
          Keybinding::Group.for('no kb', '', [
            Keybinding.for('c', 'b', 'cb'),
            Keybinding.for('e', 'd', 'de'),
          ]),
          Keybinding::Group.for('f', 'f', [
            Keybinding.for('h', 'g', 'hg'),
            Keybinding::Group.for('i', 'i', [
              Keybinding.for('k', 'j', 'kj'),
              Keybinding.for('m', 'l', 'ml'),
            ]),
          ]),
        ])
        mapper = Mapper.new(bindings)

        mapper.key_pressed("a")
        expect(mapper.potentials.children.map(&:data)).to eq ['b']

        mapper.key_pressed("escape")

        mapper.key_pressed("f")
        expect(mapper.potentials.children[0].data).to eq 'h'
        expect(mapper.potentials.children[1].children.map(&:data)).to eq ['k', 'm']
        mapper.key_pressed("i")
        expect(mapper.potentials.children.map(&:data)).to eq ['k', 'm']
        mapper.key_pressed("j")
        expect(mapper.potentials.children.map(&:data)).to eq ['k']
      end
    end
  end
end
