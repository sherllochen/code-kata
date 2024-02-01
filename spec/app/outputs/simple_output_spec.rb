require_relative '../../../app/outputs/simple_output'

describe CodeKata::Outputs::SimpleOutput do
  describe ".puts" do
    let(:info_to_log) { 'foo bar' }

    it "logs the input string as info" do
      expect_any_instance_of(Logger).to receive(:info).with(info_to_log)

      described_class.puts(info_to_log)
    end
  end
end