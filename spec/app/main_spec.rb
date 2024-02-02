require 'concurrent'
require_relative '../../app/clients/simple_client'
require_relative '../../app/main'
require_relative '../../app/url_generators/incremental_id_url_generator'
require_relative '../../lib/cli_handler'
require_relative '../../lib/simple_logger'
require 'pry-byebug'

describe CodeKata::Main do
  let(:argv) { [5, 2] }
  let(:url_generator) { instance_double(CodeKata::UrlGenerators::IncrementalIdUrlGenerator) }
  let(:urls) { %w(url1 url2 url3 url4 url5) }
  let(:logger) { instance_double(Logger) }
  let(:queue) { instance_double(Queue) }

  before do
    allow(CodeKata::CLIHandler).to receive(:parse).with(argv).and_return([5, 2])
    allow(Concurrent::Promise).to receive(:execute)
    allow(logger).to receive(:info)
    allow(logger).to receive(:error)
    allow(described_class).to receive(:logger) { logger }
  end

  describe 'normal process' do
    before do
      allow(Queue).to receive(:new) { queue }
      allow(queue).to receive(:push)
      allow(queue).to receive(:pop)
      allow(CodeKata::Clients::SimpleClient).to receive(:perform)
      allow(CodeKata::UrlGenerators::IncrementalIdUrlGenerator).to receive(:new).with(5, 0).and_return(url_generator)
      allow(url_generator).to receive(:generate).and_return({ urls: urls })
    end

    it 'push to queue' do
      urls.each { |url| expect(queue).to receive(:push).with(url).ordered }

      described_class.run(argv)
    end

    it 'create thread pool' do
      allow(queue).to receive(:push)
      expect(Concurrent::Promise).to receive(:execute).exactly(2)

      described_class.run(argv)
    end
  end

  context 'when an Interrupt is raised' do
    before do
      allow(Queue).to receive(:new).and_raise(Interrupt)
    end

    it 'logs a SEE YOU message' do
      expect(logger).to receive(:info).with('SEE YOU~')

      described_class.run(argv)
    end
  end

  context 'when a StandardError is raised' do
    let(:error) { StandardError.new('StandardError message') }

    before do
      allow(Queue).to receive(:new).and_raise(error)
    end

    it 'logs an error message' do
      expect(logger).to receive(:error)

      described_class.run(argv)
    end
  end
end