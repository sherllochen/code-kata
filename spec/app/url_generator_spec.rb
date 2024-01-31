require_relative '../../app/url_generator'

describe UrlGenerator do
  describe '#generate' do
    it 'raises an error' do
      generator = UrlGenerator.new
      expect { generator.generate }.to raise_error(NotImplementedError, 'You must implement the #generate method')
    end
  end
end

