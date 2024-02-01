require_relative '../../../app/formaters/base_formater'

describe CodeKata::Formaters::BaseFormater do
  describe '.format' do
    it 'raises NotImplementedError' do
      expect {
        described_class.format
      }.to raise_error(NotImplementedError, 'You must implement the #format method')
    end
  end
end