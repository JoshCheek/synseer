require 'synseer/parse'

RSpec.describe Synseer::Parse do
  let(:games_dir) { File.expand_path '../games', __dir__ }
  # "smoke" test
  it 'parses the code from all of the games', integration: true do
    Dir[File.join(games_dir, '*')].each do |file|
      begin
        ast = described_class.ast_for File.read(file)
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
end
