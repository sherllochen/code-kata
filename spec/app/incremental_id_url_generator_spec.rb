require_relative '../../app/incremental_id_url_generator'

describe IncrementalIdUrlGenerator do
  let(:subject) { IncrementalIdUrlGenerator.new(5, 0) }

  describe '.initialize' do
    it 'correctly initializes with given amount and last id' do
      expect(subject.instance_variable_get(:@amount)).to eql(5)
      expect(subject.instance_variable_get(:@last_id)).to eql(0)
    end
  end

  describe '#generate' do
    it 'generates correct urls and updates last id' do
      # Generate URLs
      result = subject.generate

      expected_urls = %w[https://jsonplaceholder.typicode.com/todos/2
                          https://jsonplaceholder.typicode.com/todos/4
                          https://jsonplaceholder.typicode.com/todos/6
                          https://jsonplaceholder.typicode.com/todos/8
                          https://jsonplaceholder.typicode.com/todos/10]

      expect(result[:urls]).to eql(expected_urls)
      expect(result[:last_id]).to eql(10)
    end
  end
end