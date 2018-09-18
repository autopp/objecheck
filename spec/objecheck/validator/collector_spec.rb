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

  describe '#add_prefix_in' do
    it { expect { |b| collector.add_prefix_in('[0]', &b) }.to yield_control }
  end

  describe '#add_error' do
    it 'records given message for later retrieval by #errors' do
      first = 'something is wrong'
      second = 'other is also wrong'
      collector.add_error(first)
      collector.add_error(second)

      expect(collector.errors).to eq([first, second])
    end
  end
end
