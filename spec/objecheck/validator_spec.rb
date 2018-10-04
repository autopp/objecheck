describe Objecheck::Validator do
  let(:validator) { described_class.new(schema, rule_map) }

  let(:rule_map) { { answer: answer_class } }
  let(:answer_class) do
    Class.new do
      def initialize(_validator, param)
        @answer = param
      end

      def validate(target, collector)
        collector.add_error("should have answer which is #{@answer}") if target[:answer] != @answer
      end
    end
  end

  describe '#validate' do
    subject { validator.validate(target) }

    context 'when schema requires to have answer which is 42' do
      let(:schema) { { answer: 42 } }

      context 'and when target matches schema' do
        let(:target) { { answer: 42 } }

        it { is_expected.to be_empty }
      end

      context 'and when target dose not matches schema' do
        let(:target) { {} }

        it { is_expected.to eq(['root: answer: should have answer which is 42']) }
      end
    end
  end

  describe '#compile_schema' do
    subject { validator.compile_schema({ answer: 42 }) }

    let(:schema) { {} }

    it 'returns rules' do
      expect(subject).to match({ answer: a_kind_of(answer_class) })
    end
  end
end
