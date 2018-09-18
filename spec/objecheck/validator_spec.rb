describe Objecheck::Validator do
  let(:validator) { described_class.new(schema) }

  describe '#validate' do
    subject { validator.validate(target) }

    context 'when schema require that type is a Hash' do
      let(:schema) { { type: Hash } }

      context 'and when target is a Hash' do
        let(:target) { {} }

        it { is_expected.to be_empty }
      end

      context 'and when target is a Array' do
        let(:target) { [] }

        it { is_expected.not_to be_empty }
      end
    end
  end
end
