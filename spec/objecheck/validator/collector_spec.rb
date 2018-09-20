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

      expect(collector.errors).to eq([": : #{first}", ": : #{second}"])
    end

    context 'when called at block of #add_prefix_in' do
      it 'records given message with prefix for later retrieval by #errors' do
        first = 'something is wrong'
        second = 'other is also wrong'

        first_prefix = '[0]'
        second_prefix = '.foo'
        collector.add_prefix_in(first_prefix) do
          collector.add_error(first)

          collector.add_prefix_in(second_prefix) do
            collector.add_error(second)
          end
        end

        expect(collector.errors).to eq(["#{first_prefix}: : #{first}", "#{first_prefix}#{second_prefix}: : #{second}"])
      end
    end
  end
end
