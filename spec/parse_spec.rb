require 'synseer/parse'

RSpec.describe Synseer::Parse do
  let(:games_dir) { File.expand_path '../games', __dir__ }
  # "smoke" test
  it 'parses the code from all of the games' do
    Dir[File.join(games_dir, '*')].each do |file|
      ast = described_class.ast_for File.read(file)
      expect(ast).to be_a_kind_of Hash
    end
  end
end
