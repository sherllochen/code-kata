require_relative '../../lib/config'

describe CodeKata::Config do
  let(:subject) { CodeKata::Config.instance }

  RSpec.shared_examples 'property test' do |property, initial_value, new_value|
    it 'access and assigns the value correctly' do
      expect(subject.send(property)).to eq(initial_value)
      subject.send("#{property}=", new_value)
      expect(subject.send(property)).to eq(new_value)
    end
  end

  describe '.initialize' do
    it_behaves_like 'property test', :log_level, 'INFO', 'ERROR'
  end
end
