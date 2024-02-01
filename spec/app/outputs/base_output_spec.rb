require_relative '../../../app/outputs/base_output'

describe CodeKata::Outputs::BaseOutput do
  describe '.puts' do
    it 'raises NotImplementedError' do
      expect {
        described_class.puts
      }.to raise_error(NotImplementedError, 'You must implement the #puts method')
    end
  end
end