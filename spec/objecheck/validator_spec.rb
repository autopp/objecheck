describe Objecheck::Validator do
  let(:validator) { described_class.new(schema, rule_map) }

  let(:schema) { { answer: 42 } }
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
    subject { validator.compile_schema(src) }

    let(:src) { { answer: 42 } }

    it 'returns rules' do
      expect(subject).to match({ answer: a_kind_of(answer_class) })
    end

    context 'when rule class defines schema of parameter' do
      before do
        answer_class.module_eval do
          def self.schema
            [{ type: Numeric }]
          end
        end
      end

      context 'and when given parameter matches schema' do
        it 'returns rules' do
          expect(subject).to match({ answer: a_kind_of(answer_class) })
        end
      end

      context 'and when given parameter dose not matche schema' do
        let(:src) { { answer: 'foo' } }

        it 'raises error' do
          expect { subject }.to raise_error(Objecheck::Error)
        end
      end
    end
  end
end
