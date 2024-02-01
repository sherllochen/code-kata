require 'ffaker'
require_relative '../../../app/formaters/simple_formater'

describe CodeKata::Formaters::SimpleFormater do
  describe '.format' do
    it "extract attributes and return as expected" do
      title = FFaker::Lorem.word
      completed = [true, false].sample
      json = { 'title' => title, 'completed' => completed }

      result = CodeKata::Formaters::SimpleFormater.format(json)

      expect(result).to eq("TITLE: #{title}, COMPLETED: #{completed}")
    end
  end
end