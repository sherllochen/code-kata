require_relative '../../../app/url_generators/base_url_generator'

describe CodeKata::UrlGenerators::BaseUrlGenerator do
  describe '#generate' do
    let(:subject) { described_class.new }

    it 'raises an error' do
      expect { subject.generate }.to raise_error(NotImplementedError, 'You must implement the #generate method')
    end
  end
end
