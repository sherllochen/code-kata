require_relative '../../lib/simple_logger'

describe CodeKata::SimpleLogger do
  let(:config_instance) { CodeKata::Config.instance }
  let(:base_class) { Class.new { include CodeKata::SimpleLogger } }

  before do
    # Stub the CodeKata::Config instance methods used in module
    allow(config_instance).to receive(:log_level).and_return('DEBUG')

    # Stub File.open to prevent actual file operations during test
    allow(File).to receive(:open).and_return(StringIO.new)
  end

  describe '#logger' do
    it 'creates a new logger with the specified level and output' do
      expect(Logger).to receive(:new).with(instance_of(described_class::ClassMethods::MultiIO),
                                           described_class::LOG_SHIFT_SIZE,
                                           described_class::LOG_FILE_SIZE).and_call_original

      base_class.logger
    end

    it 'reuses the same logger for multiple calls' do
      expect(base_class.logger).to eq base_class.logger
    end

    it 'sets the logger level according to the config' do
      expect(base_class.logger.level).to eq Logger::DEBUG
    end
  end

  describe '#multi_logger_output' do
    let(:outputs) { base_class.multi_logger_output.instance_variable_get("@targets") }

    it 'output to both log file and STDOUT' do
      expect(outputs.length).to eq 2
      expect(outputs[0].is_a?(StringIO)).to be_truthy
      expect(outputs[1]).to eq STDOUT
    end
  end
end