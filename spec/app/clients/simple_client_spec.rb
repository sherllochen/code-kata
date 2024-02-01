require_relative '../../../app/clients/simple_client'

describe CodeKata::Clients::SimpleClient do
  describe '.perform' do
    let(:url) { 'https://www.example.com' }
    let(:subject) { described_class.perform(method: :get, url: url) }

    before do
      expect(RestClient::Request).to receive(:execute)
                                       .with(method: :get, url: url)
                                       .and_return(instance_double(RestClient::Response, body: { hello: 'world' }.to_json))
    end

    it 'request successfully' do
      expect { subject }.not_to raise_error
    end

    it 'All classes declared to be used are call correctly' do
      expect(JSON).to receive(:parse)
      expect(CodeKata::Formaters::SimpleFormater).to receive(:format)
      expect(CodeKata::Outputs::SimpleOutput).to receive(:puts)

      subject
    end
  end
end

