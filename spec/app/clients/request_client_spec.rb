require_relative '../../../lib/simple_logger'
require_relative '../../../app/clients/request_client'
require_relative '../../../app/formaters/simple_formater'
require_relative '../../../app/outputs/simple_output'

describe CodeKata::Clients::RequestClient do
  let(:extended_class) do
    Class.new do
      include CodeKata::Clients::RequestClient

      headers({ 'Authorization' => 'Bearer some_token' })
      parser(JSON)
      formater(CodeKata::Formaters::SimpleFormater)
      output(CodeKata::Outputs::SimpleOutput)
    end
  end

  describe '.perform' do
    let(:url) { 'http://example.com' }
    let(:params) { { foo: 'bar' } }
    let(:payload) { { bar: 'foo' } }
    let(:logger) { instance_double(Logger) }

    subject do
      extended_class.perform(method: :post, url: url, params: params, payload: payload)
    end

    describe 'normal process' do
      before do
        expect(RestClient::Request).to receive(:execute)
                                         .with(method: :post,
                                               url: url,
                                               headers: { 'Authorization' => 'Bearer some_token' }.merge({ params: params }),
                                               payload: payload)
                                         .and_return(instance_double(RestClient::Response, body: '{
                                                                                                    "userId": 1,
                                                                                                    "id": 1,
                                                                                                    "title": "foo",
                                                                                                    "completed": false
                                                                                                  }'))
      end

      it 'makes a request and output the result' do
        expect(CodeKata::Outputs::SimpleOutput).to receive(:puts).with('TITLE: foo, COMPLETED: false')

        subject
      end
    end

    describe 'error handling' do
      before do
        allow(logger).to receive(:info)
        allow(logger).to receive(:debug)
        allow(logger).to receive(:error)
        allow(extended_class).to receive(:logger) { logger }
      end

      context 'when request fails and reaches maximum retries' do
        let(:exception) { StandardError.new }

        before do
          allow(RestClient::Request).to receive(:execute).and_raise(exception).exactly(described_class::MAX_RETRIES).times
        end

        it 'raises the exception' do
          expect { subject }.to raise_exception(exception)
        end
      end

      context 'when request fails with http codes that should not retry' do
        let(:exception) { RestClient::ExceptionWithResponse.new }

        before do
          allow(exception).to receive(:http_code).and_return(400)
          allow(RestClient::Request).to receive(:execute).and_raise(exception)
        end

        it 'raises the exception' do
          expect { subject }.to raise_exception(exception)
        end
      end
    end
  end

  describe 'validation' do
    let(:url) { 'http://example.com' }

    class ParserClass
      def self.parse(str) end
    end

    class FormaterClass
      def self.format(json) end
    end

    class OutputClass
      def self.puts(str) end
    end

    describe 'accept duck classes' do
      let(:valid_class) do
        Class.new do
          include CodeKata::Clients::RequestClient

          parser(ParserClass)
          formater(FormaterClass)
          output(OutputClass)
        end
      end

      before do
        expect(ParserClass).to receive(:parse) { { hello: 'world' } }
        expect(FormaterClass).to receive(:format) { 'hello world' }
        expect(OutputClass).to receive(:puts)

        expect(RestClient::Request).to receive(:execute)
                                         .with(method: :get,
                                               url: url)
                                         .and_return(instance_double(RestClient::Response, body: { hello: 'world' }.to_json))
      end

      it 'run without error' do
        expect { valid_class.perform(method: :get, url: url) }.not_to raise_error
      end
    end

    describe 'valid mandatory classes to be declared' do
      let(:invalid_class_1) do
        Class.new do
          include CodeKata::Clients::RequestClient

          formater(FormaterClass)
          output(OutputClass)
        end
      end
      let(:invalid_class_2) do
        Class.new do
          include CodeKata::Clients::RequestClient

          parser(ParserClass)
          output(OutputClass)
        end
      end
      let(:invalid_class_3) do
        Class.new do
          include CodeKata::Clients::RequestClient

          parser(ParserClass)
          formater(FormaterClass)
        end
      end

      it 'raise error when one of them absent' do
        expect { invalid_class_1.perform(method: :get, url: url) }.to raise_error(CodeKata::Clients::RequestClient::NotDeclaredError)
        expect { invalid_class_2.perform(method: :get, url: url) }.to raise_error(CodeKata::Clients::RequestClient::NotDeclaredError)
        expect { invalid_class_3.perform(method: :get, url: url) }.to raise_error(CodeKata::Clients::RequestClient::NotDeclaredError)
      end
    end

  end
end

