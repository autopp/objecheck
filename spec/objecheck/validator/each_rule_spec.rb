describe Objecheck::Validator::EachRule do
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

    context 'when target responds to each' do
      context 'and target is empty' do
        let(:target) { [] }

        it 'dose not add error to collector' do
          expect(collector).not_to receive(:add_error)
          subject
        end
      end

      context 'and all elements in target are satisfy the schema' do
        let(:target) { [1, 2, 3] }

        it 'dose not add error to collector' do
          expect(collector).not_to receive(:add_error)
          subject
        end
      end

      context 'and some elements in target are not satisfy the schema' do
        let(:target) { ['1', 2, '3'] }

        it 'add errors to collector' do
          expect(collector).to receive(:add_error).twice
          subject
        end
      end
    end

    context 'when target dose not respond to each' do
      let(:target) { nil }

      it 'add error to collector' do
        expect(collector).to receive(:add_error).with('should respond to `each`')
        subject
      end
    end
  end
end
