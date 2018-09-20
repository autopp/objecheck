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

        it { is_expected.to eq(['root: the type should be a Hash (got Array)']) }
      end
    end
  end

  describe '#compile_schema' do
    subject { validator.compile_schema({ type: Array }) }

    let(:schema) { { type: Hash } }

    it 'returns rules' do
      expect(subject).to match({ type: a_kind_of(Objecheck::Validator::TypeRule) })
    end
  end
end
