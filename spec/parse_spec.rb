require 'synseer/parse'

RSpec.describe Synseer::Parse do
  let(:games_dir) { File.expand_path '../games', __dir__ }

  def ast_for(code)
    described_class.ast_for(code)
  end

  # "smoke" test
  it 'parses the code from all of the games', integration: true do
    Dir[File.join(games_dir, '*')].each do |file|
      begin
        ast = ast_for File.read file
        expect(ast).to be_a_kind_of Hash
      rescue
        $!.message << "FROM THE FILE #{file.inspect}"
        raise
      end
    end
  end

  it 'can tell you which nodes are in a set of code' do
    expect(described_class.nodes_in('"a"', '1+1')).to eq [:int, :send, :str]
  end

  describe 'ast modification' do
    def nodes_in(code, include_program=false)
      nodes_in = lambda do |ast|
        return [ast] unless ast.kind_of? Hash
        [ast.fetch(:type)] + ast.fetch(:children).flat_map { |child| nodes_in.call child }
      end
      nodes = nodes_in.call ast_for code
      nodes.shift unless include_program
      nodes
    end

    it 'wraps the program in a :program node' do
      expect(nodes_in   '1', true).to eq [:program, :int]
      expect(nodes_in '1;1', true).to eq [:program, :int, :int]
    end

    it 'removes missing nodes' do
      expect(nodes_in 'def a;end').to eq [:def]
    end

    it 'removes args' do
      nodes = nodes_in 'def a(b, c) end'
      expect(nodes).to eq [:def, :arg, :arg]
    end

    it 'removes begin' do
      nodes = nodes_in '1; def a; 1; 1; end'
      expect(nodes).to eq [:int, :def, :int, :int]
    end

    it 'removes pair' do
      nodes = nodes_in '{a:1,"b"=>2}'
      expect(nodes).to eq [:hash, :sym, :int, :str, :int]
    end

    it 'removes when' do
      nodes = nodes_in 'case 1; when 1; else 1; end'
      expect(nodes).to eq [:case, :int, :int, :int]
    end

    it 'removes resbody' do
      nodes = nodes_in 'begin; 1; rescue => e; 1; end'
      expect(nodes).to eq [:kwbegin, :rescue, :int, :lvasgn, :int]
    end
  end
end
