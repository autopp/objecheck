describe Objecheck::Validator::Collector do
  let(:collector) { described_class.new(validator) }
  let(:validator) { ::Objecheck::Validator.new({}, {}) }

  describe '#errors' do
    subject { collector.errors }

    it { is_expected.to be_a(Array) }

    it 'returns different object for each call' do
      expect(subject).not_to equal(collector.errors)
    end
  end
end
