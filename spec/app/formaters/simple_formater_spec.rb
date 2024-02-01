require 'ffaker'
require_relative '../../../app/formaters/simple_formater'

describe CodeKata::Formaters::SimpleFormater do
  describe '.format' do
    let(:title) { 'foo bar' }
    let(:completed) { [true, false].sample }

    it "extract attributes and return as expected" do
      json = { 'title' => title, 'completed' => completed }

      result = CodeKata::Formaters::SimpleFormater.format(json)

      expect(result).to eq("TITLE: #{title}, COMPLETED: #{completed}")
    end
  end
end