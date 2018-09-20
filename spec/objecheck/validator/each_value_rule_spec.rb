describe Objecheck::Validator::EachValueRule do
  let(:rule) { described_class.new(validator, element_schema) }

  let(:validator) do
    validator = instance_double(Objecheck::Validator)
    rules = { type: Objecheck::Validator::TypeRule.new(validator, Integer) }
    allow(validator).to receive(:compile_schema).with(element_schema).and_return(rules)
    validator
  end
  let(:element_schema) { { type: Integer } }

  describe '#validate' do
    subject { rule.validate(target, collector) }
    let(:collector) { Objecheck::Validator::Collector.new(validator) }

    context 'when target responds to each_pair' do
      context 'and target is empty' do
        let(:target) { {} }

        it 'dose not add error to collector' do
          expect(collector).not_to receive(:add_error)
          subject
        end
      end

      context 'and all values in target are satisfy the schema' do
        let(:target) { { a: 1, b: 2, c: 3 } }

        it 'dose not add error to collector' do
          expect(collector).not_to receive(:add_error)
          subject
        end
      end

      context 'and some values in target are not satisfy the schema' do
        let(:target) { { a: '1', b: 2, c: '3' } }

        it 'add errors to collector' do
          expect(collector).to receive(:add_error).twice
          subject
        end
      end
    end

    context 'when target dose not respond to each_pair' do
      let(:target) { nil }

      it 'add error to collector' do
        expect(collector).to receive(:add_error).with('should respond to `each_pair`')
        subject
      end
    end
  end
end
