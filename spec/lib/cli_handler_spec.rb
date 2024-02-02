require_relative '../../lib/cli_handler'

describe CodeKata::CLIHandler do
  describe '.parse' do
    before do
      allow(Kernel).to receive(:exit)
      allow(Kernel).to receive(:puts)
    end

    context 'when help command is passed' do
      it 'exits the program with a status code of 1' do
        # Mock to stop parse_arguments from been executed
        expect(CodeKata::CLIHandler).to receive(:parse_arguments)
        expect(CodeKata::CLIHandler).to receive(:exit).with(1)
        expect(CodeKata::CLIHandler).to receive(:puts).with(CodeKata::CLIHandler::USAGE_INSTRUCTION)

        CodeKata::CLIHandler.parse(['-h'])
      end
    end

    context 'when no arguments are passed' do
      it 'returns default total and threads' do
        expect(CodeKata::CLIHandler.parse([])).to eq([CodeKata::CLIHandler::DEFAULT_TOTAL, CodeKata::CLIHandler::DEFAULT_THREADS])
      end
    end

    context 'when valid total and threads are passed' do
      it 'returns the passed total and threads as integers' do
        expect(CodeKata::CLIHandler.parse(%w[100 4])).to eq([100, 4])
      end
    end

    context 'when invalid total or threads are passed' do
      it 'exits the program with a status code of 1' do
        expect(CodeKata::CLIHandler).to receive(:exit).with(1)
        expect(CodeKata::CLIHandler).to receive(:puts).with('Both arguments should be integer')

        CodeKata::CLIHandler.parse(%w[100 invalid])
      end
    end
  end
end